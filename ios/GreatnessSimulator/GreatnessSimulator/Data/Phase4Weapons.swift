import Foundation

struct SpaceWeaponDef {
    let id: String
    let name: String
    let costCash: Double
    let warOutput: Double
    let fear: Double
    let legitimacyImpact: Double
    let requiresLaunchTier: LaunchTier
    let description: String
}

let spaceWeaponDefs: [SpaceWeaponDef] = [
    SpaceWeaponDef(
        id: "orbital_peace_laser",
        name: "Orbital Peace Laser",
        costCash: 5_000_000,
        warOutput: 2000,
        fear: 50,
        legitimacyImpact: -10,
        requiresLaunchTier: .spaceport,
        description: "A laser. For peace. From orbit. Totally defensive."
    ),
    SpaceWeaponDef(
        id: "asteroid_negotiation_device",
        name: "Asteroid Negotiation Device",
        costCash: 10_000_000,
        warOutput: 3000,
        fear: 100,
        legitimacyImpact: -15,
        requiresLaunchTier: .orbitalElevator,
        description: "Redirects asteroids towards \"negotiation targets.\" Very persuasive."
    ),
    SpaceWeaponDef(
        id: "diplomatic_railgun",
        name: "Diplomatic Railgun",
        costCash: 20_000_000,
        warOutput: 5000,
        fear: 200,
        legitimacyImpact: -20,
        requiresLaunchTier: .orbitalElevator,
        description: "Fires diplomacy at Mach 20. Recipients rarely object twice."
    ),
    SpaceWeaponDef(
        id: "solar_shade_array",
        name: "Solar Shade Array",
        costCash: 50_000_000,
        warOutput: 10000,
        fear: 500,
        legitimacyImpact: -30,
        requiresLaunchTier: .massDriver,
        description: "Can block sunlight to any country. \"Climate management tool.\""
    ),
]

let spaceWeaponRegistry: [String: SpaceWeaponDef] = {
    var dict: [String: SpaceWeaponDef] = [:]
    for def in spaceWeaponDefs { dict[def.id] = def }
    return dict
}()
