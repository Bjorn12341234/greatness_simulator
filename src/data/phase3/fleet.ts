// ── Phase 3: Orange Class Fleet ──
// 7 ship classes + shipyard system

export interface ShipClassDef {
  id: string
  name: string
  icon: string
  description: string
  flavorText: string
  costCash: number
  warOutput: number
  fear: number
  nobelImpact: number
  special?: string
  requiresShipyard: number  // minimum shipyard level to unlock
}

export const SHIP_CLASSES: ShipClassDef[] = [
  {
    id: 'patrol_boat',
    name: 'Orange Class Patrol Boat',
    icon: '🚤',
    description: 'Cheap, spammable. The cockroach of naval warfare.',
    flavorText: 'Mass-produced patriotism, one hull at a time.',
    costCash: 10000,
    warOutput: 5,
    fear: 2,
    nobelImpact: -2,
    requiresShipyard: 1,
  },
  {
    id: 'torpedo_barge',
    name: 'Patriot Torpedo Barge',
    icon: '💣',
    description: '"Torpedo" has been rebranded as "Persuasion Device."',
    flavorText: 'We don\'t sink ships. We re-evaluate their buoyancy.',
    costCash: 30000,
    warOutput: 15,
    fear: 5,
    nobelImpact: -5,
    requiresShipyard: 1,
  },
  {
    id: 'destroyer',
    name: 'Orange Class Destroyer',
    icon: '🚢',
    description: 'Standard workhorse. The backbone of the Greatness Navy.',
    flavorText: 'Destroyers destroy things. The name was always honest.',
    costCash: 50000,
    warOutput: 25,
    fear: 10,
    nobelImpact: -10,
    requiresShipyard: 2,
  },
  {
    id: 'peace_cruiser',
    name: 'Orange Class "Peace Cruiser"',
    icon: '🕊️',
    description: 'The name gives +5 Nobel Score. The ship is a warship.',
    flavorText: 'Peace has never been this well-armed.',
    costCash: 150000,
    warOutput: 60,
    fear: 20,
    nobelImpact: 5,
    special: 'Nobel-positive warship. The ultimate doublethink.',
    requiresShipyard: 2,
  },
  {
    id: 'carrier',
    name: 'Orange Class Carrier',
    icon: '✈️',
    description: 'Enables "Freedom Operations" at range.',
    flavorText: 'A floating airport for democracy delivery.',
    costCash: 200000,
    warOutput: 100,
    fear: 30,
    nobelImpact: -40,
    special: 'Unlocks global Freedom Operations.',
    requiresShipyard: 3,
  },
  {
    id: 'golden_dreadnought',
    name: 'Golden Dreadnought',
    icon: '👑',
    description: 'Gold-plated. Devastating. A floating monument to excess.',
    flavorText: 'LEAK: The blueprint is literally a gold yacht with cannons.',
    costCash: 500000,
    warOutput: 250,
    fear: 80,
    nobelImpact: -100,
    special: 'Massive prestige hit but devastating.',
    requiresShipyard: 3,
  },
  {
    id: 'orbital_platform',
    name: 'Orbital Peace Platform',
    icon: '🛸',
    description: 'Endgame ship. Bridges into Phase 4. Fear made orbital.',
    flavorText: 'It\'s not a weapon. It\'s a "stability satellite."',
    costCash: 1000000,
    warOutput: 500,
    fear: 200,
    nobelImpact: -200,
    special: 'Bridges into Phase 4 space expansion.',
    requiresShipyard: 4,
  },
]

export function getShipClassDef(id: string): ShipClassDef | undefined {
  return SHIP_CLASSES.find(s => s.id === id)
}

// Shipyard costs scale with level
export function getShipyardCost(currentLevel: number): number {
  return Math.floor(100000 * Math.pow(3, currentLevel))
}

// Ships built per cycle (10 seconds) per shipyard level
export function getProductionRate(shipyardLevel: number): number {
  return shipyardLevel
}
