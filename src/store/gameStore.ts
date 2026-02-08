import { create } from 'zustand'
import type { GameState, GameActions, Phase, Effect, GameSettings, BudgetAllocation } from './types'
import { saveGame, loadGame } from '../engine/save'
import { getUpgradeData } from '../data/upgradeRegistry'
import { calculateUpgradeCost, calculateGPS, calculateLegitimacyDecay, calculateLegitimacyRecovery, calculateBudgetEffects } from '../engine/formulas'
import { checkEventTrigger, selectEvent, scheduleNextEvent } from '../engine/events'
import { updateContradictions } from '../engine/contradictions'
import { checkPhaseTransition } from '../engine/phases'
import { PHASE1_EVENTS } from '../data/phase1/events'
import { INSTITUTIONS, getInstitutionDef, getActionDef, type InstitutionActionType } from '../data/phase2/institutions'
import { TARIFFS } from '../data/phase2/tariffs'
import { PHASE2_EVENTS } from '../data/phase2/events'
import { PHASE3_EVENTS } from '../data/phase3/events'
import { COUNTRIES, AZURE_STATE, getTacticDef, type TacticType } from '../data/phase3/countries'
import { getShipClassDef, getShipyardCost, SHIP_CLASSES } from '../data/phase3/fleet'
import { PHASE4_EVENTS } from '../data/phase4/events'
import { PHASE5_EVENTS } from '../data/phase5/events'
import {
  getProbeUpgradeDef, getDysonSwarmDef, getStarBrandingDef, getBlackHoleDef,
  getNarrativeResearchDef, PROBE_UPGRADES, DYSON_SWARM_TIERS, STAR_BRANDING_TIERS,
  BLACK_HOLE_UPGRADES, NARRATIVE_RESEARCH,
  TOTAL_REACHABLE_STARS, COMPUTRONIUM_PER_STAR, GU_PER_COMPUTRONIUM,
  PROBE_REPLICATION_BASE, STAR_DRIFT_PER_CONVERSION,
} from '../data/phase5/universe'
import {
  getNextLaunchTier, getLunarBuildingDef, getMarsUpgradeDef, getAsteroidTierDef,
  LUNAR_BUILDINGS, MARS_UPGRADES, ASTEROID_TIERS, PROPAGANDA_SATELLITE, DYSON_PROTOTYPE,
  hasLaunchTier, getLaunchTierDef,
} from '../data/phase4/space'
import { getSpaceWeaponDef } from '../data/phase4/weapons'
import { getBridgeUpgradeDef } from '../data/phase4/bridgeUpgrades'
import { calculateDriftRate, calculateDriftReduction, getDriftCap } from '../engine/realityDrift'
import { getPrestigeUpgradeDef, calculatePrestigePoints, PRESTIGE_UPGRADES } from '../data/prestige'

const ALL_EVENTS = [...PHASE1_EVENTS, ...PHASE2_EVENTS, ...PHASE3_EVENTS, ...PHASE4_EVENTS, ...PHASE5_EVENTS]

// ── Initial State ──
// Phase 1 starting values. Later phases initialize their state on transition.

const now = Date.now()

export const INITIAL_STATE: GameState = {
  phase: 1,
  startedAt: now,
  lastTickAt: now,
  lastSaveAt: now,
  totalPlayTime: 0,
  prestigeLevel: 0,
  prestigePoints: 0,

  greatness: 0,
  greatnessPerSecond: 0,
  cash: 0,
  attention: 0,
  influence: 0,

  loyalty: 0,
  control: 0,
  legitimacy: 100,
  surveillance: 0,

  budget: {
    healthcare: 20,
    education: 20,
    socialBenefits: 15,
    military: 10,
    dataCenters: 5,
    infrastructure: 15,
    propagandaBureau: 10,
    spaceProgram: 5,
  },

  tariffs: {},
  dataCenterUpgrades: {},
  loyaltyUpgrades: {},

  treatyPower: 0,
  sanctions: 0,
  annexationPoints: 0,
  warOutput: 0,
  nobelScore: 0,
  nobelPrizesWon: 0,
  nobelThreshold: 100,
  fear: 0,

  rocketMass: 0,
  orbitalIndustry: 0,
  miningOutput: 0,
  colonists: 0,
  terraformProgress: 0,

  computronium: 0,
  greatnessUnits: 0,
  realityDrift: 0,
  starsConverted: 0,
  probesLaunched: 0,

  doublethinkTokens: 0,

  clickCount: 0,
  attentionPerClick: 1,

  upgrades: {},
  institutions: {},
  countries: {},
  fleet: {},
  shipyardLevel: 0,
  shipyardQueue: null,
  space: {
    launchTier: 'none',
    moonBase: false,
    helium3Mining: false,
    lunarShipyard: false,
    lunarHeritage: false,
    marsColony: false,
    marsRenamed: false,
    atmosphereProcessing: false,
    waterExtraction: false,
    asteroidRigs: 0,
    asteroidProspectors: 0,
    asteroidRefineries: 0,
    propagandaSatellites: 0,
    dysonSwarms: 0,
    vonNeumannProbes: 0,
    spaceWeapons: {},
    bridgeUpgrades: {},
  },

  universe: {
    probeUpgrades: {},
    probeFactories: 0,
    dysonUpgrades: {},
    starBrandingUpgrades: {},
    blackHoleUpgrades: {},
    blackHoles: 0,
    narrativeResearch: {},
    universeConverted: 0,
    endingTriggered: false,
    endingComplete: false,
  },

  contradictions: {
    attention_credibility: {
      sideA: 50, // Attention
      sideB: 50, // Credibility
      balancedTime: 0,
      active: true,
    },
  },

  eventQueue: [],
  eventHistory: [],
  activeEvent: null,
  nextEventAt: now + 120_000, // first event after 2 minutes

  achievements: {},
  prestigeUpgrades: {},

  pendingTransition: null,

  settings: {
    musicVolume: 0.5,
    sfxVolume: 0.7,
    notificationsEnabled: true,
    theme: 'default',
  },
}

// ── Store ──

export type GameStore = GameState & GameActions

export const useGameStore = create<GameStore>()((set, get) => ({
  ...INITIAL_STATE,

  tick: (now: number) => {
    const state = get()
    const dt = (now - state.lastTickAt) / 1000 // delta in seconds

    if (dt <= 0 || dt > 60) return

    const newTotalPlayTime = state.totalPlayTime + dt

    // Cash from cashPerSecond effects
    let cashPerSec = 0
    for (const [id, upgrade] of Object.entries(state.upgrades)) {
      if (upgrade.purchased && upgrade.count > 0) {
        const data = getUpgradeData(id)
        if (data?.effects) {
          for (const effect of data.effects) {
            if (effect.type === 'cashPerSecond') {
              cashPerSec += effect.value * upgrade.count
            }
          }
        }
      }
    }

    // Recalculate GpS from formulas
    const computedGPS = calculateGPS(state)

    // Update contradictions
    const contradictionResult = updateContradictions(state, dt, state.attention)

    // Apply budget effects to cash generation (Phase 2+)
    let cashMult = 1
    let tariffCash = 0
    let tariffLegitimacyDrain = 0
    if (state.phase >= 2) {
      const budgetEffects = calculateBudgetEffects(state)
      cashMult = 1 + budgetEffects.infraBonus

      // Tariff income + legitimacy drain
      for (const tariffDef of TARIFFS) {
        const tariff = state.tariffs[tariffDef.id]
        if (tariff && tariff.active && tariff.level > 0) {
          tariffCash += tariffDef.cashPerMinute[tariff.level] / 60 // per second
          tariffLegitimacyDrain += tariffDef.legitimacyDrain[tariff.level]
        }
      }
    }

    // Calculate legitimacy changes (Phase 2+)
    let newLegitimacy = state.legitimacy
    if (state.phase >= 2) {
      const decay = calculateLegitimacyDecay(state)
      const recovery = calculateLegitimacyRecovery(state)
      // Fear drains legitimacy: -0.5% per 100 Fear
      const fearDrain = state.phase >= 3 ? (state.fear * 0.005) : 0
      // Prestige: golden_constant sets a floor at 25%
      const legFloor = state.prestigeUpgrades['the_golden_constant'] ? 25 : 0
      newLegitimacy = Math.max(legFloor, Math.min(100, state.legitimacy + (recovery - decay - fearDrain + tariffLegitimacyDrain) * dt))
    }

    const updates: Partial<GameState> = {
      greatness: state.greatness + computedGPS * dt,
      greatnessPerSecond: computedGPS,
      cash: state.cash + (cashPerSec * cashMult + tariffCash) * dt,
      legitimacy: newLegitimacy,
      totalPlayTime: newTotalPlayTime,
      lastTickAt: now,
      contradictions: contradictionResult.contradictions,
      doublethinkTokens: contradictionResult.doublethinkTokens,
    }

    // Nobel Prize check (Phase 3+)
    if (state.phase >= 3 && state.nobelScore >= state.nobelThreshold) {
      updates.nobelPrizesWon = state.nobelPrizesWon + 1
      updates.nobelScore = 0
      // Diminishing returns: threshold increases 50% each prize
      updates.nobelThreshold = Math.round(state.nobelThreshold * 1.5)
      // Nobel Prize gives legitimacy boost and greatness
      updates.legitimacy = Math.min(100, (updates.legitimacy ?? state.legitimacy) + 15)
      updates.greatness = (updates.greatness ?? state.greatness) + state.nobelThreshold * 100
    }

    // Check phase transition
    if (!state.pendingTransition) {
      const nextPhase = checkPhaseTransition(state)
      if (nextPhase !== null) {
        updates.pendingTransition = { from: state.phase, to: nextPhase }
      }
    }

    // Check event triggers
    if (checkEventTrigger(state, now)) {
      const event = selectEvent(state, ALL_EVENTS)
      if (event) {
        updates.activeEvent = event
        updates.nextEventAt = scheduleNextEvent(state.phase, now, state)
      } else {
        // No eligible event — try again in 30 seconds
        updates.nextEventAt = now + 30_000
      }
    }

    set(updates as Partial<GameStore>)

    // Tick institution progress (Phase 2+)
    if (state.phase >= 2) {
      get().tickInstitutions(dt)
    }

    // Tick country operations (Phase 3+)
    if (state.phase >= 3) {
      get().tickCountries(dt)
      get().tickShipyard(dt)
    }

    // Tick space production (Phase 4+)
    if (state.phase >= 4) {
      get().tickSpace(dt)
    }

    // Tick cosmic production (Phase 5+)
    if (state.phase >= 5) {
      get().tickCosmic(dt)
    }
  },

  click: () => {
    set(state => ({
      attention: state.attention + state.attentionPerClick,
      clickCount: state.clickCount + 1,
      // In Phase 1, clicks directly produce Greatness too
      greatness: state.greatness + state.attentionPerClick * 0.1,
    }))
  },

  purchaseUpgrade: (id: string) => {
    const state = get()
    const data = getUpgradeData(id)
    if (!data) return

    const currentUpgrade = state.upgrades[id]
    const count = currentUpgrade?.count ?? 0

    // Check max count
    if (count >= data.maxCount) return

    // Calculate cost
    const cost = calculateUpgradeCost(data.baseCost, count)

    // Check affordability
    const resourceKey = data.costResource as keyof GameState
    const currentResource = state[resourceKey]
    if (typeof currentResource !== 'number' || currentResource < cost) return

    // Deduct cost
    const updates: Partial<GameState> = {
      [resourceKey]: currentResource - cost,
    }

    // Apply immediate effects
    if (data.effects) {
      for (const effect of data.effects) {
        if (effect.type === 'attentionPerClick') {
          updates.attentionPerClick = (state.attentionPerClick || 1) + effect.value
        }
        // cashPerSecond and gpsMultiplier are handled in tick/formulas
      }
    }

    // Update upgrade state
    updates.upgrades = {
      ...state.upgrades,
      [id]: {
        purchased: true,
        count: count + 1,
        unlocked: true,
      },
    }

    set(updates as Partial<GameStore>)
  },

  unlockUpgrade: (id: string) => {
    set(state => ({
      upgrades: {
        ...state.upgrades,
        [id]: { ...(state.upgrades[id] ?? { purchased: false, count: 0, unlocked: false }), unlocked: true },
      },
    }))
  },

  resolveEvent: (choiceIndex: number) => {
    const state = get()
    if (!state.activeEvent) return

    const choice = state.activeEvent.choices[choiceIndex]
    if (!choice) return

    // Apply all effects from the chosen option
    for (const effect of choice.effects) {
      get().applyEffect(effect)
    }

    set(state => ({
      eventHistory: [...state.eventHistory, state.activeEvent!.id],
      activeEvent: null,
    }))
  },

  dismissEvent: () => {
    set({ activeEvent: null })
  },

  save: () => {
    const state = get()
    saveGame(state)
    set({ lastSaveAt: Date.now() })
  },

  load: () => {
    const saved = loadGame()
    if (saved) {
      // Preserve actions, override state
      set({ ...saved, lastTickAt: Date.now() })
      return true
    }
    return false
  },

  reset: () => {
    const now = Date.now()
    set({
      ...INITIAL_STATE,
      startedAt: now,
      lastTickAt: now,
      lastSaveAt: now,
      nextEventAt: now + 120_000,
      pendingTransition: null,
    })
  },

  setPhase: (phase: Phase) => {
    set({ phase })
  },

  triggerPhaseTransition: (from: Phase, to: Phase) => {
    set({ pendingTransition: { from, to } })
  },

  completePhaseTransition: () => {
    const state = get()
    const transition = state.pendingTransition
    if (!transition) return

    // Advance the phase
    const updates: Partial<GameState> = {
      phase: transition.to,
      pendingTransition: null,
    }

    // Phase 2 initialization: create institutions
    if (transition.to === 2) {
      const institutions: Record<string, import('./types').InstitutionState> = {}
      for (const inst of INSTITUTIONS) {
        institutions[inst.id] = {
          status: 'independent',
          resistance: inst.resistance,
          progress: 0,
          actionStartedAt: null,
          rebranded: false,
        }
      }
      updates.institutions = institutions
      // Activate Phase 2 contradiction: Control vs Legitimacy
      updates.contradictions = {
        ...state.contradictions,
        control_legitimacy: {
          sideA: 0,   // Control
          sideB: 100,  // Legitimacy
          balancedTime: 0,
          active: true,
        },
      }
    }

    // Phase 3 initialization: create countries + Azure State
    if (transition.to === 3) {
      const countries: Record<string, import('./types').CountryState> = {}
      // Prestige: country resistance reduction
      let resistReduction = 0
      for (const pu of PRESTIGE_UPGRADES) {
        if (state.prestigeUpgrades[pu.id] && pu.effect.type === 'country_resistance') {
          resistReduction += pu.effect.value
        }
      }
      for (const country of COUNTRIES) {
        countries[country.id] = {
          status: 'independent',
          resistance: country.startingResistance * (1 - resistReduction),
          stability: country.startingStability,
          activeOperations: [],
          refugeeWavesSent: 0,
          encirclement: 0,
          tradeDependency: 0,
          purchaseOffers: 0,
          kompromatLevel: 0,
        }
      }
      // Azure State special entity
      countries['azure_state'] = {
        status: 'allied',
        resistance: 60,
        stability: 90,
        activeOperations: [],
        refugeeWavesSent: 0,
        encirclement: 0,
        tradeDependency: 0,
        purchaseOffers: 0,
        kompromatLevel: AZURE_STATE.kompromatlevel,
      }
      updates.countries = countries
      updates.shipyardLevel = 1  // Start with 1 shipyard
      // Activate Phase 3 contradictions
      updates.contradictions = {
        ...state.contradictions,
        war_nobel: {
          sideA: 50,   // War Output
          sideB: 50,   // Nobel Score
          balancedTime: 0,
          active: true,
        },
        expansion_stability: {
          sideA: 0,    // Expansion
          sideB: 100,  // Stability
          balancedTime: 0,
          active: true,
        },
      }
    }

    // Phase 4 initialization
    if (transition.to === 4) {
      updates.space = {
        launchTier: 'none',
        moonBase: false,
        helium3Mining: false,
        lunarShipyard: false,
        lunarHeritage: false,
        marsColony: false,
        marsRenamed: false,
        atmosphereProcessing: false,
        waterExtraction: false,
        asteroidRigs: 0,
        asteroidProspectors: 0,
        asteroidRefineries: 0,
        propagandaSatellites: 0,
        dysonSwarms: 0,
        vonNeumannProbes: 0,
        spaceWeapons: {},
        bridgeUpgrades: {},
      }
      updates.rocketMass = 0
      updates.orbitalIndustry = 0
      updates.miningOutput = 0
      updates.colonists = 0
      updates.terraformProgress = 0
      // Activate Phase 4 contradiction: Long-Term vs Short-Term
      updates.contradictions = {
        ...state.contradictions,
        longterm_shortterm: {
          sideA: 50,  // Long-term (space progress)
          sideB: 50,  // Short-term (attention/fear)
          balancedTime: 0,
          active: true,
        },
      }
    }

    // Phase 5 initialization
    if (transition.to === 5) {
      updates.universe = {
        probeUpgrades: {},
        probeFactories: 0,
        dysonUpgrades: {},
        starBrandingUpgrades: {},
        blackHoleUpgrades: {},
        blackHoles: 0,
        narrativeResearch: {},
        universeConverted: 0,
        endingTriggered: false,
        endingComplete: false,
      }
      updates.computronium = 0
      updates.greatnessUnits = 0
      // Don't reset probesLaunched/starsConverted — they may have come from Phase 4 prototype
      // Activate Phase 5 contradiction: Greatness vs Meaning
      updates.contradictions = {
        ...state.contradictions,
        greatness_meaning: {
          sideA: 50,  // Greatness (production rate)
          sideB: 50,  // Meaning (inverse of drift)
          balancedTime: 0,
          active: true,
        },
      }
    }

    set(updates as Partial<GameStore>)

    // Auto-save after transition
    get().save()
  },

  updateSettings: (updates: Partial<GameSettings>) => {
    set(state => ({
      settings: { ...state.settings, ...updates },
    }))
  },

  setBudget: (updates: Partial<BudgetAllocation>) => {
    set(state => ({
      budget: { ...state.budget, ...updates },
    }))
  },

  startInstitutionAction: (institutionId: string, actionType: string) => {
    const state = get()
    const inst = state.institutions[institutionId]
    if (!inst) return

    const def = getInstitutionDef(institutionId)
    const actionDef = getActionDef(actionType as InstitutionActionType)
    if (!def || !actionDef) return

    // Check if already in an action (co-opting, replacing, purging)
    if (inst.status === 'co-opting' || inst.status === 'replacing' || inst.status === 'purging') return

    // Check if post-capture action requires captured status
    if (actionDef.requiresCaptured && inst.status !== 'captured') return

    // Check costs
    if (state.cash < actionDef.costCash) return
    if (state.loyalty < actionDef.costLoyalty) return

    // Determine new status during action
    let newStatus: import('./types').InstitutionStatus = inst.status
    if (actionType === 'co-opt') newStatus = 'co-opting'
    else if (actionType === 'replace') newStatus = 'replacing'
    else if (actionType === 'purge') newStatus = 'purging'

    const updates: Partial<GameState> = {
      cash: state.cash - actionDef.costCash,
      loyalty: state.loyalty - actionDef.costLoyalty,
      legitimacy: Math.max(0, Math.min(100, state.legitimacy + actionDef.legitimacyImpact)),
      institutions: {
        ...state.institutions,
        [institutionId]: {
          ...inst,
          status: newStatus,
          progress: 0,
          actionStartedAt: Date.now(),
        },
      },
    }

    // Special: loyalty_test is instant
    if (actionType === 'loyalty_test') {
      updates.institutions = {
        ...state.institutions,
        [institutionId]: {
          ...inst,
          resistance: Math.max(0, inst.resistance - actionDef.resistanceReduction),
          actionStartedAt: null,
        },
      }
      updates.loyalty = (updates.loyalty ?? state.loyalty) + 5
    }

    // Special: rebrand
    if (actionType === 'rebrand') {
      updates.institutions = {
        ...state.institutions,
        [institutionId]: {
          ...inst,
          rebranded: true,
          actionStartedAt: null,
        },
      }
    }

    // Special: automate
    if (actionType === 'automate' && inst.status === 'captured') {
      updates.institutions = {
        ...state.institutions,
        [institutionId]: {
          ...inst,
          status: 'automated',
          actionStartedAt: null,
        },
      }
    }

    // Special: privatize — sell for cash, remove from control
    if (actionType === 'privatize' && inst.status === 'captured') {
      updates.cash = (updates.cash ?? state.cash) + (def.greatnessOutput * 500)
      updates.institutions = {
        ...state.institutions,
        [institutionId]: {
          ...inst,
          status: 'independent',
          resistance: 50,
          progress: 0,
          actionStartedAt: null,
          rebranded: false,
        },
      }
    }

    set(updates as Partial<GameStore>)
  },

  tickInstitutions: (dt: number) => {
    const state = get()
    if (state.phase < 2) return

    const institutions = { ...state.institutions }
    let loyaltyGain = 0
    let controlTotal = 0
    let changed = false

    for (const [id, inst] of Object.entries(institutions)) {
      // Tick ongoing capture actions
      if (
        (inst.status === 'co-opting' || inst.status === 'replacing' || inst.status === 'purging') &&
        inst.actionStartedAt
      ) {
        const actionType = inst.status === 'co-opting' ? 'co-opt' : inst.status === 'replacing' ? 'replace' : 'purge'
        const actionDef = getActionDef(actionType as InstitutionActionType)
        if (actionDef) {
          const elapsed = (Date.now() - inst.actionStartedAt) / 1000
          // Prestige: institution speed bonus
          let instSpeedMult = 1
          for (const pu of PRESTIGE_UPGRADES) {
            if (state.prestigeUpgrades[pu.id] && pu.effect.type === 'institution_speed') {
              instSpeedMult += pu.effect.value
            }
          }
          const progress = Math.min(100, (elapsed * instSpeedMult / actionDef.duration) * 100)

          if (progress >= 100) {
            // Action complete — reduce resistance
            const newResistance = Math.max(0, inst.resistance - actionDef.resistanceReduction)
            if (newResistance <= 0) {
              // Institution captured!
              institutions[id] = {
                ...inst,
                status: 'captured',
                resistance: 0,
                progress: 100,
                actionStartedAt: null,
              }
            } else {
              // Resistance reduced but not captured yet
              institutions[id] = {
                ...inst,
                status: 'independent',
                resistance: newResistance,
                progress: 0,
                actionStartedAt: null,
              }
            }
            changed = true
          } else {
            institutions[id] = { ...inst, progress }
            changed = true
          }
        }
      }

      // Count captured/automated for loyalty and control
      const current = institutions[id]
      if (current.status === 'captured' || current.status === 'automated') {
        const def = getInstitutionDef(id)
        if (def) {
          loyaltyGain += def.loyaltyGeneration * dt
          controlTotal += 1
        }
      }
    }

    if (changed || loyaltyGain > 0) {
      set({
        institutions,
        loyalty: state.loyalty + loyaltyGain,
        control: controlTotal,
      } as Partial<GameStore>)
    }
  },

  startCountryTactic: (countryId: string, tacticType: string) => {
    const state = get()
    const country = state.countries[countryId]
    if (!country) return

    const tacticDef = getTacticDef(tacticType as TacticType)
    if (!tacticDef) return

    // Check if tactic is available for this country
    if (tacticDef.availableFor && !tacticDef.availableFor.includes(countryId)) return

    // Annexation requires resistance <= 0
    if (tacticType === 'annexation' && country.resistance > 0) return

    // Max 2 simultaneous operations per country
    if (country.activeOperations.length >= 2) return

    // Check costs
    if (state.cash < tacticDef.costCash) return
    if (state.loyalty < tacticDef.costLoyalty) return
    if (state.warOutput < tacticDef.costWarOutput) return

    const updates: Partial<GameState> = {
      cash: state.cash - tacticDef.costCash,
      loyalty: state.loyalty - tacticDef.costLoyalty,
      warOutput: state.warOutput - tacticDef.costWarOutput,
      countries: {
        ...state.countries,
        [countryId]: {
          ...country,
          activeOperations: [
            ...country.activeOperations,
            { tacticType, startedAt: Date.now(), duration: tacticDef.duration },
          ],
        },
      },
    }

    // Immediate legitimacy impact
    if (tacticDef.legitimacyImpact !== 0) {
      updates.legitimacy = Math.max(0, Math.min(100, state.legitimacy + tacticDef.legitimacyImpact))
    }

    set(updates as Partial<GameStore>)
  },

  tickCountries: (dt: number) => {
    const state = get()
    if (state.phase < 3) return

    const countries = { ...state.countries }
    let fearGain = 0
    let nobelDelta = 0
    let changed = false

    // War output from military budget
    const budgetEffects = calculateBudgetEffects(state)
    const warOutputGain = budgetEffects.militaryBonus * dt

    for (const [id, country] of Object.entries(countries)) {
      if (country.activeOperations.length === 0) continue

      const completedOps: number[] = []
      const updatedOps = [...country.activeOperations]

      for (let i = 0; i < updatedOps.length; i++) {
        const op = updatedOps[i]
        const elapsed = (Date.now() - op.startedAt) / 1000
        if (elapsed >= op.duration) {
          completedOps.push(i)
        }
      }

      if (completedOps.length > 0) {
        changed = true
        let newResistance = country.resistance
        let newStability = country.stability
        let newEncirclement = country.encirclement
        let newTradeDependency = country.tradeDependency
        let newPurchaseOffers = country.purchaseOffers
        let newKompromatLevel = country.kompromatLevel
        let newStatus = country.status

        // Process completed operations (reverse to preserve indices)
        for (const idx of completedOps.reverse()) {
          const op = updatedOps[idx]
          const tacticDef = getTacticDef(op.tacticType as TacticType)
          if (tacticDef) {
            newResistance = Math.max(0, newResistance - tacticDef.resistanceReduction)
            newStability = Math.max(0, Math.min(100, newStability + tacticDef.stabilityImpact))
            fearGain += tacticDef.fearGenerated
            nobelDelta += tacticDef.nobelImpact

            // Special mechanics
            if (op.tacticType === 'joint_defense') {
              newEncirclement = Math.min(100, newEncirclement + 15)
            }
            if (op.tacticType === 'trade_integration') {
              newTradeDependency = Math.min(100, newTradeDependency + 20)
            }
            if (op.tacticType === 'purchase_offer') {
              newPurchaseOffers += 1
            }
            if (op.tacticType === 'kompromat_resist') {
              newKompromatLevel = Math.max(0, newKompromatLevel - 15)
            }
            if (op.tacticType === 'aid_reduction') {
              newKompromatLevel = Math.max(0, newKompromatLevel - 10)
            }
            if (op.tacticType === 'leverage_reversal') {
              newKompromatLevel = Math.max(0, newKompromatLevel - 40)
            }

            // Annexation / absorption
            if (op.tacticType === 'annexation' || op.tacticType === 'full_absorption' || op.tacticType === 'absorption_referendum') {
              newStatus = 'annexed'
              newResistance = 0
            }

            // Encirclement check (Tundra Republic)
            if (id === 'tundra_republic' && newEncirclement >= 100) {
              newResistance = 0
            }

            // Trade dependency check (Maple Federation)
            if (id === 'maple_federation' && newTradeDependency >= 100) {
              newResistance = Math.min(newResistance, 10)
            }

            // Purchase offers check (Frostheim — 5 offers = surrender)
            if (id === 'frostheim' && newPurchaseOffers >= 5) {
              newResistance = 0
            }

            // Refugee mechanics
            if ((op.tacticType === 'freedom_operation' || op.tacticType === 'coup_sponsorship') &&
                (id === 'sand_republic' || id === 'copper_states')) {
              // Send refugee waves to Eurovia and Nordland
              const targets = ['eurovia', 'nordland']
              for (const targetId of targets) {
                if (countries[targetId]) {
                  countries[targetId] = {
                    ...countries[targetId],
                    stability: Math.max(0, countries[targetId].stability - 5),
                    resistance: Math.max(0, countries[targetId].resistance - 3),
                  }
                }
              }
            }
          }
          updatedOps.splice(idx, 1)
        }

        // Status update based on resistance
        if (newResistance <= 0 && newStatus !== 'annexed') {
          newStatus = 'occupied'
        } else if (newResistance < 30 && newStatus === 'independent') {
          newStatus = 'infiltrated'
        } else if (newStability < 20 && newStatus === 'independent') {
          newStatus = 'coup_target'
        }

        countries[id] = {
          ...country,
          resistance: newResistance,
          stability: newStability,
          encirclement: newEncirclement,
          tradeDependency: newTradeDependency,
          purchaseOffers: newPurchaseOffers,
          kompromatLevel: newKompromatLevel,
          status: newStatus,
          activeOperations: updatedOps,
        }
      }
    }

    // Apply fear decay
    const fearDecay = 0.5 * dt
    const newFear = Math.max(0, state.fear + fearGain - fearDecay)

    if (changed || warOutputGain > 0) {
      set({
        countries,
        fear: newFear,
        nobelScore: Math.max(0, state.nobelScore + nobelDelta),
        warOutput: state.warOutput + warOutputGain,
      } as Partial<GameStore>)
    }
  },

  buildShip: (shipId: string, quantity: number) => {
    const state = get()
    const def = getShipClassDef(shipId)
    if (!def) return
    if (state.shipyardLevel < def.requiresShipyard) return
    if (state.shipyardQueue) return // already building

    const totalCost = def.costCash * quantity
    if (state.cash < totalCost) return

    set({
      cash: state.cash - totalCost,
      shipyardQueue: {
        shipId,
        quantity,
        builtSoFar: 0,
        lastBuildAt: Date.now(),
      },
    } as Partial<GameStore>)
  },

  upgradeShipyard: () => {
    const state = get()
    const cost = getShipyardCost(state.shipyardLevel)
    if (state.cash < cost) return

    set({
      cash: state.cash - cost,
      shipyardLevel: state.shipyardLevel + 1,
    } as Partial<GameStore>)
  },

  tickShipyard: (_dt: number) => {
    const state = get()
    if (!state.shipyardQueue || state.shipyardLevel <= 0) return

    const queue = state.shipyardQueue
    const def = getShipClassDef(queue.shipId)
    if (!def) return

    // Build rate: 1 ship per 10 seconds per shipyard level
    const buildInterval = 10 / state.shipyardLevel
    const elapsed = (Date.now() - queue.lastBuildAt) / 1000

    if (elapsed >= buildInterval) {
      const shipsBuilt = Math.floor(elapsed / buildInterval)
      const totalBuilt = queue.builtSoFar + shipsBuilt
      const remaining = queue.quantity - totalBuilt

      const newFleet = { ...state.fleet }
      newFleet[queue.shipId] = (newFleet[queue.shipId] ?? 0) + shipsBuilt

      // Calculate total fleet war output and fear
      let totalWarOutput = 0
      let totalFear = 0
      for (const shipClass of SHIP_CLASSES) {
        const count = newFleet[shipClass.id] ?? 0
        totalWarOutput += count * shipClass.warOutput
        totalFear += count * shipClass.fear
      }

      if (remaining <= 0) {
        // Order complete
        set({
          fleet: newFleet,
          shipyardQueue: null,
          warOutput: totalWarOutput,
          fear: Math.max(state.fear, totalFear * 0.1), // Fleet fear contributes passively
        } as Partial<GameStore>)
      } else {
        set({
          fleet: newFleet,
          shipyardQueue: {
            ...queue,
            builtSoFar: totalBuilt,
            lastBuildAt: Date.now(),
          },
          warOutput: totalWarOutput,
        } as Partial<GameStore>)
      }
    }
  },

  // ── Phase 4: Space Actions ──

  upgradeLaunchTier: () => {
    const state = get()
    const next = getNextLaunchTier(state.space.launchTier)
    if (!next) return

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    const cost = next.costCash * costMult
    if (state.cash < cost) return

    set({
      cash: state.cash - cost,
      space: { ...state.space, launchTier: next.id },
    } as Partial<GameStore>)
  },

  buildLunarBuilding: (id: string) => {
    const state = get()
    const def = getLunarBuildingDef(id)
    if (!def) return
    if (state.space.launchTier === 'none') return

    // Check if already built
    const boolKey = id === 'moon_base' ? 'moonBase' :
      id === 'he3_mining' ? 'helium3Mining' :
      id === 'lunar_shipyard' ? 'lunarShipyard' :
      id === 'lunar_heritage' ? 'lunarHeritage' : null
    if (!boolKey || state.space[boolKey as keyof typeof state.space] === true) return

    // Check prerequisite
    if (def.prerequisite) {
      const preKey = def.prerequisite === 'moon_base' ? 'moonBase' :
        def.prerequisite === 'he3_mining' ? 'helium3Mining' :
        def.prerequisite === 'lunar_shipyard' ? 'lunarShipyard' : null
      if (preKey && !state.space[preKey as keyof typeof state.space]) return
    }

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    if (state.cash < def.costCash * costMult) return
    if (state.rocketMass < def.costRocketMass) return

    set({
      cash: state.cash - def.costCash * costMult,
      rocketMass: state.rocketMass - def.costRocketMass,
      space: { ...state.space, [boolKey]: true },
    } as Partial<GameStore>)
  },

  buildMarsUpgrade: (id: string) => {
    const state = get()
    const def = getMarsUpgradeDef(id)
    if (!def) return
    if (state.space.launchTier === 'none') return

    // Check if already built
    const boolKey = id === 'mars_colony' ? 'marsColony' :
      id === 'atmosphere_processing' ? 'atmosphereProcessing' :
      id === 'water_extraction' ? 'waterExtraction' : null
    if (!boolKey || state.space[boolKey as keyof typeof state.space] === true) return

    // Check prerequisite
    if (def.prerequisite) {
      const preKey = def.prerequisite === 'mars_colony' ? 'marsColony' :
        def.prerequisite === 'atmosphere_processing' ? 'atmosphereProcessing' : null
      if (preKey && !state.space[preKey as keyof typeof state.space]) return
    }

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    if (state.cash < def.costCash * costMult) return
    if (state.rocketMass < def.costRocketMass) return
    if (state.miningOutput < def.costMiningOutput) return

    set({
      cash: state.cash - def.costCash * costMult,
      rocketMass: state.rocketMass - def.costRocketMass,
      miningOutput: state.miningOutput - def.costMiningOutput,
      space: { ...state.space, [boolKey]: true },
    } as Partial<GameStore>)
  },

  buildAsteroidUnit: (tierId: string, count: number) => {
    const state = get()
    const def = getAsteroidTierDef(tierId)
    if (!def) return
    if (state.space.launchTier === 'none') return

    // Check prerequisite
    if (def.prerequisite) {
      const preKey = def.prerequisite === 'prospector_drones' ? 'asteroidProspectors' :
        def.prerequisite === 'mining_rigs' ? 'asteroidRigs' : null
      if (preKey && (state.space[preKey as keyof typeof state.space] as number) <= 0) return
    }

    // Get current count
    const countKey = tierId === 'prospector_drones' ? 'asteroidProspectors' :
      tierId === 'mining_rigs' ? 'asteroidRigs' :
      tierId === 'refineries' ? 'asteroidRefineries' : null
    if (!countKey) return

    const current = state.space[countKey as keyof typeof state.space] as number
    const canBuild = Math.min(count, def.maxCount - current)
    if (canBuild <= 0) return

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    const totalCash = def.costCash * canBuild * costMult
    const totalRocket = def.costRocketMass * canBuild
    if (state.cash < totalCash) return
    if (state.rocketMass < totalRocket) return

    set({
      cash: state.cash - totalCash,
      rocketMass: state.rocketMass - totalRocket,
      space: { ...state.space, [countKey]: current + canBuild },
    } as Partial<GameStore>)
  },

  buildSatellite: () => {
    const state = get()
    if (state.space.launchTier === 'none') return
    if (state.space.propagandaSatellites >= PROPAGANDA_SATELLITE.maxCount) return

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    if (state.cash < PROPAGANDA_SATELLITE.costCash * costMult) return
    if (state.orbitalIndustry < PROPAGANDA_SATELLITE.costOrbitalIndustry) return

    set({
      cash: state.cash - PROPAGANDA_SATELLITE.costCash * costMult,
      orbitalIndustry: state.orbitalIndustry - PROPAGANDA_SATELLITE.costOrbitalIndustry,
      space: { ...state.space, propagandaSatellites: state.space.propagandaSatellites + 1 },
    } as Partial<GameStore>)
  },

  buildDysonPrototype: () => {
    const state = get()
    if (state.space.dysonSwarms > 0) return
    if (!hasLaunchTier(state.space.launchTier, DYSON_PROTOTYPE.requiresLaunchTier)) return
    if (state.orbitalIndustry < DYSON_PROTOTYPE.requiresOrbitalIndustry) return

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    if (state.cash < DYSON_PROTOTYPE.costCash * costMult) return

    set({
      cash: state.cash - DYSON_PROTOTYPE.costCash * costMult,
      orbitalIndustry: state.orbitalIndustry - DYSON_PROTOTYPE.costOrbitalIndustry,
      space: { ...state.space, dysonSwarms: 1 },
    } as Partial<GameStore>)
  },

  purchaseSpaceWeapon: (id: string) => {
    const state = get()
    if (state.space.spaceWeapons[id]) return

    const def = getSpaceWeaponDef(id)
    if (!def) return
    if (!hasLaunchTier(state.space.launchTier, def.requiresLaunchTier)) return

    const costMult = state.space.bridgeUpgrades['reality_budgeting'] ? 0.7 : 1
    if (state.cash < def.costCash * costMult) return

    set({
      cash: state.cash - def.costCash * costMult,
      warOutput: state.warOutput + def.warOutput,
      fear: state.fear + def.fear,
      legitimacy: Math.max(0, Math.min(100, state.legitimacy + def.legitimacyImpact)),
      space: {
        ...state.space,
        spaceWeapons: { ...state.space.spaceWeapons, [id]: true },
      },
    } as Partial<GameStore>)
  },

  purchaseBridgeUpgrade: (id: string) => {
    const state = get()
    if (state.space.bridgeUpgrades[id]) return

    const def = getBridgeUpgradeDef(id)
    if (!def) return

    // Check prerequisite
    if (def.prerequisite && !state.space.bridgeUpgrades[def.prerequisite]) return

    const costMult = 1 // Bridge upgrades don't benefit from their own cost reduction
    if (state.cash < def.costCash * costMult) return
    if (state.loyalty < def.costLoyalty) return

    set({
      cash: state.cash - def.costCash,
      loyalty: state.loyalty - def.costLoyalty,
      space: {
        ...state.space,
        bridgeUpgrades: { ...state.space.bridgeUpgrades, [id]: true },
      },
    } as Partial<GameStore>)
  },

  tickSpace: (dt: number) => {
    const state = get()
    if (state.phase < 4) return

    const space = state.space
    const budgetEffects = calculateBudgetEffects(state)
    const spaceSpeedMult = 1 + budgetEffects.spaceBonus
    const researchSpeedMult = space.bridgeUpgrades['long_term_thinking'] ? 1.5 : 1

    // Rocket mass from launch tier
    let rocketMassGain = 0
    const tierDef = getLaunchTierDef(space.launchTier)
    if (tierDef) {
      rocketMassGain = tierDef.rocketMassPerSecond * spaceSpeedMult * researchSpeedMult
    }

    // Orbital industry from lunar buildings
    let orbitalGain = 0
    for (const building of LUNAR_BUILDINGS) {
      const boolKey = building.id === 'moon_base' ? 'moonBase' :
        building.id === 'he3_mining' ? 'helium3Mining' :
        building.id === 'lunar_shipyard' ? 'lunarShipyard' :
        building.id === 'lunar_heritage' ? 'lunarHeritage' : null
      if (boolKey && space[boolKey as keyof typeof space]) {
        orbitalGain += building.effects.orbitalIndustryPerSecond ?? 0
      }
    }

    // Mining output from lunar buildings + asteroids
    let miningGain = 0
    for (const building of LUNAR_BUILDINGS) {
      const boolKey = building.id === 'he3_mining' ? 'helium3Mining' : null
      if (boolKey && space[boolKey as keyof typeof space]) {
        miningGain += building.effects.miningOutputPerSecond ?? 0
      }
    }
    for (const tier of ASTEROID_TIERS) {
      const countKey = tier.id === 'prospector_drones' ? 'asteroidProspectors' :
        tier.id === 'mining_rigs' ? 'asteroidRigs' :
        tier.id === 'refineries' ? 'asteroidRefineries' : null
      if (countKey) {
        miningGain += (space[countKey as keyof typeof space] as number) * tier.miningOutputPerUnit
      }
    }

    // Colonists + terraform from Mars upgrades
    let colonistGain = 0
    let terraformGain = 0
    for (const upgrade of MARS_UPGRADES) {
      const boolKey = upgrade.id === 'mars_colony' ? 'marsColony' :
        upgrade.id === 'atmosphere_processing' ? 'atmosphereProcessing' :
        upgrade.id === 'water_extraction' ? 'waterExtraction' : null
      if (boolKey && space[boolKey as keyof typeof space]) {
        colonistGain += upgrade.effects.colonistsPerSecond ?? 0
        terraformGain += upgrade.effects.terraformPerSecond ?? 0
      }
    }

    // Legitimacy from lunar heritage + satellites
    let legitimacyGain = 0
    if (space.lunarHeritage) {
      const herDef = getLunarBuildingDef('lunar_heritage')
      legitimacyGain += herDef?.effects.legitimacyPerSecond ?? 0
    }
    legitimacyGain += space.propagandaSatellites * PROPAGANDA_SATELLITE.legitimacyPerUnit

    // Attention from satellites
    const attentionGain = space.propagandaSatellites * PROPAGANDA_SATELLITE.attentionPerUnit

    // Reality drift accumulation
    const driftRate = calculateDriftRate(state)
    const driftReduction = calculateDriftReduction(state)
    const netDrift = (driftRate - driftReduction) * dt

    const newTerraform = Math.min(100, state.terraformProgress + terraformGain * spaceSpeedMult * dt)

    // Mars renaming at 25% terraform
    let newMarsRenamed = space.marsRenamed
    if (!newMarsRenamed && newTerraform >= 25) {
      newMarsRenamed = true
    }

    const updates: Partial<GameState> = {
      rocketMass: state.rocketMass + rocketMassGain * dt,
      orbitalIndustry: state.orbitalIndustry + orbitalGain * spaceSpeedMult * dt,
      miningOutput: state.miningOutput + miningGain * spaceSpeedMult * dt,
      colonists: state.colonists + colonistGain * spaceSpeedMult * dt,
      terraformProgress: newTerraform,
      attention: state.attention + attentionGain * dt,
      legitimacy: Math.max(0, Math.min(100, state.legitimacy + legitimacyGain * dt)),
      realityDrift: Math.max(0, Math.min(getDriftCap(state), state.realityDrift + netDrift)),
    }

    if (newMarsRenamed !== space.marsRenamed) {
      updates.space = { ...space, marsRenamed: newMarsRenamed }
    }

    set(updates as Partial<GameStore>)
  },

  // ── Phase 5: Universe Actions ──

  purchaseProbeUpgrade: (id: string) => {
    const state = get()
    if (state.phase < 5) return
    if (state.universe.probeUpgrades[id]) return

    const def = getProbeUpgradeDef(id)
    if (!def) return
    if (def.prerequisite && !state.universe.probeUpgrades[def.prerequisite]) return
    if (state.cash < def.costCash) return
    if (state.computronium < def.costComputronium) return

    set({
      cash: state.cash - def.costCash,
      computronium: state.computronium - def.costComputronium,
      universe: {
        ...state.universe,
        probeUpgrades: { ...state.universe.probeUpgrades, [id]: true },
        probeFactories: state.universe.probeFactories + (id === 'probe_factory' ? 1 : id === 'galactic_distribution' ? 5 : 0),
      },
    } as Partial<GameStore>)
  },

  purchaseDysonUpgrade: (id: string) => {
    const state = get()
    if (state.phase < 5) return
    if (state.universe.dysonUpgrades[id]) return

    const def = getDysonSwarmDef(id)
    if (!def) return
    if (def.prerequisite && !state.universe.dysonUpgrades[def.prerequisite]) return
    if (state.cash < def.costCash) return
    if (state.orbitalIndustry < def.costOrbitalIndustry) return
    if (state.computronium < def.costComputronium) return

    set({
      cash: state.cash - def.costCash,
      orbitalIndustry: state.orbitalIndustry - def.costOrbitalIndustry,
      computronium: state.computronium - def.costComputronium,
      space: { ...state.space, dysonSwarms: state.space.dysonSwarms + 1 },
      universe: {
        ...state.universe,
        dysonUpgrades: { ...state.universe.dysonUpgrades, [id]: true },
      },
    } as Partial<GameStore>)
  },

  purchaseStarBranding: (id: string) => {
    const state = get()
    if (state.phase < 5) return
    if (state.universe.starBrandingUpgrades[id]) return

    const def = getStarBrandingDef(id)
    if (!def) return
    if (def.prerequisite && !state.universe.starBrandingUpgrades[def.prerequisite]) return
    if (state.cash < def.costCash) return
    if (state.computronium < def.costComputronium) return

    set({
      cash: state.cash - def.costCash,
      computronium: state.computronium - def.costComputronium,
      universe: {
        ...state.universe,
        starBrandingUpgrades: { ...state.universe.starBrandingUpgrades, [id]: true },
      },
    } as Partial<GameStore>)
  },

  purchaseBlackHole: (id: string) => {
    const state = get()
    if (state.phase < 5) return
    if (state.universe.blackHoleUpgrades[id]) return

    const def = getBlackHoleDef(id)
    if (!def) return
    if (def.prerequisite && !state.universe.blackHoleUpgrades[def.prerequisite]) return
    if (state.cash < def.costCash) return
    if (state.computronium < def.costComputronium) return

    set({
      cash: state.cash - def.costCash,
      computronium: state.computronium - def.costComputronium,
      universe: {
        ...state.universe,
        blackHoleUpgrades: { ...state.universe.blackHoleUpgrades, [id]: true },
        blackHoles: state.universe.blackHoles + (id === 'black_hole_capture' ? 1 : 0),
      },
    } as Partial<GameStore>)
  },

  purchaseNarrativeResearch: (id: string) => {
    const state = get()
    if (state.phase < 5) return
    if (state.universe.narrativeResearch[id]) return

    const def = getNarrativeResearchDef(id)
    if (!def) return
    if (def.prerequisite && !state.universe.narrativeResearch[def.prerequisite]) return
    if (state.greatnessUnits < def.costGU) return

    set({
      greatnessUnits: state.greatnessUnits - def.costGU,
      universe: {
        ...state.universe,
        narrativeResearch: { ...state.universe.narrativeResearch, [id]: true },
      },
    } as Partial<GameStore>)
  },

  tickCosmic: (dt: number) => {
    const state = get()
    if (state.phase < 5) return

    const uni = state.universe

    // ── Probe Production ──
    // Base production from factories
    let probeProduction = 0
    for (const upgrade of PROBE_UPGRADES) {
      if (uni.probeUpgrades[upgrade.id] && upgrade.effect.probeProductionPerSecond) {
        probeProduction += upgrade.effect.probeProductionPerSecond
      }
    }

    // Probe self-replication (exponential growth — the Paperclips parallel)
    let replicationRate = PROBE_REPLICATION_BASE
    for (const upgrade of PROBE_UPGRADES) {
      if (uni.probeUpgrades[upgrade.id] && upgrade.effect.replicationRate) {
        replicationRate += upgrade.effect.replicationRate
      }
    }
    const replicationProbes = state.probesLaunched * replicationRate * dt
    const newProbes = state.probesLaunched + (probeProduction + replicationProbes) * dt

    // ── Star Conversion ──
    let conversionRate = 0
    for (const tier of STAR_BRANDING_TIERS) {
      if (uni.starBrandingUpgrades[tier.id]) {
        conversionRate += tier.conversionRatePerSecond
      }
    }
    // Conversion efficiency multiplier from probes
    let conversionMult = 1
    for (const upgrade of PROBE_UPGRADES) {
      if (uni.probeUpgrades[upgrade.id] && upgrade.effect.conversionEfficiency) {
        conversionMult *= upgrade.effect.conversionEfficiency
      }
    }
    // Can only convert stars that probes have reached (probes = available stars)
    const availableStars = Math.floor(newProbes * 0.1) // 10% of probes find new stars
    const maxConvertible = Math.max(0, Math.min(availableStars, TOTAL_REACHABLE_STARS) - state.starsConverted)
    const starsConverted = Math.min(maxConvertible, conversionRate * conversionMult * dt)
    const newStarsConverted = state.starsConverted + starsConverted

    // ── Computronium Production ──
    const computroniumGain = starsConverted * COMPUTRONIUM_PER_STAR
    const newComputronium = state.computronium + computroniumGain

    // ── Greatness Units Production ──
    let guProduction = 0
    // Base: from computronium processing
    guProduction += newComputronium * GU_PER_COMPUTRONIUM * 0.01 // per second rate

    // Dyson Swarms
    for (const tier of DYSON_SWARM_TIERS) {
      if (uni.dysonUpgrades[tier.id]) {
        guProduction += tier.guPerSecond
      }
    }

    // Black Hole storage
    for (const bh of BLACK_HOLE_UPGRADES) {
      if (uni.blackHoleUpgrades[bh.id] && bh.effect.guStorage) {
        guProduction += bh.effect.guStorage
      }
    }

    // Narrative Architecture multipliers
    let guMult = 1
    for (const research of NARRATIVE_RESEARCH) {
      if (uni.narrativeResearch[research.id] && research.effect.guMultiplier) {
        guMult *= research.effect.guMultiplier
      }
    }
    // Flat bonus from narrative research
    for (const research of NARRATIVE_RESEARCH) {
      if (uni.narrativeResearch[research.id] && research.effect.productionBonus) {
        guProduction += research.effect.productionBonus
      }
    }

    // GU Value Depreciation: logarithmic decrease — more GU = less value per unit
    const depreciationFactor = 1 / (1 + Math.log10(Math.max(1, state.greatnessUnits) / 1000))
    const guGain = guProduction * guMult * depreciationFactor * dt

    // Post-ending maintenance: GU slowly decays, requiring active upkeep
    let guDecay = 0
    if (uni.endingComplete) {
      // 0.5% decay per second — the universe fights back
      guDecay = state.greatnessUnits * 0.005 * dt
    }

    const newGU = Math.max(0, state.greatnessUnits + guGain - guDecay)

    // ── Legitimacy from Black Holes ──
    let legitimacyGain = 0
    for (const bh of BLACK_HOLE_UPGRADES) {
      if (uni.blackHoleUpgrades[bh.id] && bh.effect.legitimacyPerSecond) {
        legitimacyGain += bh.effect.legitimacyPerSecond
      }
    }

    // ── Reality Drift from Phase 5 sources ──
    let phase5Drift = 0
    phase5Drift += starsConverted * STAR_DRIFT_PER_CONVERSION
    phase5Drift += state.probesLaunched * 0.00001 // tiny drift from probe expansion
    // Drift reduction from narrative research + black holes
    let driftReduction = 0
    for (const research of NARRATIVE_RESEARCH) {
      if (uni.narrativeResearch[research.id] && research.effect.driftReduction) {
        driftReduction += research.effect.driftReduction
      }
    }
    for (const bh of BLACK_HOLE_UPGRADES) {
      if (uni.blackHoleUpgrades[bh.id] && bh.effect.driftReduction) {
        driftReduction += bh.effect.driftReduction
      }
    }
    const netDrift = (phase5Drift - driftReduction) * dt

    // ── Universe Conversion Percentage ──
    const newUniverseConverted = Math.min(100, (newStarsConverted / TOTAL_REACHABLE_STARS) * 100)

    // ── Ending check ──
    let endingTriggered = uni.endingTriggered
    if (newUniverseConverted >= 100 && !endingTriggered) {
      endingTriggered = true
    }

    const updates: Partial<GameState> = {
      probesLaunched: newProbes,
      starsConverted: newStarsConverted,
      computronium: newComputronium,
      greatnessUnits: newGU,
      legitimacy: Math.max(0, Math.min(100, state.legitimacy + legitimacyGain * dt)),
      realityDrift: Math.max(0, Math.min(getDriftCap(state), state.realityDrift + netDrift)),
      universe: {
        ...uni,
        universeConverted: newUniverseConverted,
        endingTriggered,
      },
    }

    set(updates as Partial<GameStore>)
  },

  // ── Prestige ──

  prestige: () => {
    const state = get()
    const ppEarned = calculatePrestigePoints(state.greatnessUnits)
    const now = Date.now()

    // Apply prestige click power bonuses to initial state
    let startClickPower = 1
    const allPrestige = { ...state.prestigeUpgrades }
    for (const upgrade of PRESTIGE_UPGRADES) {
      if (allPrestige[upgrade.id] && upgrade.effect.type === 'click_power') {
        startClickPower *= upgrade.effect.value
      }
    }

    // Preserve persistent state
    const preserved = {
      achievements: state.achievements,
      prestigeUpgrades: allPrestige,
      prestigeLevel: state.prestigeLevel + 1,
      prestigePoints: state.prestigePoints + ppEarned,
      settings: state.settings,
      attentionPerClick: startClickPower,
    }

    set({
      ...INITIAL_STATE,
      ...preserved,
      startedAt: now,
      lastTickAt: now,
      lastSaveAt: now,
      nextEventAt: now + 120_000,
      pendingTransition: null,
    })

    get().save()
  },

  purchasePrestigeUpgrade: (id: string) => {
    const state = get()
    const def = getPrestigeUpgradeDef(id)
    if (!def) return

    // Already purchased
    if (state.prestigeUpgrades[id]) return

    // Check cost
    if (state.prestigePoints < def.cost) return

    // Check prerequisites
    if (def.prerequisites?.some(pre => !state.prestigeUpgrades[pre])) return

    set({
      prestigePoints: state.prestigePoints - def.cost,
      prestigeUpgrades: {
        ...state.prestigeUpgrades,
        [id]: true,
      },
    })
  },

  applyEffect: (effect: Effect) => {
    set(state => {
      const key = effect.resource as keyof GameState
      const current = state[key]
      if (typeof current !== 'number') return state

      let newValue: number
      switch (effect.type) {
        case 'add':
          newValue = current + effect.amount
          break
        case 'multiply':
          newValue = current * effect.amount
          break
        case 'set':
          newValue = effect.amount
          break
      }

      return { [key]: newValue } as Partial<GameState>
    })
  },
}))
