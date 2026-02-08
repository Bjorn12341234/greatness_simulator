import type { LaunchTier } from '../../store/types'

// ── Space Weapons ──
// Per GDD: orbital weapons that generate war output and fear at legitimacy cost

export interface SpaceWeaponDef {
  id: string
  name: string
  costCash: number
  warOutput: number
  fear: number
  legitimacyImpact: number
  requiresLaunchTier: LaunchTier
  description: string
}

export const SPACE_WEAPONS: SpaceWeaponDef[] = [
  {
    id: 'orbital_peace_laser',
    name: 'Orbital Peace Laser',
    costCash: 5_000_000,
    warOutput: 2000,
    fear: 50,
    legitimacyImpact: -10,
    requiresLaunchTier: 'spaceport',
    description: 'A laser. For peace. From orbit. Totally defensive.',
  },
  {
    id: 'asteroid_negotiation_device',
    name: 'Asteroid Negotiation Device',
    costCash: 10_000_000,
    warOutput: 3000,
    fear: 100,
    legitimacyImpact: -15,
    requiresLaunchTier: 'orbital_elevator',
    description: 'Redirects asteroids towards "negotiation targets." Very persuasive.',
  },
  {
    id: 'diplomatic_railgun',
    name: 'Diplomatic Railgun',
    costCash: 20_000_000,
    warOutput: 5000,
    fear: 200,
    legitimacyImpact: -20,
    requiresLaunchTier: 'orbital_elevator',
    description: 'Fires diplomacy at Mach 20. Recipients rarely object twice.',
  },
  {
    id: 'solar_shade_array',
    name: 'Solar Shade Array',
    costCash: 50_000_000,
    warOutput: 10000,
    fear: 500,
    legitimacyImpact: -30,
    requiresLaunchTier: 'mass_driver',
    description: 'Can block sunlight to any country. "Climate management tool."',
  },
]

export function getSpaceWeaponDef(id: string): SpaceWeaponDef | undefined {
  return SPACE_WEAPONS.find(w => w.id === id)
}
