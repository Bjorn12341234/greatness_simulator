import Foundation

// MARK: - Phase

enum Phase: Int, Codable, CaseIterable {
    case personalBrand = 1
    case institutionalCapture = 2
    case worldGreatening = 3
    case spaceGreatening = 4
    case cosmicGreatening = 5

    var title: String {
        switch self {
        case .personalBrand: return "Personal Brand"
        case .institutionalCapture: return "Institutional Capture"
        case .worldGreatening: return "World Greatening"
        case .spaceGreatening: return "Space Greatening"
        case .cosmicGreatening: return "Cosmic Greatening"
        }
    }
}

// MARK: - Upgrade Data (static config, not state)

struct UpgradeData: Identifiable {
    let id: String
    let name: String
    let description: String
    let tree: String
    let icon: String
    let baseCost: Double
    let costResource: CostResource
    let production: Double       // GpS added per purchase
    let maxCount: Int            // 1 = one-time, >1 = repeatable
    let effects: [UpgradeEffect]
    let prerequisites: [String]
    let unlockAt: UnlockCondition?
    let phase: Int

    init(
        id: String,
        name: String,
        description: String,
        tree: String,
        icon: String,
        baseCost: Double,
        costResource: CostResource,
        production: Double,
        maxCount: Int,
        effects: [UpgradeEffect] = [],
        prerequisites: [String] = [],
        unlockAt: UnlockCondition? = nil,
        phase: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.tree = tree
        self.icon = icon
        self.baseCost = baseCost
        self.costResource = costResource
        self.production = production
        self.maxCount = maxCount
        self.effects = effects
        self.prerequisites = prerequisites
        self.unlockAt = unlockAt
        self.phase = phase
    }
}

enum CostResource: String, Codable {
    case attention
    case cash
    case greatness
}

struct UpgradeEffect: Codable {
    let type: UpgradeEffectType
    let value: Double
}

enum UpgradeEffectType: String, Codable {
    case attentionPerClick
    case attentionPerSecond
    case cashPerSecond
    case gpsMultiplier
}

struct UnlockCondition {
    let resource: String   // "attention", "greatness", "cash", "clickCount"
    let threshold: Double
}

// MARK: - Upgrade State (player progress)

struct UpgradeState: Codable {
    var purchased: Bool = false
    var count: Int = 0
    var unlocked: Bool = false
}

// MARK: - Event Types

enum EventCategory: String, Codable {
    case scandal
    case opportunity
    case contradiction
    case absurd
    case crisis
    case nobel
    case realityGlitch = "reality_glitch"
}

struct GameEvent: Identifiable, Codable {
    let id: String
    let phase: Int
    let category: EventCategory
    let headline: String
    let context: String
    let choices: [EventChoice]
    let conditions: [EventCondition]
    let cooldown: Double?
    let unique: Bool

    init(
        id: String,
        phase: Int,
        category: EventCategory,
        headline: String,
        context: String,
        choices: [EventChoice],
        conditions: [EventCondition] = [],
        cooldown: Double? = nil,
        unique: Bool = false
    ) {
        self.id = id
        self.phase = phase
        self.category = category
        self.headline = headline
        self.context = context
        self.choices = choices
        self.conditions = conditions
        self.cooldown = cooldown
        self.unique = unique
    }
}

struct EventChoice: Codable {
    let label: String
    let effects: [Effect]
    let description: String?

    init(label: String, effects: [Effect], description: String? = nil) {
        self.label = label
        self.effects = effects
        self.description = description
    }
}

struct Effect: Codable {
    let resource: String
    let amount: Double
    let type: EffectType
    let duration: Double?

    init(resource: String, amount: Double, type: EffectType = .add, duration: Double? = nil) {
        self.resource = resource
        self.amount = amount
        self.type = type
        self.duration = duration
    }
}

enum EffectType: String, Codable {
    case add
    case multiply
    case set
}

struct EventCondition: Codable {
    let resource: String
    let op: ConditionOperator
    let value: Double

    enum ConditionOperator: String, Codable {
        case gt = ">"
        case lt = "<"
        case gte = ">="
        case lte = "<="
        case eq = "=="
    }
}

// MARK: - Institution Types (Phase 2)

enum InstitutionStatus: String, Codable {
    case independent
    case coOpting = "co-opting"
    case replacing
    case purging
    case captured
    case automated
}

struct InstitutionState: Codable {
    var status: InstitutionStatus = .independent
    var resistance: Double = 100
    var progress: Double = 0
    var actionStartedAt: Double? = nil
    var rebranded: Bool = false
}

// MARK: - Country Types (Phase 3)

enum CountryStatus: String, Codable {
    case independent
    case sanctioned
    case infiltrated
    case coupTarget = "coup_target"
    case occupied
    case annexed
    case allied
}

struct CountryState: Codable {
    var status: CountryStatus = .independent
    var resistance: Double = 100
    var stability: Double = 100
    var activeOperations: [ActiveOperation] = []
    var refugeeWavesSent: Int = 0
    var encirclement: Double = 0
    var tradeDependency: Double = 0
    var purchaseOffers: Int = 0
    var kompromatLevel: Double = 0
}

struct ActiveOperation: Codable {
    let tacticType: String
    let startedAt: Double
    let duration: Double
}

// MARK: - Budget (Phase 2+)

struct BudgetAllocation: Codable {
    var healthcare: Double = 15
    var education: Double = 15
    var socialBenefits: Double = 15
    var military: Double = 10
    var dataCenters: Double = 10
    var infrastructure: Double = 15
    var propagandaBureau: Double = 10
    var spaceProgram: Double = 10
}

// MARK: - Tariff (Phase 2+)

struct TariffState: Codable {
    var active: Bool = false
    var level: Int = 0
    var cashGenerated: Double = 0
    var sideEffectAccumulated: Double = 0
}

// MARK: - Contradiction

struct ContradictionState: Codable {
    var sideA: Double = 0
    var sideB: Double = 0
    var balancedTime: Double = 0
    var active: Bool = false
}

// MARK: - Shipyard (Phase 3)

struct ShipyardOrder: Codable {
    let shipId: String
    let quantity: Int
    var builtSoFar: Int = 0
    var lastBuildAt: Double = 0
}

// MARK: - Space (Phase 4)

enum LaunchTier: String, Codable {
    case none
    case launchpad
    case spaceport
    case orbitalElevator = "orbital_elevator"
    case massDriver = "mass_driver"
}

struct SpaceState: Codable {
    var launchTier: LaunchTier = .none
    var moonBase: Bool = false
    var helium3Mining: Bool = false
    var lunarShipyard: Bool = false
    var lunarHeritage: Bool = false
    var marsColony: Bool = false
    var marsRenamed: Bool = false
    var atmosphereProcessing: Bool = false
    var waterExtraction: Bool = false
    var asteroidRigs: Int = 0
    var asteroidProspectors: Int = 0
    var asteroidRefineries: Int = 0
    var propagandaSatellites: Int = 0
    var dysonSwarms: Int = 0
    var vonNeumannProbes: Int = 0
    var spaceWeapons: [String: Bool] = [:]
    var bridgeUpgrades: [String: Bool] = [:]
}

// MARK: - Universe (Phase 5)

struct UniverseState: Codable {
    var probeUpgrades: [String: Bool] = [:]
    var probeFactories: Int = 0
    var dysonUpgrades: [String: Bool] = [:]
    var starBrandingUpgrades: [String: Bool] = [:]
    var blackHoleUpgrades: [String: Bool] = [:]
    var blackHoles: Int = 0
    var narrativeResearch: [String: Bool] = [:]
    var universeConverted: Double = 0
    var endingTriggered: Bool = false
    var endingComplete: Bool = false
}

// MARK: - Settings

struct GameSettings: Codable {
    var musicVolume: Double = 0.5
    var sfxVolume: Double = 0.7
    var notificationsEnabled: Bool = true
    var theme: String = "default"
    var adsRemoved: Bool = false
    var timeSkipTokens: Int = 0
}
