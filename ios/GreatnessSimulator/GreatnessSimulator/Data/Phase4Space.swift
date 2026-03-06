import Foundation

// MARK: - Launch Tiers

struct LaunchTierDef {
    let id: LaunchTier
    let name: String
    let costCash: Double
    let rocketMassPerSecond: Double
    let prerequisite: LaunchTier
    let description: String
}

let launchTierDefs: [LaunchTierDef] = [
    LaunchTierDef(
        id: .launchpad,
        name: "Greatness Launchpad",
        costCash: 500_000,
        rocketMassPerSecond: 0.5,
        prerequisite: .none,
        description: "A golden launchpad. More symbolic than functional."
    ),
    LaunchTierDef(
        id: .spaceport,
        name: "Executive Spaceport",
        costCash: 5_000_000,
        rocketMassPerSecond: 2,
        prerequisite: .launchpad,
        description: "First class lounge included. Second class not available."
    ),
    LaunchTierDef(
        id: .orbitalElevator,
        name: "Orbital Elevator",
        costCash: 25_000_000,
        rocketMassPerSecond: 8,
        prerequisite: .spaceport,
        description: "Goes up. Faster than the economy."
    ),
    LaunchTierDef(
        id: .massDriver,
        name: "Mass Driver",
        costCash: 100_000_000,
        rocketMassPerSecond: 25,
        prerequisite: .orbitalElevator,
        description: "Electromagnetic catapult. \"For cargo.\" Mostly."
    ),
]

let launchTierRegistry: [LaunchTier: LaunchTierDef] = {
    var dict: [LaunchTier: LaunchTierDef] = [:]
    for def in launchTierDefs { dict[def.id] = def }
    return dict
}()

let launchTierOrder: [LaunchTier] = [.none, .launchpad, .spaceport, .orbitalElevator, .massDriver]

func hasLaunchTier(current: LaunchTier, required: LaunchTier) -> Bool {
    guard let ci = launchTierOrder.firstIndex(of: current),
          let ri = launchTierOrder.firstIndex(of: required) else { return false }
    return ci >= ri
}

func nextLaunchTier(after current: LaunchTier) -> LaunchTierDef? {
    launchTierDefs.first { $0.prerequisite == current }
}

// MARK: - Lunar Buildings

struct LunarBuildingDef {
    let id: String
    let name: String
    let costCash: Double
    let costRocketMass: Double
    let prerequisite: String?
    let orbitalIndustryPerSecond: Double
    let miningOutputPerSecond: Double
    let legitimacyPerSecond: Double
    let shipCostReduction: Double
    let description: String
}

let lunarBuildingDefs: [LunarBuildingDef] = [
    LunarBuildingDef(
        id: "moon_base",
        name: "Moon Base Alpha",
        costCash: 2_000_000,
        costRocketMass: 50,
        prerequisite: nil,
        orbitalIndustryPerSecond: 1,
        miningOutputPerSecond: 0,
        legitimacyPerSecond: 0,
        shipCostReduction: 0,
        description: "One small step for Greatness, one giant leap for branding."
    ),
    LunarBuildingDef(
        id: "he3_mining",
        name: "He-3 Mining Complex",
        costCash: 5_000_000,
        costRocketMass: 100,
        prerequisite: "moon_base",
        orbitalIndustryPerSecond: 0.5,
        miningOutputPerSecond: 2,
        legitimacyPerSecond: 0,
        shipCostReduction: 0,
        description: "Helium-3 extraction. Clean energy or weapons fuel — why not both?"
    ),
    LunarBuildingDef(
        id: "lunar_shipyard",
        name: "Lunar Shipyard",
        costCash: 10_000_000,
        costRocketMass: 200,
        prerequisite: "he3_mining",
        orbitalIndustryPerSecond: 2,
        miningOutputPerSecond: 0,
        legitimacyPerSecond: 0,
        shipCostReduction: 0.15,
        description: "Building ships in low gravity. Efficiency through lack of regulation."
    ),
    LunarBuildingDef(
        id: "lunar_heritage",
        name: "Lunar Heritage Site",
        costCash: 3_000_000,
        costRocketMass: 50,
        prerequisite: "moon_base",
        orbitalIndustryPerSecond: 0,
        miningOutputPerSecond: 0,
        legitimacyPerSecond: 0.02,
        shipCostReduction: 0,
        description: "\"Preserving\" the Apollo landing site. With a gift shop and a flag swap."
    ),
]

let lunarBuildingRegistry: [String: LunarBuildingDef] = {
    var dict: [String: LunarBuildingDef] = [:]
    for def in lunarBuildingDefs { dict[def.id] = def }
    return dict
}()

// MARK: - Mars Upgrades

struct MarsUpgradeDef {
    let id: String
    let name: String
    let costCash: Double
    let costRocketMass: Double
    let costMiningOutput: Double
    let prerequisite: String?
    let colonistsPerSecond: Double
    let terraformPerSecond: Double
    let greatnessPerSecond: Double
    let renamedName: String?
    let description: String
}

let marsUpgradeDefs: [MarsUpgradeDef] = [
    MarsUpgradeDef(
        id: "mars_colony",
        name: "Mars Colony",
        costCash: 8_000_000,
        costRocketMass: 150,
        costMiningOutput: 0,
        prerequisite: nil,
        colonistsPerSecond: 0.5,
        terraformPerSecond: 0,
        greatnessPerSecond: 5,
        renamedName: "Orange Planet Colony",
        description: "First permanent settlement. Volunteers only. Sort of."
    ),
    MarsUpgradeDef(
        id: "atmosphere_processing",
        name: "Atmosphere Processing",
        costCash: 15_000_000,
        costRocketMass: 300,
        costMiningOutput: 50,
        prerequisite: "mars_colony",
        colonistsPerSecond: 0,
        terraformPerSecond: 0.01,
        greatnessPerSecond: 10,
        renamedName: "Victory Atmospheric Division",
        description: "Making the air breathable. Or at least brandable."
    ),
    MarsUpgradeDef(
        id: "water_extraction",
        name: "Water Extraction",
        costCash: 20_000_000,
        costRocketMass: 400,
        costMiningOutput: 100,
        prerequisite: "atmosphere_processing",
        colonistsPerSecond: 1,
        terraformPerSecond: 0.02,
        greatnessPerSecond: 15,
        renamedName: "Freedom Springs",
        description: "Liquid water found. Immediately privatized."
    ),
]

let marsUpgradeRegistry: [String: MarsUpgradeDef] = {
    var dict: [String: MarsUpgradeDef] = [:]
    for def in marsUpgradeDefs { dict[def.id] = def }
    return dict
}()

let marsRenamedLabels: [String: String] = [
    "Mars": "The Orange Planet",
    "Olympus Mons": "Victory Peak",
    "Valles Marineris": "Freedom Canyon",
    "Hellas Basin": "Greatness Basin",
    "Tharsis Plateau": "Executive Plateau",
]

// MARK: - Asteroid Tiers

struct AsteroidTierDef {
    let id: String
    let name: String
    let costCash: Double
    let costRocketMass: Double
    let miningOutputPerUnit: Double
    let maxCount: Int
    let prerequisite: String?
    let description: String
}

let asteroidTierDefs: [AsteroidTierDef] = [
    AsteroidTierDef(
        id: "prospector_drones",
        name: "Prospector Drones",
        costCash: 1_000_000,
        costRocketMass: 20,
        miningOutputPerUnit: 1,
        maxCount: 10,
        prerequisite: nil,
        description: "Autonomous mining scouts. They don't need benefits."
    ),
    AsteroidTierDef(
        id: "mining_rigs",
        name: "Mining Rigs",
        costCash: 3_000_000,
        costRocketMass: 50,
        miningOutputPerUnit: 3,
        maxCount: 10,
        prerequisite: "prospector_drones",
        description: "Industrial extraction platforms. OSHA has no jurisdiction here."
    ),
    AsteroidTierDef(
        id: "refineries",
        name: "Orbital Refineries",
        costCash: 8_000_000,
        costRocketMass: 100,
        miningOutputPerUnit: 8,
        maxCount: 5,
        prerequisite: "mining_rigs",
        description: "Processing raw asteroid into pure profit."
    ),
]

let asteroidTierRegistry: [String: AsteroidTierDef] = {
    var dict: [String: AsteroidTierDef] = [:]
    for def in asteroidTierDefs { dict[def.id] = def }
    return dict
}()

// MARK: - Propaganda Satellites

let propagandaSatelliteCostCash: Double = 5_000_000
let propagandaSatelliteCostOI: Double = 10
let propagandaSatelliteMax: Int = 20
let propagandaSatelliteLegitimacyPerUnit: Double = 0.01
let propagandaSatelliteAttentionPerUnit: Double = 50
let propagandaSatelliteDriftPerUnit: Double = 0.001

// MARK: - Dyson Swarm Prototype

let dysonPrototypeCostCash: Double = 200_000_000
let dysonPrototypeCostOI: Double = 80
let dysonPrototypeRequiresLaunchTier: LaunchTier = .massDriver
let dysonPrototypeRequiresOI: Double = 80
let dysonPrototypeDescription = "A prototype stellar harvester. The sun is just an untapped resource."

// MARK: - Bridge Upgrades

struct BridgeUpgradeDef {
    let id: String
    let name: String
    let costCash: Double
    let costLoyalty: Double
    let prerequisite: String?
    let effect: String
    let description: String
}

let bridgeUpgradeDefs: [BridgeUpgradeDef] = [
    BridgeUpgradeDef(
        id: "long_term_thinking",
        name: "Long-Term Thinking Simulator",
        costCash: 1_000_000,
        costLoyalty: 0,
        prerequisite: nil,
        effect: "spaceResearchSpeed+50%",
        description: "An AI that simulates thinking about the future so you don't have to."
    ),
    BridgeUpgradeDef(
        id: "science_rebranding",
        name: "Science Rebranding Initiative",
        costCash: 2_000_000,
        costLoyalty: 0,
        prerequisite: "long_term_thinking",
        effect: "scienceLegitimacyDrainRemoved",
        description: "Rename \"Science\" to \"Greatness Research.\" Problem solved."
    ),
    BridgeUpgradeDef(
        id: "reality_budgeting",
        name: "Reality-Compatible Budgeting",
        costCash: 5_000_000,
        costLoyalty: 0,
        prerequisite: "science_rebranding",
        effect: "spaceCostReduction30%",
        description: "Costs are now calculated in a reality where everything is 30% cheaper."
    ),
    BridgeUpgradeDef(
        id: "patience_campaign",
        name: "Patience Campaign",
        costCash: 3_000_000,
        costLoyalty: 500,
        prerequisite: "reality_budgeting",
        effect: "slowProgressDrainRemoved",
        description: "\"Good things come to those who wait\" — delivered via mandatory seminar."
    ),
]

let bridgeUpgradeRegistry: [String: BridgeUpgradeDef] = {
    var dict: [String: BridgeUpgradeDef] = [:]
    for def in bridgeUpgradeDefs { dict[def.id] = def }
    return dict
}()
