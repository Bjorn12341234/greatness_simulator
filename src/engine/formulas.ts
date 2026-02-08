import type { GameState } from '../store/types'
import { getUpgradeData } from '../data/upgradeRegistry'
import { getInstitutionDef } from '../data/phase2/institutions'
import { getCountryDef } from '../data/phase3/countries'
import { PRESTIGE_UPGRADES } from '../data/prestige'

// ── Phase Multipliers ──
const PHASE_MULTIPLIERS: Record<number, number> = {
  1: 1,
  2: 10,
  3: 100,
  4: 10_000,
  5: 1_000_000,
}

// ── Greatness Per Second ──
export function calculateGPS(state: GameState): number {
  const base = calculateBaseProduction(state)
  const gpsMult = calculateGPSMultiplier(state)
  const legMult = getLegitimacyMultiplier(state.legitimacy)
  const phaseMult = PHASE_MULTIPLIERS[state.phase] ?? 1
  const prestigeBonus = 1 + 0.1 * state.prestigeLevel

  // Prestige GpS multiplier upgrades
  let prestigeGpsMult = 1
  for (const upgrade of PRESTIGE_UPGRADES) {
    if (state.prestigeUpgrades[upgrade.id] && upgrade.effect.type === 'gps_multiplier') {
      prestigeGpsMult *= upgrade.effect.value
    }
  }

  return base * gpsMult * legMult * phaseMult * prestigeBonus * prestigeGpsMult
}

function calculateBaseProduction(state: GameState): number {
  let total = 0

  for (const [id, upgrade] of Object.entries(state.upgrades)) {
    if (upgrade.purchased && upgrade.count > 0) {
      const data = getUpgradeData(id)
      const production = data?.production ?? 0
      total += upgrade.count * production
    }
  }

  // Phase 2+: add institution production
  for (const [id, inst] of Object.entries(state.institutions)) {
    if (inst.status === 'captured' || inst.status === 'automated') {
      const def = getInstitutionDef(id)
      const baseOutput = def?.greatnessOutput ?? 5
      const mult = inst.status === 'automated' ? 1.5 : 1
      total += baseOutput * mult
    }
  }

  // Phase 3+: add annexed country production
  for (const [id, country] of Object.entries(state.countries)) {
    if (country.status === 'annexed') {
      const def = getCountryDef(id)
      if (def) {
        total += def.greatnessPotential
      }
    }
  }

  // Phase 4+: add space production
  if (state.phase >= 4) {
    total += state.orbitalIndustry * 10
    total += state.colonists * 5
    total += state.space.propagandaSatellites * 50

    // Mars upgrade GpS
    if (state.space.marsColony) total += 5
    if (state.space.atmosphereProcessing) total += 10
    if (state.space.waterExtraction) total += 15
  }

  // Phase 5+: cosmic production
  if (state.phase >= 5) {
    total += state.computronium * 20
    total += state.greatnessUnits * 0.1    // GU also feeds back into Greatness
    total += state.probesLaunched * 0.5
    total += state.starsConverted * 50
  }

  return total
}

// Collect gpsMultiplier effects from purchased upgrades
function calculateGPSMultiplier(state: GameState): number {
  let mult = 1
  for (const [id, upgrade] of Object.entries(state.upgrades)) {
    if (upgrade.purchased && upgrade.count > 0) {
      const data = getUpgradeData(id)
      if (data?.effects) {
        for (const effect of data.effects) {
          if (effect.type === 'gpsMultiplier') {
            mult *= effect.value
          }
        }
      }
    }
  }
  return mult
}

// ── Legitimacy ──
export function getLegitimacyMultiplier(legitimacy: number): number {
  if (legitimacy > 80) return 1.2
  if (legitimacy >= 50) return 1.0
  if (legitimacy >= 25) return 0.7
  return 0.4
}

export function calculateLegitimacyDecay(state: GameState): number {
  const capturedCount = Object.values(state.institutions).filter(
    i => i.status === 'captured' || i.status === 'automated'
  ).length

  const activeWars = Object.values(state.countries).filter(
    c => c.status === 'occupied' || c.status === 'coup_target'
  ).length

  const defundedPenalty =
    (state.budget.healthcare < 10 ? 1 : 0) +
    (state.budget.education < 10 ? 1 : 0) +
    (state.budget.socialBenefits < 10 ? 1 : 0)

  let decay = (
    0.001 +
    capturedCount * 0.0002 +
    activeWars * 0.005 +
    state.realityDrift * 0.00001 +
    defundedPenalty * 0.003
  )

  // Prestige: legitimacy_decay reduction
  for (const upgrade of PRESTIGE_UPGRADES) {
    if (state.prestigeUpgrades[upgrade.id] && upgrade.effect.type === 'legitimacy_decay') {
      if (upgrade.id === 'the_golden_constant') {
        // Special: floor legitimacy at 25% (handled in tick, but reduce decay heavily)
        decay *= 0.1
      } else {
        decay *= (1 - upgrade.effect.value)
      }
    }
  }

  return decay
}

// Legitimacy recovery per second from budget allocation
export function calculateLegitimacyRecovery(state: GameState): number {
  const budgetEffects = calculateBudgetEffects(state)
  return budgetEffects.healthcareBonus + budgetEffects.socialBonus + budgetEffects.propagandaBonus
}

// Net legitimacy change per second (positive = gaining, negative = losing)
export function calculateNetLegitimacyChange(state: GameState): number {
  if (state.phase < 2) return 0
  return calculateLegitimacyRecovery(state) - calculateLegitimacyDecay(state)
}

// Get legitimacy status info for UI display
export function getLegitimacyStatus(legitimacy: number): {
  label: string
  color: string
  glowColor: string
  warning: boolean
  critical: boolean
} {
  if (legitimacy > 80) return { label: 'Strong', color: '#33CC66', glowColor: 'rgba(51, 204, 102, 0.3)', warning: false, critical: false }
  if (legitimacy >= 50) return { label: 'Stable', color: '#88CC44', glowColor: 'rgba(136, 204, 68, 0.2)', warning: false, critical: false }
  if (legitimacy >= 25) return { label: 'Weakening', color: '#CCAA33', glowColor: 'rgba(204, 170, 51, 0.2)', warning: true, critical: false }
  if (legitimacy >= 10) return { label: 'Critical', color: '#CC4433', glowColor: 'rgba(204, 68, 51, 0.3)', warning: true, critical: true }
  return { label: 'COLLAPSE', color: '#FF3333', glowColor: 'rgba(255, 51, 51, 0.4)', warning: true, critical: true }
}

// ── Upgrade Costs ──
export function calculateUpgradeCost(baseCost: number, count: number, state?: GameState): number {
  let cost = Math.floor(baseCost * Math.pow(1.15, count))

  // Prestige research discount
  if (state) {
    for (const upgrade of PRESTIGE_UPGRADES) {
      if (state.prestigeUpgrades[upgrade.id] && upgrade.effect.type === 'research_discount') {
        cost = Math.floor(cost * (1 - upgrade.effect.value))
      }
    }
  }

  return cost
}

// ── Nobel Score ──
export function calculateNobelGain(baseGain: number, timesUsed: number): number {
  return baseGain * (1 / (1 + timesUsed * 0.1))
}

// ── Fear Effect ──
export function calculateFearResistanceReduction(fear: number): number {
  return fear * 0.01
}

// ── Offline Progression ──
export function calculateOfflineRate(state: GameState): number {
  const base = 0.1
  // Check for offline-rate upgrades
  if (state.prestigeUpgrades['eternal_engine']) return 1.0
  // Add other upgrade checks here
  return base
}

// ── Budget Effects ──
export function calculateBudgetEffects(state: GameState) {
  const b = state.budget
  return {
    healthcareBonus: b.healthcare * 0.003,         // legitimacy recovery/s
    educationBonus: b.education * 0.001,            // reality drift reduction/s
    socialBonus: b.socialBenefits * 0.002,          // legitimacy recovery/s
    militaryBonus: b.military * 0.01,               // war output multiplier
    datacenterBonus: b.dataCenters * 0.005,         // attention + surveillance mult
    infraBonus: b.infrastructure * 0.003,           // cash generation mult
    propagandaBonus: b.propagandaBureau * 0.004,    // legitimacy generation mult
    spaceBonus: b.spaceProgram * 0.002,             // space research speed mult
  }
}

// ── Event Frequency ──
const EVENT_FREQUENCY: Record<number, [number, number]> = {
  1: [120, 180],
  2: [60, 120],
  3: [45, 90],
  4: [30, 60],
  5: [15, 30],
}

export function getNextEventDelay(phase: number, state?: GameState): number {
  const [min, max] = EVENT_FREQUENCY[phase] ?? [120, 180]
  let delay = (min + Math.random() * (max - min)) * 1000 // in ms

  // Prestige: event cooldown increase
  if (state) {
    for (const upgrade of PRESTIGE_UPGRADES) {
      if (state.prestigeUpgrades[upgrade.id] && upgrade.effect.type === 'event_cooldown') {
        delay *= (1 + upgrade.effect.value)
      }
    }
  }

  return delay
}
