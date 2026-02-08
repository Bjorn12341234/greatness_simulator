// ── Prestige Upgrades ──
// Permanent bonuses that persist across prestige resets.
// Costs paid in Prestige Points (PP) earned from total Greatness Units.

export interface PrestigeUpgradeDef {
  id: string
  name: string
  description: string
  icon: string
  cost: number          // PP cost
  effect: PrestigeEffect
  prerequisites?: string[] // other prestige upgrade IDs
}

export interface PrestigeEffect {
  type: 'click_power' | 'research_discount' | 'legitimacy_decay' | 'drift_cap'
    | 'offline_rate' | 'starting_bonus' | 'gps_multiplier' | 'event_cooldown'
    | 'institution_speed' | 'country_resistance'
  value: number
}

export const PRESTIGE_UPGRADES: PrestigeUpgradeDef[] = [
  {
    id: 'muscle_memory',
    name: 'Muscle Memory',
    description: 'Start with 10x click power. Your fingers remember.',
    icon: '💪',
    cost: 10,
    effect: { type: 'click_power', value: 10 },
  },
  {
    id: 'retained_knowledge',
    name: 'Retained Knowledge',
    description: 'All research 25% cheaper. The brain remembers what the wallet forgot.',
    icon: '📚',
    cost: 25,
    effect: { type: 'research_discount', value: 0.25 },
  },
  {
    id: 'institutional_inertia',
    name: 'Institutional Inertia',
    description: 'Legitimacy decays 50% slower. The machine has momentum.',
    icon: '⚖️',
    cost: 50,
    effect: { type: 'legitimacy_decay', value: 0.5 },
  },
  {
    id: 'accelerated_timeline',
    name: 'Accelerated Timeline',
    description: 'Institutions capture 30% faster. They were already weakened.',
    icon: '⏩',
    cost: 75,
    effect: { type: 'institution_speed', value: 0.3 },
  },
  {
    id: 'old_alliances',
    name: 'Old Alliances',
    description: 'Countries start with 15% less resistance. They remember who\'s in charge.',
    icon: '🤝',
    cost: 100,
    effect: { type: 'country_resistance', value: 0.15 },
  },
  {
    id: 'media_dynasty',
    name: 'Media Dynasty',
    description: '2x base Greatness Per Second. Your brand is eternal.',
    icon: '📺',
    cost: 150,
    effect: { type: 'gps_multiplier', value: 2.0 },
  },
  {
    id: 'event_fatigue',
    name: 'Event Fatigue',
    description: 'Events trigger 30% less frequently. The public is numb.',
    icon: '😴',
    cost: 200,
    effect: { type: 'event_cooldown', value: 0.3 },
  },
  {
    id: 'eternal_engine',
    name: 'The Eternal Engine',
    description: 'Offline earnings at 100% rate. Greatness doesn\'t sleep.',
    icon: '⚙️',
    cost: 500,
    effect: { type: 'offline_rate', value: 1.0 },
    prerequisites: ['retained_knowledge'],
  },
  {
    id: 'ontological_anchor',
    name: 'Ontological Anchor',
    description: 'Reality Drift maximum reduced by 20%. Some things stay real.',
    icon: '⚓',
    cost: 1000,
    effect: { type: 'drift_cap', value: 20 },
    prerequisites: ['media_dynasty'],
  },
  {
    id: 'recursive_greatness',
    name: 'Recursive Greatness',
    description: '5x base GpS. Greatness feeding on greatness feeding on greatness.',
    icon: '♾️',
    cost: 2500,
    effect: { type: 'gps_multiplier', value: 5.0 },
    prerequisites: ['media_dynasty', 'eternal_engine'],
  },
  {
    id: 'manifest_permanence',
    name: 'Manifest Permanence',
    description: 'Click power x50. Every tap reshapes the universe.',
    icon: '🌟',
    cost: 5000,
    effect: { type: 'click_power', value: 50 },
    prerequisites: ['muscle_memory', 'recursive_greatness'],
  },
  {
    id: 'the_golden_constant',
    name: 'The Golden Constant',
    description: 'Legitimacy never drops below 25%. The brand is too big to fail.',
    icon: '👑',
    cost: 10000,
    effect: { type: 'legitimacy_decay', value: 1.0 }, // special: floor at 25%
    prerequisites: ['institutional_inertia', 'ontological_anchor'],
  },
]

export function getPrestigeUpgradeDef(id: string): PrestigeUpgradeDef | undefined {
  return PRESTIGE_UPGRADES.find(u => u.id === id)
}

/** Calculate PP earned from a given amount of Greatness Units */
export function calculatePrestigePoints(greatnessUnits: number): number {
  return Math.floor(Math.log10(Math.max(1, greatnessUnits)))
}
