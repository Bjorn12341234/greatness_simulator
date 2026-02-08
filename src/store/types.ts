// ── Core Game State Types ──
// Matches spec.md schema. Single source of truth for all game state types.

export type Phase = 1 | 2 | 3 | 4 | 5

export interface GameState {
  // Meta
  phase: Phase
  startedAt: number
  lastTickAt: number
  lastSaveAt: number
  totalPlayTime: number
  prestigeLevel: number
  prestigePoints: number

  // Core Resources
  greatness: number
  greatnessPerSecond: number
  cash: number
  attention: number
  influence: number

  // Phase 2+
  loyalty: number
  control: number
  legitimacy: number
  surveillance: number

  // Budget allocation (Phase 2+)
  budget: BudgetAllocation

  // Tariffs (Phase 2+)
  tariffs: Record<string, TariffState>

  // Data Centers (Phase 2+)
  dataCenterUpgrades: Record<string, boolean>

  // Loyalty system upgrades (Phase 2+)
  loyaltyUpgrades: Record<string, boolean>

  // Phase 3+
  treatyPower: number
  sanctions: number
  annexationPoints: number
  warOutput: number
  nobelScore: number
  nobelPrizesWon: number
  nobelThreshold: number
  fear: number

  // Phase 4+
  rocketMass: number
  orbitalIndustry: number
  miningOutput: number
  colonists: number
  terraformProgress: number

  // Phase 5+
  computronium: number
  greatnessUnits: number
  realityDrift: number
  starsConverted: number
  probesLaunched: number

  // Meta-currency
  doublethinkTokens: number

  // Tracking
  clickCount: number
  attentionPerClick: number

  // Upgrades
  upgrades: Record<string, UpgradeState>

  // Phase 2: Institutions
  institutions: Record<string, InstitutionState>

  // Phase 3: Countries
  countries: Record<string, CountryState>

  // Phase 3: Fleet
  fleet: Record<string, number>
  shipyardLevel: number
  shipyardQueue: ShipyardOrder | null

  // Phase 4: Space
  space: SpaceState

  // Phase 5: Universe
  universe: UniverseState

  // Contradictions
  contradictions: Record<string, ContradictionState>

  // Events
  eventQueue: GameEvent[]
  eventHistory: string[]
  activeEvent: GameEvent | null
  nextEventAt: number

  // Achievements
  achievements: Record<string, boolean>

  // Prestige upgrades (persist across resets)
  prestigeUpgrades: Record<string, boolean>

  // Phase transition
  pendingTransition: { from: Phase; to: Phase } | null

  // Settings
  settings: GameSettings
}

export interface UpgradeState {
  purchased: boolean
  count: number
  unlocked: boolean
}

export type InstitutionStatus = 'independent' | 'co-opting' | 'replacing' | 'purging' | 'captured' | 'automated'

export interface InstitutionState {
  status: InstitutionStatus
  resistance: number
  progress: number
  actionStartedAt: number | null
  rebranded: boolean
}

export type CountryStatus = 'independent' | 'sanctioned' | 'infiltrated' | 'coup_target' | 'occupied' | 'annexed' | 'allied'

export interface CountryState {
  status: CountryStatus
  resistance: number
  stability: number
  activeOperations: ActiveOperation[]
  refugeeWavesSent: number
  encirclement: number
  tradeDependency: number
  purchaseOffers: number
  kompromatLevel: number
}

export interface ActiveOperation {
  tacticType: string
  startedAt: number
  duration: number
}

export interface ShipyardOrder {
  shipId: string
  quantity: number
  builtSoFar: number
  lastBuildAt: number
}

export interface BudgetAllocation {
  healthcare: number
  education: number
  socialBenefits: number
  military: number
  dataCenters: number
  infrastructure: number
  propagandaBureau: number
  spaceProgram: number
}

export interface TariffState {
  active: boolean
  level: number
  cashGenerated: number
  sideEffectAccumulated: number
}

export interface ContradictionState {
  sideA: number
  sideB: number
  balancedTime: number
  active: boolean
}

export interface UniverseState {
  // MAGA Replicators (probe infrastructure)
  probeUpgrades: Record<string, boolean>
  probeFactories: number

  // Solar Greatness Harvesters
  dysonUpgrades: Record<string, boolean>

  // Star Branding
  starBrandingUpgrades: Record<string, boolean>

  // Golden Ledger Singularity
  blackHoleUpgrades: Record<string, boolean>
  blackHoles: number

  // Narrative Architecture
  narrativeResearch: Record<string, boolean>

  // Endgame tracking
  universeConverted: number   // 0-100 percentage
  endingTriggered: boolean
  endingComplete: boolean
}

export type LaunchTier = 'none' | 'launchpad' | 'spaceport' | 'orbital_elevator' | 'mass_driver'

export interface SpaceState {
  launchTier: LaunchTier
  moonBase: boolean
  helium3Mining: boolean
  lunarShipyard: boolean
  lunarHeritage: boolean
  marsColony: boolean
  marsRenamed: boolean
  atmosphereProcessing: boolean
  waterExtraction: boolean
  asteroidRigs: number
  asteroidProspectors: number
  asteroidRefineries: number
  propagandaSatellites: number
  dysonSwarms: number
  vonNeumannProbes: number
  spaceWeapons: Record<string, boolean>
  bridgeUpgrades: Record<string, boolean>
}

export type EventCategory = 'scandal' | 'opportunity' | 'contradiction' | 'absurd' | 'crisis' | 'nobel' | 'reality_glitch'

export interface GameEvent {
  id: string
  phase: number
  category: EventCategory
  headline: string
  context: string
  choices: EventChoice[]
  conditions?: EventCondition[]
  cooldown?: number
  unique?: boolean
}

export interface EventChoice {
  label: string
  effects: Effect[]
  description?: string
}

export interface Effect {
  resource: string
  amount: number
  type: 'add' | 'multiply' | 'set'
  duration?: number
}

export interface EventCondition {
  resource: string
  operator: '>' | '<' | '>=' | '<=' | '=='
  value: number
}

export interface GameSettings {
  musicVolume: number
  sfxVolume: number
  notificationsEnabled: boolean
  theme: string
}

// ── Upgrade Data (config, not state) ──

export interface UpgradeData {
  id: string
  name: string
  description: string
  tree: string
  icon: string
  baseCost: number
  costResource: 'attention' | 'cash' | 'greatness'
  production: number       // GpS added per purchase
  maxCount: number         // 1 = one-time, >1 = repeatable
  effects?: UpgradeEffect[]
  prerequisites?: string[] // upgrade IDs that must be purchased
  unlockAt?: UnlockCondition
  phase: number
}

export interface UpgradeEffect {
  type: 'attentionPerClick' | 'cashPerSecond' | 'gpsMultiplier'
  value: number
}

export interface UnlockCondition {
  resource: 'attention' | 'greatness' | 'cash' | 'clickCount'
  threshold: number
}

// Save file wrapper
export interface SaveFile {
  version: number
  savedAt: number
  state: GameState
}

// Store actions (separated from state for clarity)
export interface GameActions {
  // Core
  tick: (now: number) => void
  click: () => void

  // Upgrades
  purchaseUpgrade: (id: string) => void
  unlockUpgrade: (id: string) => void

  // Events
  resolveEvent: (choiceIndex: number) => void
  dismissEvent: () => void

  // Save/Load
  save: () => void
  load: () => boolean
  reset: () => void

  // Phase
  setPhase: (phase: Phase) => void
  triggerPhaseTransition: (from: Phase, to: Phase) => void
  completePhaseTransition: () => void

  // Settings
  updateSettings: (settings: Partial<GameSettings>) => void

  // Budget (Phase 2+)
  setBudget: (budget: Partial<BudgetAllocation>) => void

  // Institutions (Phase 2+)
  startInstitutionAction: (institutionId: string, action: string) => void
  tickInstitutions: (dt: number) => void

  // Countries (Phase 3+)
  startCountryTactic: (countryId: string, tacticType: string) => void
  tickCountries: (dt: number) => void

  // Fleet (Phase 3+)
  buildShip: (shipId: string, quantity: number) => void
  upgradeShipyard: () => void
  tickShipyard: (dt: number) => void

  // Space (Phase 4+)
  upgradeLaunchTier: () => void
  buildLunarBuilding: (id: string) => void
  buildMarsUpgrade: (id: string) => void
  buildAsteroidUnit: (tierId: string, count: number) => void
  buildSatellite: () => void
  buildDysonPrototype: () => void
  purchaseSpaceWeapon: (id: string) => void
  purchaseBridgeUpgrade: (id: string) => void
  tickSpace: (dt: number) => void

  // Universe (Phase 5+)
  purchaseProbeUpgrade: (id: string) => void
  purchaseDysonUpgrade: (id: string) => void
  purchaseStarBranding: (id: string) => void
  purchaseBlackHole: (id: string) => void
  purchaseNarrativeResearch: (id: string) => void
  tickCosmic: (dt: number) => void

  // Prestige
  prestige: () => void
  purchasePrestigeUpgrade: (id: string) => void

  // Generic resource setter for effects
  applyEffect: (effect: Effect) => void
}
