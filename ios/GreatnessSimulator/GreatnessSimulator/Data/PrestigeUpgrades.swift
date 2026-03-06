import Foundation

struct PrestigeUpgradeData: Identifiable {
    let id: String
    let name: String
    let description: String
    let cost: Double // prestige points
    let effectType: PrestigeEffectType
    let effectValue: Double
    let prerequisites: [String]
    let icon: String
}

enum PrestigeEffectType: String {
    case clickPower       // multiplies attentionPerClick
    case researchDiscount // reduces upgrade costs
    case legitimacyDecay  // reduces legitimacy decay rate
    case captureSpeed     // faster institution capture
    case resistanceReduction // less country resistance
    case gpsMultiplier    // multiplies base GpS
    case eventCooldown    // reduces event frequency
    case offlineRate      // increases offline earning rate
    case driftCap         // reduces reality drift cap
    case legitimacyFloor  // sets minimum legitimacy
}

let prestigeUpgradeDefs: [PrestigeUpgradeData] = [
    PrestigeUpgradeData(
        id: "muscle_memory",
        name: "Muscle Memory",
        description: "Your fingers remember greatness. 10x click power.",
        cost: 10,
        effectType: .clickPower,
        effectValue: 10,
        prerequisites: [],
        icon: "hand.raised.fill"
    ),
    PrestigeUpgradeData(
        id: "retained_knowledge",
        name: "Retained Knowledge",
        description: "Some knowledge persists between timelines. 25% upgrade discount.",
        cost: 25,
        effectType: .researchDiscount,
        effectValue: 0.75,
        prerequisites: [],
        icon: "brain.head.profile"
    ),
    PrestigeUpgradeData(
        id: "institutional_inertia",
        name: "Institutional Inertia",
        description: "The bureaucracy remembers you. 50% slower legitimacy decay.",
        cost: 50,
        effectType: .legitimacyDecay,
        effectValue: 0.5,
        prerequisites: [],
        icon: "building.columns.fill"
    ),
    PrestigeUpgradeData(
        id: "accelerated_timeline",
        name: "Accelerated Timeline",
        description: "History repeats faster. 30% faster institution capture.",
        cost: 75,
        effectType: .captureSpeed,
        effectValue: 1.3,
        prerequisites: [],
        icon: "clock.arrow.2.circlepath"
    ),
    PrestigeUpgradeData(
        id: "old_alliances",
        name: "Old Alliances",
        description: "They remember bowing. 15% less country resistance.",
        cost: 100,
        effectType: .resistanceReduction,
        effectValue: 0.85,
        prerequisites: [],
        icon: "flag.2.crossed.fill"
    ),
    PrestigeUpgradeData(
        id: "media_dynasty",
        name: "Media Dynasty",
        description: "The narrative writes itself. 2x base GpS.",
        cost: 150,
        effectType: .gpsMultiplier,
        effectValue: 2.0,
        prerequisites: [],
        icon: "tv.fill"
    ),
    PrestigeUpgradeData(
        id: "event_fatigue",
        name: "Event Fatigue",
        description: "Nothing surprises you anymore. 30% less frequent events.",
        cost: 200,
        effectType: .eventCooldown,
        effectValue: 1.3,
        prerequisites: [],
        icon: "newspaper.fill"
    ),
    PrestigeUpgradeData(
        id: "eternal_engine",
        name: "The Eternal Engine",
        description: "Greatness generates even while you sleep. 100% offline rate.",
        cost: 500,
        effectType: .offlineRate,
        effectValue: 1.0,
        prerequisites: ["retained_knowledge"],
        icon: "gear.badge.checkmark"
    ),
    PrestigeUpgradeData(
        id: "ontological_anchor",
        name: "Ontological Anchor",
        description: "Reality bends to your will. 20% drift cap reduction.",
        cost: 1000,
        effectType: .driftCap,
        effectValue: 0.8,
        prerequisites: ["media_dynasty"],
        icon: "anchor.circle.fill"
    ),
    PrestigeUpgradeData(
        id: "recursive_greatness",
        name: "Recursive Greatness",
        description: "Greatness feeding on greatness. 5x base GpS.",
        cost: 2500,
        effectType: .gpsMultiplier,
        effectValue: 5.0,
        prerequisites: ["media_dynasty", "eternal_engine"],
        icon: "infinity"
    ),
    PrestigeUpgradeData(
        id: "manifest_permanence",
        name: "Manifest Permanence",
        description: "Each click echoes through reality. 50x click power.",
        cost: 5000,
        effectType: .clickPower,
        effectValue: 50.0,
        prerequisites: ["muscle_memory", "recursive_greatness"],
        icon: "bolt.fill"
    ),
    PrestigeUpgradeData(
        id: "the_golden_constant",
        name: "The Golden Constant",
        description: "Legitimacy can never fall below 25%.",
        cost: 10000,
        effectType: .legitimacyFloor,
        effectValue: 25.0,
        prerequisites: ["institutional_inertia", "ontological_anchor"],
        icon: "crown.fill"
    ),
]

let prestigeUpgradeRegistry: [String: PrestigeUpgradeData] = {
    var dict: [String: PrestigeUpgradeData] = [:]
    for def in prestigeUpgradeDefs { dict[def.id] = def }
    return dict
}()

// MARK: - Prestige Points Formula

func calculatePrestigePoints(greatnessUnits: Double) -> Int {
    Int(floor(log10(max(1, greatnessUnits))))
}

// MARK: - Prestige Helpers

func prestigeClickPowerMultiplier(upgrades: [String: Bool]) -> Double {
    var mult: Double = 1.0
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .clickPower else { continue }
        mult *= def.effectValue
    }
    return mult
}

func prestigeGPSMultiplier(upgrades: [String: Bool]) -> Double {
    var mult: Double = 1.0
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .gpsMultiplier else { continue }
        mult *= def.effectValue
    }
    return mult
}

func prestigeResearchDiscount(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .researchDiscount else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeLegitimacyDecayMultiplier(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .legitimacyDecay else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeCaptureSpeedMultiplier(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .captureSpeed else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeResistanceMultiplier(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .resistanceReduction else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeEventCooldownMultiplier(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .eventCooldown else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeOfflineRate(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .offlineRate else { continue }
        return def.effectValue
    }
    return 0.1 // default 10%
}

func prestigeDriftCapMultiplier(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .driftCap else { continue }
        return def.effectValue
    }
    return 1.0
}

func prestigeLegitimacyFloor(upgrades: [String: Bool]) -> Double {
    for def in prestigeUpgradeDefs {
        guard upgrades[def.id] == true, def.effectType == .legitimacyFloor else { continue }
        return def.effectValue
    }
    return 0
}
