import Foundation

struct TariffDef {
    let id: String
    let name: String
    let icon: String
    let description: String
    let cashPerMinute: [Double]      // per level [off, low, medium, high]
    let legitimacyDrain: [Double]    // per level
    let productionPenalty: [Double]  // per level
    let resistanceIncrease: Double   // applied to countries in Phase 3
}

let tariffDefs: [TariffDef] = [
    TariffDef(id: "consumer_goods", name: "Consumer Goods", icon: "cart.fill", description: "Everyday items cost more. \"Price Adjustment Initiative.\"", cashPerMinute: [0, 10000, 20000, 35000], legitimacyDrain: [0, -0.005, -0.01, -0.02], productionPenalty: [0, 0, -0.02, -0.05], resistanceIncrease: 0),
    TariffDef(id: "industrial", name: "Industrial Materials", icon: "hammer.fill", description: "Steel, aluminum, components. \"Domestic Production Protection.\"", cashPerMinute: [0, 25000, 50000, 80000], legitimacyDrain: [0, 0, -0.005, -0.015], productionPenalty: [0, -0.03, -0.07, -0.10], resistanceIncrease: 0),
    TariffDef(id: "technology", name: "Technology Imports", icon: "desktopcomputer", description: "Chips, phones, software. \"Tech Independence Mandate.\"", cashPerMinute: [0, 15000, 30000, 50000], legitimacyDrain: [0, 0, -0.005, -0.01], productionPenalty: [0, -0.02, -0.05, -0.10], resistanceIncrease: 0),
    TariffDef(id: "agricultural", name: "Agricultural Products", icon: "leaf.fill", description: "Food imports taxed. \"Food Freedom Initiative.\"", cashPerMinute: [0, 8000, 16000, 28000], legitimacyDrain: [0, -0.008, -0.015, -0.03], productionPenalty: [0, 0, -0.01, -0.03], resistanceIncrease: 0),
    TariffDef(id: "allied_nations", name: "Allied Nations", icon: "hand.raised.fill", description: "Tax your friends. \"Alliance Contribution Fee.\"", cashPerMinute: [0, 30000, 60000, 100000], legitimacyDrain: [0, -0.01, -0.02, -0.04], productionPenalty: [0, -0.02, -0.05, -0.08], resistanceIncrease: 5),
    TariffDef(id: "everyone", name: "Universal Tariff", icon: "globe", description: "Tax everything from everywhere. \"Global Fairness Adjustment.\"", cashPerMinute: [0, 100000, 200000, 350000], legitimacyDrain: [0, -0.03, -0.06, -0.10], productionPenalty: [0, -0.05, -0.10, -0.20], resistanceIncrease: 10),
]

let tariffRegistry: [String: TariffDef] = {
    var dict: [String: TariffDef] = [:]
    for t in tariffDefs { dict[t.id] = t }
    return dict
}()
