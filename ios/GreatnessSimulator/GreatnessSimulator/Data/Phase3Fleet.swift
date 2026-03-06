import Foundation

// MARK: - Ship Class Definition

struct ShipClassDef: Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let flavorText: String
    let costCash: Double
    let warOutput: Double
    let fear: Double
    let nobelImpact: Double
    let special: String?
    let requiresShipyard: Int

    init(
        id: String, name: String, icon: String,
        description: String, flavorText: String,
        costCash: Double, warOutput: Double, fear: Double, nobelImpact: Double,
        special: String? = nil, requiresShipyard: Int
    ) {
        self.id = id; self.name = name; self.icon = icon
        self.description = description; self.flavorText = flavorText
        self.costCash = costCash; self.warOutput = warOutput
        self.fear = fear; self.nobelImpact = nobelImpact
        self.special = special; self.requiresShipyard = requiresShipyard
    }
}

let shipClassDefs: [ShipClassDef] = [
    ShipClassDef(
        id: "patrol_boat", name: "Orange Class Patrol Boat", icon: "sailboat.fill",
        description: "Cheap, spammable. The cockroach of naval warfare.",
        flavorText: "Mass-produced patriotism, one hull at a time.",
        costCash: 10000, warOutput: 5, fear: 2, nobelImpact: -2,
        requiresShipyard: 1
    ),
    ShipClassDef(
        id: "torpedo_barge", name: "Patriot Torpedo Barge", icon: "flame.fill",
        description: "\"Torpedo\" has been rebranded as \"Persuasion Device.\"",
        flavorText: "We don't sink ships. We re-evaluate their buoyancy.",
        costCash: 30000, warOutput: 15, fear: 5, nobelImpact: -5,
        requiresShipyard: 1
    ),
    ShipClassDef(
        id: "destroyer", name: "Orange Class Destroyer", icon: "ferry.fill",
        description: "Standard workhorse. The backbone of the Greatness Navy.",
        flavorText: "Destroyers destroy things. The name was always honest.",
        costCash: 50000, warOutput: 25, fear: 10, nobelImpact: -10,
        requiresShipyard: 2
    ),
    ShipClassDef(
        id: "peace_cruiser", name: "Orange Class \"Peace Cruiser\"", icon: "bird.fill",
        description: "The name gives +5 Nobel Score. The ship is a warship.",
        flavorText: "Peace has never been this well-armed.",
        costCash: 150000, warOutput: 60, fear: 20, nobelImpact: 5,
        special: "Nobel-positive warship. The ultimate doublethink.",
        requiresShipyard: 2
    ),
    ShipClassDef(
        id: "carrier", name: "Orange Class Carrier", icon: "airplane",
        description: "Enables \"Freedom Operations\" at range.",
        flavorText: "A floating airport for democracy delivery.",
        costCash: 200000, warOutput: 100, fear: 30, nobelImpact: -40,
        special: "Unlocks global Freedom Operations.",
        requiresShipyard: 3
    ),
    ShipClassDef(
        id: "golden_dreadnought", name: "Golden Dreadnought", icon: "crown.fill",
        description: "Gold-plated. Devastating. A floating monument to excess.",
        flavorText: "LEAK: The blueprint is literally a gold yacht with cannons.",
        costCash: 500000, warOutput: 250, fear: 80, nobelImpact: -100,
        special: "Massive prestige hit but devastating.",
        requiresShipyard: 3
    ),
    ShipClassDef(
        id: "orbital_platform", name: "Orbital Peace Platform", icon: "antenna.radiowaves.left.and.right",
        description: "Endgame ship. Bridges into Phase 4. Fear made orbital.",
        flavorText: "It's not a weapon. It's a \"stability satellite.\"",
        costCash: 1000000, warOutput: 500, fear: 200, nobelImpact: -200,
        special: "Bridges into Phase 4 space expansion.",
        requiresShipyard: 4
    ),
]

let shipClassRegistry: [String: ShipClassDef] = {
    var map: [String: ShipClassDef] = [:]
    for def in shipClassDefs { map[def.id] = def }
    return map
}()

func shipyardUpgradeCost(currentLevel: Int) -> Double {
    floor(100000 * pow(3.0, Double(currentLevel)))
}
