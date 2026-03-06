import Foundation

// MARK: - Constants

let TOTAL_REACHABLE_STARS = 1000
let COMPUTRONIUM_PER_STAR: Double = 100
let GU_PER_COMPUTRONIUM: Double = 10
let PROBE_REPLICATION_BASE: Double = 0.001
let STAR_DRIFT_PER_CONVERSION: Double = 0.1

// MARK: - MAGA Replicators (Von Neumann Probes)

struct ProbeUpgradeDef {
    let id: String
    let name: String
    let description: String
    let costCash: Double
    let costComputronium: Double
    let probeProductionPerSecond: Double
    let replicationRate: Double
    let conversionEfficiency: Double
    let prerequisite: String?
}

let probeUpgradeDefs: [ProbeUpgradeDef] = [
    ProbeUpgradeDef(
        id: "probe_factory",
        name: "MAGA Replicator Factory",
        description: "\"Make All Galaxies American\" — self-replicating branding units, hot off the assembly line.",
        costCash: 10_000_000,
        costComputronium: 0,
        probeProductionPerSecond: 0.1,
        replicationRate: 0,
        conversionEfficiency: 0,
        prerequisite: nil
    ),
    ProbeUpgradeDef(
        id: "replication_algorithm",
        name: "Exponential Branding Protocol",
        description: "Each probe teaches two more probes how to brand. It's a pyramid, but in space.",
        costCash: 50_000_000,
        costComputronium: 100,
        probeProductionPerSecond: 0,
        replicationRate: 0.05,
        conversionEfficiency: 0,
        prerequisite: "probe_factory"
    ),
    ProbeUpgradeDef(
        id: "swarm_intelligence",
        name: "Swarm Greatness Network",
        description: "Probes now coordinate via quantum-branded entanglement. Nobody knows what that means.",
        costCash: 200_000_000,
        costComputronium: 500,
        probeProductionPerSecond: 0,
        replicationRate: 0,
        conversionEfficiency: 2.0,
        prerequisite: "replication_algorithm"
    ),
    ProbeUpgradeDef(
        id: "galactic_distribution",
        name: "Galactic Distribution Network",
        description: "Every corner of the galaxy receives the Greatness signal. Returns are tremendous.",
        costCash: 1_000_000_000,
        costComputronium: 2000,
        probeProductionPerSecond: 1.0,
        replicationRate: 0.1,
        conversionEfficiency: 0,
        prerequisite: "swarm_intelligence"
    ),
]

let probeUpgradeRegistry: [String: ProbeUpgradeDef] = Dictionary(uniqueKeysWithValues: probeUpgradeDefs.map { ($0.id, $0) })

// MARK: - Solar Greatness Harvesters (Dyson Swarms)

struct DysonSwarmDef {
    let id: String
    let name: String
    let description: String
    let costCash: Double
    let costOrbitalIndustry: Double
    let costComputronium: Double
    let guPerSecond: Double
    let prerequisite: String?
}

let dysonSwarmDefs: [DysonSwarmDef] = [
    DysonSwarmDef(
        id: "solar_harvester_basic",
        name: "Solar Greatness Harvester Mk I",
        description: "The sun is just sitting there doing nothing useful. Time to monetize it.",
        costCash: 500_000_000,
        costOrbitalIndustry: 200,
        costComputronium: 100,
        guPerSecond: 10,
        prerequisite: nil
    ),
    DysonSwarmDef(
        id: "solar_harvester_advanced",
        name: "Solar Greatness Harvester Mk II",
        description: "Captures 50% of stellar output. The sun's performance review has improved significantly.",
        costCash: 2_000_000_000,
        costOrbitalIndustry: 500,
        costComputronium: 500,
        guPerSecond: 50,
        prerequisite: "solar_harvester_basic"
    ),
    DysonSwarmDef(
        id: "solar_harvester_total",
        name: "Total Stellar Acquisition",
        description: "Complete stellar energy capture. The sun is now a wholly-owned subsidiary of Greatness.",
        costCash: 10_000_000_000,
        costOrbitalIndustry: 1000,
        costComputronium: 2000,
        guPerSecond: 200,
        prerequisite: "solar_harvester_advanced"
    ),
]

let dysonSwarmRegistry: [String: DysonSwarmDef] = Dictionary(uniqueKeysWithValues: dysonSwarmDefs.map { ($0.id, $0) })

// MARK: - Star Branding (Star Conversion)

struct StarBrandingDef {
    let id: String
    let name: String
    let description: String
    let costCash: Double
    let costComputronium: Double
    let conversionRatePerSecond: Double
    let driftPerConversion: Double
    let prerequisite: String?
}

let starBrandingDefs: [StarBrandingDef] = [
    StarBrandingDef(
        id: "star_scanner",
        name: "Star Branding Scanner",
        description: "Identifies stars with high branding potential. Each star gets a name and a logo.",
        costCash: 5_000_000,
        costComputronium: 0,
        conversionRatePerSecond: 0,
        driftPerConversion: 0,
        prerequisite: nil
    ),
    StarBrandingDef(
        id: "branding_station",
        name: "Star Branding Station",
        description: "Converts one star at a time into pure Executive Processing substrate.",
        costCash: 50_000_000,
        costComputronium: 200,
        conversionRatePerSecond: 0.02,
        driftPerConversion: 1.0,
        prerequisite: "star_scanner"
    ),
    StarBrandingDef(
        id: "mass_branding",
        name: "Mass Branding Array",
        description: "Industrial-scale star conversion. The galaxy is getting a makeover.",
        costCash: 500_000_000,
        costComputronium: 1000,
        conversionRatePerSecond: 0.1,
        driftPerConversion: 1.0,
        prerequisite: "branding_station"
    ),
    StarBrandingDef(
        id: "galactic_rebranding",
        name: "Galactic Rebranding Initiative",
        description: "Every star in the observable universe receives the Greatness treatment. Nobody has ever seen anything like it.",
        costCash: 5_000_000_000,
        costComputronium: 5000,
        conversionRatePerSecond: 0.5,
        driftPerConversion: 1.0,
        prerequisite: "mass_branding"
    ),
]

let starBrandingRegistry: [String: StarBrandingDef] = Dictionary(uniqueKeysWithValues: starBrandingDefs.map { ($0.id, $0) })

// MARK: - Golden Ledger Singularity (Black Holes)

struct BlackHoleDef {
    let id: String
    let name: String
    let description: String
    let costCash: Double
    let costComputronium: Double
    let guStorage: Double
    let legitimacyPerSecond: Double
    let driftReduction: Double
    let prerequisite: String?
}

let blackHoleDefs: [BlackHoleDef] = [
    BlackHoleDef(
        id: "black_hole_capture",
        name: "Golden Ledger Singularity",
        description: "Where numbers go when they're too big to audit. A supermassive accounting innovation.",
        costCash: 100_000_000,
        costComputronium: 500,
        guStorage: 5,
        legitimacyPerSecond: 0,
        driftReduction: 0,
        prerequisite: nil
    ),
    BlackHoleDef(
        id: "gravitational_branding",
        name: "Gravitational Branding",
        description: "Black holes now emit Greatness radiation. Even light cannot escape the brand.",
        costCash: 500_000_000,
        costComputronium: 2000,
        guStorage: 20,
        legitimacyPerSecond: 0.01,
        driftReduction: 0,
        prerequisite: "black_hole_capture"
    ),
    BlackHoleDef(
        id: "hawking_dividend",
        name: "Hawking Dividend",
        description: "Black holes pay out over time. Hawking would be proud. Or horrified. Same thing.",
        costCash: 2_000_000_000,
        costComputronium: 5000,
        guStorage: 100,
        legitimacyPerSecond: 0.05,
        driftReduction: 0.001,
        prerequisite: "gravitational_branding"
    ),
]

let blackHoleRegistry: [String: BlackHoleDef] = Dictionary(uniqueKeysWithValues: blackHoleDefs.map { ($0.id, $0) })

// MARK: - Narrative Architecture (Reality Research)

struct NarrativeResearchDef {
    let id: String
    let name: String
    let description: String
    let costGU: Double
    let guMultiplier: Double
    let driftReduction: Double
    let legitimacyFloor: Double
    let productionBonus: Double
    let prerequisite: String?
}

let narrativeResearchDefs: [NarrativeResearchDef] = [
    NarrativeResearchDef(
        id: "physics_renegotiation",
        name: "Physics Renegotiation",
        description: "Speed of light now \"a suggestion.\" Our legal team has filed the paperwork with reality.",
        costGU: 1_000_000_000,
        guMultiplier: 1.5,
        driftReduction: 0,
        legitimacyFloor: 0,
        productionBonus: 50,
        prerequisite: nil
    ),
    NarrativeResearchDef(
        id: "entropy_reversal",
        name: "Entropy Reversal Memo",
        description: "Thermodynamics \"restructured.\" Heat death of the universe has been postponed indefinitely.",
        costGU: 10_000_000_000,
        guMultiplier: 2.0,
        driftReduction: 0.005,
        legitimacyFloor: 0,
        productionBonus: 0,
        prerequisite: "physics_renegotiation"
    ),
    NarrativeResearchDef(
        id: "causality_reassignment",
        name: "Causality Reassignment",
        description: "Time now flows in \"whatever direction is most great.\" Side effects may include paradoxes.",
        costGU: 100_000_000_000,
        guMultiplier: 3.0,
        driftReduction: 0,
        legitimacyFloor: 25,
        productionBonus: 0,
        prerequisite: "entropy_reversal"
    ),
    NarrativeResearchDef(
        id: "ontological_supremacy",
        name: "Ontological Supremacy",
        description: "Reality itself is now a Greatness product. Everything that exists, exists because it's great.",
        costGU: 1_000_000_000_000,
        guMultiplier: 5.0,
        driftReduction: 0.01,
        legitimacyFloor: 50,
        productionBonus: 500,
        prerequisite: "causality_reassignment"
    ),
]

let narrativeResearchRegistry: [String: NarrativeResearchDef] = Dictionary(uniqueKeysWithValues: narrativeResearchDefs.map { ($0.id, $0) })
