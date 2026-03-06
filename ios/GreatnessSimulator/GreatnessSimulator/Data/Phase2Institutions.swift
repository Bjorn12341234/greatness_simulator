import Foundation

// MARK: - Institution Definitions

struct InstitutionDef {
    let id: String
    let name: String
    let icon: String
    let description: String
    let resistance: Double
    let corruptionSusceptibility: Double
    let greatnessOutput: Double
    let legitimacyImpact: Double
    let loyaltyGeneration: Double
    let category: String
}

let institutionDefs: [InstitutionDef] = [
    // Media
    InstitutionDef(id: "cable_media", name: "Cable Media", icon: "tv.fill", description: "The 24-hour opinion cycle. Already halfway there.", resistance: 25, corruptionSusceptibility: 0.8, greatnessOutput: 50, legitimacyImpact: -2, loyaltyGeneration: 0.5, category: "media"),
    InstitutionDef(id: "print_media", name: "Print Media", icon: "newspaper.fill", description: "Declining relevance makes them desperate. Perfect.", resistance: 45, corruptionSusceptibility: 0.5, greatnessOutput: 30, legitimacyImpact: -5, loyaltyGeneration: 0.3, category: "media"),
    InstitutionDef(id: "social_platforms", name: "Social Platforms", icon: "iphone.gen3", description: "Algorithms optimized for engagement. Engagement means outrage.", resistance: 20, corruptionSusceptibility: 0.8, greatnessOutput: 80, legitimacyImpact: -3, loyaltyGeneration: 0.8, category: "media"),

    // Judicial
    InstitutionDef(id: "lower_courts", name: "Lower Courts", icon: "scalemass.fill", description: "Justice is blind. We can work with that.", resistance: 50, corruptionSusceptibility: 0.5, greatnessOutput: 20, legitimacyImpact: -8, loyaltyGeneration: 0.2, category: "judicial"),
    InstitutionDef(id: "supreme_court", name: "Supreme Court", icon: "building.columns.fill", description: "Lifetime appointments ensure lasting alignment.", resistance: 75, corruptionSusceptibility: 0.2, greatnessOutput: 100, legitimacyImpact: -15, loyaltyGeneration: 0.5, category: "judicial"),

    // Security
    InstitutionDef(id: "police", name: "Police Forces", icon: "shield.lefthalf.filled", description: "Law and order. Emphasis on order.", resistance: 30, corruptionSusceptibility: 0.5, greatnessOutput: 60, legitimacyImpact: -10, loyaltyGeneration: 1.0, category: "security"),
    InstitutionDef(id: "military", name: "Military", icon: "star.circle.fill", description: "The ultimate guarantor. Handle with strategic flattery.", resistance: 70, corruptionSusceptibility: 0.2, greatnessOutput: 200, legitimacyImpact: -20, loyaltyGeneration: 2.0, category: "security"),
    InstitutionDef(id: "intelligence", name: "Intelligence Services", icon: "eye.fill", description: "They already know everything. Now they report to us.", resistance: 65, corruptionSusceptibility: 0.4, greatnessOutput: 100, legitimacyImpact: -5, loyaltyGeneration: 1.5, category: "security"),

    // Civic
    InstitutionDef(id: "bureaucracy", name: "Federal Bureaucracy", icon: "building.2.fill", description: "Slow, unwieldy, full of loyalists-in-waiting.", resistance: 40, corruptionSusceptibility: 0.7, greatnessOutput: 40, legitimacyImpact: -5, loyaltyGeneration: 0.6, category: "civic"),
    InstitutionDef(id: "education", name: "Education System", icon: "graduationcap.fill", description: "Invest in the youth. Or don't. Either way, capture it.", resistance: 50, corruptionSusceptibility: 0.3, greatnessOutput: 30, legitimacyImpact: -12, loyaltyGeneration: 0.4, category: "civic"),
    InstitutionDef(id: "health_agencies", name: "Health Agencies", icon: "cross.case.fill", description: "Public health is a narrative. Narratives can be optimized.", resistance: 45, corruptionSusceptibility: 0.4, greatnessOutput: 40, legitimacyImpact: -10, loyaltyGeneration: 0.3, category: "civic"),
    InstitutionDef(id: "scientific_agencies", name: "Scientific Agencies", icon: "flask.fill", description: "Facts are just data points. Data points can be curated.", resistance: 70, corruptionSusceptibility: 0.2, greatnessOutput: 50, legitimacyImpact: -15, loyaltyGeneration: 0.2, category: "civic"),

    // Regulatory
    InstitutionDef(id: "finance_regulators", name: "Finance Regulators", icon: "dollarsign.circle.fill", description: "Deregulation is just regulation with better branding.", resistance: 45, corruptionSusceptibility: 0.7, greatnessOutput: 150, legitimacyImpact: -8, loyaltyGeneration: 0.5, category: "regulatory"),
]

let institutionRegistry: [String: InstitutionDef] = {
    var dict: [String: InstitutionDef] = [:]
    for inst in institutionDefs { dict[inst.id] = inst }
    return dict
}()

// MARK: - Institution Actions

struct InstitutionActionDef {
    let type: String
    let name: String
    let description: String
    let duration: Double
    let costCash: Double
    let costLoyalty: Double
    let resistanceReduction: Double
    let legitimacyImpact: Double
    let requiresCaptured: Bool
}

let institutionActions: [InstitutionActionDef] = [
    InstitutionActionDef(type: "co-opt", name: "Co-opt", description: "Place loyalists in key positions. Slow but quiet.", duration: 180, costCash: 5000, costLoyalty: 0, resistanceReduction: 25, legitimacyImpact: -2, requiresCaptured: false),
    InstitutionActionDef(type: "replace", name: "Replace", description: "Swap leadership entirely. Moderately disruptive.", duration: 90, costCash: 15000, costLoyalty: 10, resistanceReduction: 40, legitimacyImpact: -8, requiresCaptured: false),
    InstitutionActionDef(type: "purge", name: "Purge", description: "Remove and replace all staff. Fast but devastating to optics.", duration: 30, costCash: 0, costLoyalty: 25, resistanceReduction: 60, legitimacyImpact: -20, requiresCaptured: false),
    InstitutionActionDef(type: "rebrand", name: "Rebrand", description: "\"Modernization Initiative.\" Restores public trust.", duration: 60, costCash: 30000, costLoyalty: 0, resistanceReduction: 0, legitimacyImpact: 15, requiresCaptured: true),
    InstitutionActionDef(type: "automate", name: "Automate", description: "AI-managed governance. No further management needed.", duration: 120, costCash: 100000, costLoyalty: 0, resistanceReduction: 0, legitimacyImpact: 0, requiresCaptured: true),
    InstitutionActionDef(type: "privatize", name: "Privatize", description: "Sell to highest bidder. Cash now, consequences later.", duration: 45, costCash: 0, costLoyalty: 0, resistanceReduction: 0, legitimacyImpact: -12, requiresCaptured: true),
    InstitutionActionDef(type: "loyalty_test", name: "Loyalty Test", description: "Fire anyone who fails. Survivors are motivated.", duration: 20, costCash: 0, costLoyalty: 5, resistanceReduction: 15, legitimacyImpact: -5, requiresCaptured: false),
]

let actionRegistry: [String: InstitutionActionDef] = {
    var dict: [String: InstitutionActionDef] = [:]
    for a in institutionActions { dict[a.type] = a }
    return dict
}()
