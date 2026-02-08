// ── Phase 5: God Emperor Protocol — Universe Systems ──
// Trumpified names per sprint7_rebrands.md:
//   Von Neumann Probes → MAGA Replicators
//   Dyson Swarm → Solar Greatness Harvester
//   Star Conversion → Star Branding
//   Black Hole Accounting → Golden Ledger Singularity
//   Reality Rebranding → Narrative Architecture

// ── MAGA Replicators (Von Neumann Probes) ──

export interface ProbeUpgradeDef {
  id: string
  name: string
  description: string
  costCash: number
  costComputronium: number
  effect: {
    probeProductionPerSecond?: number
    replicationRate?: number     // multiplier on probe self-replication
    conversionEfficiency?: number // multiplier on star conversion
  }
  prerequisite: string | null
}

export const PROBE_UPGRADES: ProbeUpgradeDef[] = [
  {
    id: 'probe_factory',
    name: 'MAGA Replicator Factory',
    description: '"Make All Galaxies American" — self-replicating branding units, hot off the assembly line.',
    costCash: 10_000_000,
    costComputronium: 0,
    effect: { probeProductionPerSecond: 0.1 },
    prerequisite: null,
  },
  {
    id: 'replication_algorithm',
    name: 'Exponential Branding Protocol',
    description: 'Each probe teaches two more probes how to brand. It\'s a pyramid, but in space.',
    costCash: 50_000_000,
    costComputronium: 100,
    effect: { replicationRate: 0.05 },
    prerequisite: 'probe_factory',
  },
  {
    id: 'swarm_intelligence',
    name: 'Swarm Greatness Network',
    description: 'Probes now coordinate via quantum-branded entanglement. Nobody knows what that means.',
    costCash: 200_000_000,
    costComputronium: 500,
    effect: { conversionEfficiency: 2.0 },
    prerequisite: 'replication_algorithm',
  },
  {
    id: 'galactic_distribution',
    name: 'Galactic Distribution Network',
    description: 'Every corner of the galaxy receives the Greatness signal. Returns are tremendous.',
    costCash: 1_000_000_000,
    costComputronium: 2000,
    effect: { probeProductionPerSecond: 1.0, replicationRate: 0.1 },
    prerequisite: 'swarm_intelligence',
  },
]

export function getProbeUpgradeDef(id: string): ProbeUpgradeDef | undefined {
  return PROBE_UPGRADES.find(u => u.id === id)
}

// ── Solar Greatness Harvesters (Dyson Swarms) ──

export interface DysonSwarmDef {
  id: string
  name: string
  description: string
  costCash: number
  costOrbitalIndustry: number
  costComputronium: number
  guPerSecond: number
  prerequisite: string | null
}

export const DYSON_SWARM_TIERS: DysonSwarmDef[] = [
  {
    id: 'solar_harvester_basic',
    name: 'Solar Greatness Harvester Mk I',
    description: 'The sun is just sitting there doing nothing useful. Time to monetize it.',
    costCash: 500_000_000,
    costOrbitalIndustry: 200,
    costComputronium: 100,
    guPerSecond: 10,
    prerequisite: null,
  },
  {
    id: 'solar_harvester_advanced',
    name: 'Solar Greatness Harvester Mk II',
    description: 'Captures 50% of stellar output. The sun\'s performance review has improved significantly.',
    costCash: 2_000_000_000,
    costOrbitalIndustry: 500,
    costComputronium: 500,
    guPerSecond: 50,
    prerequisite: 'solar_harvester_basic',
  },
  {
    id: 'solar_harvester_total',
    name: 'Total Stellar Acquisition',
    description: 'Complete stellar energy capture. The sun is now a wholly-owned subsidiary of Greatness.',
    costCash: 10_000_000_000,
    costOrbitalIndustry: 1000,
    costComputronium: 2000,
    guPerSecond: 200,
    prerequisite: 'solar_harvester_advanced',
  },
]

export function getDysonSwarmDef(id: string): DysonSwarmDef | undefined {
  return DYSON_SWARM_TIERS.find(d => d.id === id)
}

// ── Star Branding (Star Conversion) ──

export interface StarBrandingDef {
  id: string
  name: string
  description: string
  costCash: number
  costComputronium: number
  conversionRatePerSecond: number  // stars converted per second
  driftPerConversion: number       // reality drift per star converted
  prerequisite: string | null
}

export const STAR_BRANDING_TIERS: StarBrandingDef[] = [
  {
    id: 'star_scanner',
    name: 'Star Branding Scanner',
    description: 'Identifies stars with high branding potential. Each star gets a name and a logo.',
    costCash: 5_000_000,
    costComputronium: 0,
    conversionRatePerSecond: 0,    // enables conversion but doesn't do it
    driftPerConversion: 0,
    prerequisite: null,
  },
  {
    id: 'branding_station',
    name: 'Star Branding Station',
    description: 'Converts one star at a time into pure Executive Processing substrate.',
    costCash: 50_000_000,
    costComputronium: 200,
    conversionRatePerSecond: 0.02,  // 1 star per 50 seconds
    driftPerConversion: 1.0,
    prerequisite: 'star_scanner',
  },
  {
    id: 'mass_branding',
    name: 'Mass Branding Array',
    description: 'Industrial-scale star conversion. The galaxy is getting a makeover.',
    costCash: 500_000_000,
    costComputronium: 1000,
    conversionRatePerSecond: 0.1,   // 1 star per 10 seconds
    driftPerConversion: 1.0,
    prerequisite: 'branding_station',
  },
  {
    id: 'galactic_rebranding',
    name: 'Galactic Rebranding Initiative',
    description: 'Every star in the observable universe receives the Greatness treatment. Nobody has ever seen anything like it.',
    costCash: 5_000_000_000,
    costComputronium: 5000,
    conversionRatePerSecond: 0.5,   // 1 star per 2 seconds
    driftPerConversion: 1.0,
    prerequisite: 'mass_branding',
  },
]

export function getStarBrandingDef(id: string): StarBrandingDef | undefined {
  return STAR_BRANDING_TIERS.find(s => s.id === id)
}

// ── Golden Ledger Singularity (Black Hole Accounting) ──

export interface BlackHoleDef {
  id: string
  name: string
  description: string
  costCash: number
  costComputronium: number
  effect: {
    guStorage?: number             // passive GU per second from storage
    legitimacyPerSecond?: number   // passive legitimacy gain
    driftReduction?: number        // drift reduction per second
  }
  prerequisite: string | null
}

export const BLACK_HOLE_UPGRADES: BlackHoleDef[] = [
  {
    id: 'black_hole_capture',
    name: 'Golden Ledger Singularity',
    description: 'Where numbers go when they\'re too big to audit. A supermassive accounting innovation.',
    costCash: 100_000_000,
    costComputronium: 500,
    effect: { guStorage: 5 },
    prerequisite: null,
  },
  {
    id: 'gravitational_branding',
    name: 'Gravitational Branding',
    description: 'Black holes now emit Greatness radiation. Even light cannot escape the brand.',
    costCash: 500_000_000,
    costComputronium: 2000,
    effect: { guStorage: 20, legitimacyPerSecond: 0.01 },
    prerequisite: 'black_hole_capture',
  },
  {
    id: 'hawking_dividend',
    name: 'Hawking Dividend',
    description: 'Black holes pay out over time. Hawking would be proud. Or horrified. Same thing.',
    costCash: 2_000_000_000,
    costComputronium: 5000,
    effect: { guStorage: 100, legitimacyPerSecond: 0.05, driftReduction: 0.001 },
    prerequisite: 'gravitational_branding',
  },
]

export function getBlackHoleDef(id: string): BlackHoleDef | undefined {
  return BLACK_HOLE_UPGRADES.find(b => b.id === id)
}

// ── Narrative Architecture (Reality Rebranding Research Tree) ──

export interface NarrativeResearchDef {
  id: string
  name: string
  description: string
  costGU: number
  effect: {
    guMultiplier?: number          // multiplier on all GU production
    driftReduction?: number        // drift reduction rate
    legitimacyFloor?: number       // minimum legitimacy percentage
    productionBonus?: number       // flat GU/second bonus
  }
  prerequisite: string | null
}

export const NARRATIVE_RESEARCH: NarrativeResearchDef[] = [
  {
    id: 'physics_renegotiation',
    name: 'Physics Renegotiation',
    description: 'Speed of light now "a suggestion." Our legal team has filed the paperwork with reality.',
    costGU: 1_000_000_000,
    effect: { guMultiplier: 1.5, productionBonus: 50 },
    prerequisite: null,
  },
  {
    id: 'entropy_reversal',
    name: 'Entropy Reversal Memo',
    description: 'Thermodynamics "restructured." Heat death of the universe has been postponed indefinitely.',
    costGU: 10_000_000_000,
    effect: { driftReduction: 0.005, guMultiplier: 2.0 },
    prerequisite: 'physics_renegotiation',
  },
  {
    id: 'causality_reassignment',
    name: 'Causality Reassignment',
    description: 'Time now flows in "whatever direction is most great." Side effects may include paradoxes.',
    costGU: 100_000_000_000,
    effect: { legitimacyFloor: 25, guMultiplier: 3.0 },
    prerequisite: 'entropy_reversal',
  },
  {
    id: 'ontological_supremacy',
    name: 'Ontological Supremacy',
    description: 'Reality itself is now a Greatness product. Everything that exists, exists because it\'s great.',
    costGU: 1_000_000_000_000,
    effect: { guMultiplier: 5.0, productionBonus: 500, driftReduction: 0.01, legitimacyFloor: 50 },
    prerequisite: 'causality_reassignment',
  },
]

export function getNarrativeResearchDef(id: string): NarrativeResearchDef | undefined {
  return NARRATIVE_RESEARCH.find(n => n.id === id)
}

// ── Constants ──

export const TOTAL_REACHABLE_STARS = 1000
export const COMPUTRONIUM_PER_STAR = 100       // computronium gained per star converted
export const GU_PER_COMPUTRONIUM = 10          // base GU production per computronium unit per second
export const PROBE_REPLICATION_BASE = 0.001    // base self-replication rate per probe per second
export const STAR_DRIFT_PER_CONVERSION = 0.1   // reality drift per star converted
