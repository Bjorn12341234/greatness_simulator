import type { LaunchTier } from '../../store/types'

// ── Launch Tiers ──

export interface LaunchTierDef {
  id: LaunchTier
  name: string
  costCash: number
  rocketMassPerSecond: number
  prerequisite: LaunchTier
  description: string
}

export const LAUNCH_TIERS: LaunchTierDef[] = [
  {
    id: 'launchpad',
    name: 'Greatness Launchpad',
    costCash: 500_000,
    rocketMassPerSecond: 0.5,
    prerequisite: 'none',
    description: 'A golden launchpad. More symbolic than functional.',
  },
  {
    id: 'spaceport',
    name: 'Executive Spaceport',
    costCash: 5_000_000,
    rocketMassPerSecond: 2,
    prerequisite: 'launchpad',
    description: 'First class lounge included. Second class not available.',
  },
  {
    id: 'orbital_elevator',
    name: 'Orbital Elevator',
    costCash: 25_000_000,
    rocketMassPerSecond: 8,
    prerequisite: 'spaceport',
    description: 'Goes up. Faster than the economy.',
  },
  {
    id: 'mass_driver',
    name: 'Mass Driver',
    costCash: 100_000_000,
    rocketMassPerSecond: 25,
    prerequisite: 'orbital_elevator',
    description: 'Electromagnetic catapult. "For cargo." Mostly.',
  },
]

// ── Lunar Buildings ──

export interface LunarBuildingDef {
  id: string
  name: string
  costCash: number
  costRocketMass: number
  prerequisite: string | null
  effects: {
    orbitalIndustryPerSecond?: number
    miningOutputPerSecond?: number
    legitimacyPerSecond?: number
    shipCostReduction?: number
  }
  description: string
}

export const LUNAR_BUILDINGS: LunarBuildingDef[] = [
  {
    id: 'moon_base',
    name: 'Moon Base Alpha',
    costCash: 2_000_000,
    costRocketMass: 50,
    prerequisite: null,
    effects: { orbitalIndustryPerSecond: 1 },
    description: 'One small step for Greatness, one giant leap for branding.',
  },
  {
    id: 'he3_mining',
    name: 'He-3 Mining Complex',
    costCash: 5_000_000,
    costRocketMass: 100,
    prerequisite: 'moon_base',
    effects: { miningOutputPerSecond: 2, orbitalIndustryPerSecond: 0.5 },
    description: 'Helium-3 extraction. Clean energy or weapons fuel — why not both?',
  },
  {
    id: 'lunar_shipyard',
    name: 'Lunar Shipyard',
    costCash: 10_000_000,
    costRocketMass: 200,
    prerequisite: 'he3_mining',
    effects: { orbitalIndustryPerSecond: 2, shipCostReduction: 0.15 },
    description: 'Building ships in low gravity. Efficiency through lack of regulation.',
  },
  {
    id: 'lunar_heritage',
    name: 'Lunar Heritage Site',
    costCash: 3_000_000,
    costRocketMass: 50,
    prerequisite: 'moon_base',
    effects: { legitimacyPerSecond: 0.02 },
    description: '"Preserving" the Apollo landing site. With a gift shop and a flag swap.',
  },
]

// ── Mars Upgrades ──

export interface MarsUpgradeDef {
  id: string
  name: string
  costCash: number
  costRocketMass: number
  costMiningOutput: number
  prerequisite: string | null
  effects: {
    colonistsPerSecond?: number
    terraformPerSecond?: number
    greatnessPerSecond?: number
  }
  description: string
  renamedName?: string
}

export const MARS_UPGRADES: MarsUpgradeDef[] = [
  {
    id: 'mars_colony',
    name: 'Mars Colony',
    costCash: 8_000_000,
    costRocketMass: 150,
    costMiningOutput: 0,
    prerequisite: null,
    effects: { colonistsPerSecond: 0.5, greatnessPerSecond: 5 },
    description: 'First permanent settlement. Volunteers only. Sort of.',
    renamedName: 'Orange Planet Colony',
  },
  {
    id: 'atmosphere_processing',
    name: 'Atmosphere Processing',
    costCash: 15_000_000,
    costRocketMass: 300,
    costMiningOutput: 50,
    prerequisite: 'mars_colony',
    effects: { terraformPerSecond: 0.01, greatnessPerSecond: 10 },
    description: 'Making the air breathable. Or at least brandable.',
    renamedName: 'Victory Atmospheric Division',
  },
  {
    id: 'water_extraction',
    name: 'Water Extraction',
    costCash: 20_000_000,
    costRocketMass: 400,
    costMiningOutput: 100,
    prerequisite: 'atmosphere_processing',
    effects: { colonistsPerSecond: 1, terraformPerSecond: 0.02, greatnessPerSecond: 15 },
    description: 'Liquid water found. Immediately privatized.',
    renamedName: 'Freedom Springs',
  },
]

// Mars renamed location names
export const MARS_RENAMED_LABELS: Record<string, string> = {
  'Mars': 'The Orange Planet',
  'Olympus Mons': 'Victory Peak',
  'Valles Marineris': 'Freedom Canyon',
  'Hellas Basin': 'Greatness Basin',
  'Tharsis Plateau': 'Executive Plateau',
}

// ── Asteroid Tiers ──

export interface AsteroidTierDef {
  id: string
  name: string
  costCash: number
  costRocketMass: number
  miningOutputPerUnit: number
  maxCount: number
  prerequisite: string | null
  description: string
}

export const ASTEROID_TIERS: AsteroidTierDef[] = [
  {
    id: 'prospector_drones',
    name: 'Prospector Drones',
    costCash: 1_000_000,
    costRocketMass: 20,
    miningOutputPerUnit: 1,
    maxCount: 10,
    prerequisite: null,
    description: 'Autonomous mining scouts. They don\'t need benefits.',
  },
  {
    id: 'mining_rigs',
    name: 'Mining Rigs',
    costCash: 3_000_000,
    costRocketMass: 50,
    miningOutputPerUnit: 3,
    maxCount: 10,
    prerequisite: 'prospector_drones',
    description: 'Industrial extraction platforms. OSHA has no jurisdiction here.',
  },
  {
    id: 'refineries',
    name: 'Orbital Refineries',
    costCash: 8_000_000,
    costRocketMass: 100,
    miningOutputPerUnit: 8,
    maxCount: 5,
    prerequisite: 'mining_rigs',
    description: 'Processing raw asteroid into pure profit.',
  },
]

// ── Propaganda Satellites ──

export interface PropagandaSatelliteDef {
  costCash: number
  costOrbitalIndustry: number
  maxCount: number
  legitimacyPerUnit: number
  attentionPerUnit: number
  driftPerUnit: number
}

export const PROPAGANDA_SATELLITE: PropagandaSatelliteDef = {
  costCash: 5_000_000,
  costOrbitalIndustry: 10,
  maxCount: 20,
  legitimacyPerUnit: 0.01,
  attentionPerUnit: 50,
  driftPerUnit: 0.001,
}

// ── Dyson Swarm Prototype ──

export interface DysonPrototypeDef {
  costCash: number
  costOrbitalIndustry: number
  requiresLaunchTier: LaunchTier
  requiresOrbitalIndustry: number
  description: string
}

export const DYSON_PROTOTYPE: DysonPrototypeDef = {
  costCash: 200_000_000,
  costOrbitalIndustry: 80,
  requiresLaunchTier: 'mass_driver',
  requiresOrbitalIndustry: 80,
  description: 'A prototype stellar harvester. The sun is just an untapped resource.',
}

// ── Helper Functions ──

export function getLaunchTierDef(tier: LaunchTier): LaunchTierDef | undefined {
  return LAUNCH_TIERS.find(t => t.id === tier)
}

export function getNextLaunchTier(current: LaunchTier): LaunchTierDef | undefined {
  return LAUNCH_TIERS.find(t => t.prerequisite === current)
}

export function getLunarBuildingDef(id: string): LunarBuildingDef | undefined {
  return LUNAR_BUILDINGS.find(b => b.id === id)
}

export function getMarsUpgradeDef(id: string): MarsUpgradeDef | undefined {
  return MARS_UPGRADES.find(u => u.id === id)
}

export function getAsteroidTierDef(id: string): AsteroidTierDef | undefined {
  return ASTEROID_TIERS.find(t => t.id === id)
}

const TIER_ORDER: LaunchTier[] = ['none', 'launchpad', 'spaceport', 'orbital_elevator', 'mass_driver']

export function hasLaunchTier(current: LaunchTier, required: LaunchTier): boolean {
  return TIER_ORDER.indexOf(current) >= TIER_ORDER.indexOf(required)
}
