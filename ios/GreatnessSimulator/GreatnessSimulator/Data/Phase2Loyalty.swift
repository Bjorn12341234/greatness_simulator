import Foundation

struct LoyaltyUpgradeDef {
    let id: String
    let name: String
    let icon: String
    let description: String
    let flavorText: String
    let costLoyalty: Double
    let costCash: Double
}

let loyaltyUpgradeDefs: [LoyaltyUpgradeDef] = [
    LoyaltyUpgradeDef(id: "loyalty_pledges", name: "Loyalty Pledges", icon: "hand.raised.fill", description: "Require from all government employees. +Loyalty, -10% efficiency.", flavorText: "I pledge allegiance to Greatness, and to the brand for which it stands.", costLoyalty: 20, costCash: 10000),
    LoyaltyUpgradeDef(id: "loyalty_scores", name: "Loyalty Scores", icon: "chart.bar.fill", description: "Track citizen compliance. +Surveillance, -Legitimacy.", flavorText: "Your Loyalty Score is 847. Please maintain eye contact with the screen.", costLoyalty: 50, costCash: 50000),
    LoyaltyUpgradeDef(id: "loyalty_rewards", name: "Loyalty Rewards Program", icon: "star.fill", description: "Gamify compliance. +Loyalty, Reality Drift +2%.", flavorText: "Earn Great Points for reporting dissent! Redeem for approved merchandise!", costLoyalty: 80, costCash: 100000),
    LoyaltyUpgradeDef(id: "loyalty_hiring", name: "Loyalty-Based Hiring", icon: "target", description: "All positions require Loyalty Score. Institutions never rebel.", flavorText: "Competence is optional. Compliance is mandatory.", costLoyalty: 150, costCash: 250000),
]

let loyaltyUpgradeRegistry: [String: LoyaltyUpgradeDef] = {
    var dict: [String: LoyaltyUpgradeDef] = [:]
    for l in loyaltyUpgradeDefs { dict[l.id] = l }
    return dict
}()
