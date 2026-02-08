// ── Phase 3: Country Definitions ──
// 14 countries to bring under the Greatness Accord
// + Azure State special entity (the "ally" with leverage)

export interface CountryDef {
  id: string
  name: string
  icon: string
  region: string
  description: string
  startingResistance: number    // 0-100
  startingStability: number     // 0-100
  gdp: 'low' | 'medium' | 'high' | 'very_high'
  defense: 'low' | 'medium' | 'high' | 'very_high'
  corruption: 'low' | 'medium' | 'high'
  mediaHardness: 'low' | 'medium' | 'high' | 'very_high'
  greatnessPotential: number    // GpS when annexed
  nobelOptics: number           // Nobel Score impact when annexed (positive = good optics)
  specialMechanic?: string      // unique mechanic ID
  specialDescription?: string
}

export const COUNTRIES: CountryDef[] = [
  // ── Western Allies ──
  {
    id: 'nordland',
    name: 'Nordland',
    icon: '🇳🇴',
    region: 'Northern Europe',
    description: 'Wealthy, stable, annoyingly principled. Rich in oil and smugness.',
    startingResistance: 70,
    startingStability: 90,
    gdp: 'high',
    defense: 'high',
    corruption: 'low',
    mediaHardness: 'high',
    greatnessPotential: 150,
    nobelOptics: 20,
  },
  {
    id: 'eurovia',
    name: 'Eurovia',
    icon: '🇪🇺',
    region: 'Western Europe',
    description: 'A union of bickering nations. Destabilize one, destabilize all.',
    startingResistance: 60,
    startingStability: 65,
    gdp: 'high',
    defense: 'medium',
    corruption: 'medium',
    mediaHardness: 'high',
    greatnessPotential: 300,
    nobelOptics: 0,
    specialMechanic: 'refugee_target',
    specialDescription: 'Refugee waves from wars reduce stability and resistance.',
  },
  {
    id: 'old_kingdom',
    name: 'Old Kingdom',
    icon: '🇬🇧',
    region: 'Atlantic',
    description: 'Former empire. Still acts like one. Susceptible to nostalgia-based branding.',
    startingResistance: 55,
    startingStability: 70,
    gdp: 'high',
    defense: 'high',
    corruption: 'medium',
    mediaHardness: 'high',
    greatnessPotential: 200,
    nobelOptics: 10,
  },

  // ── Americas ──
  {
    id: 'maple_federation',
    name: 'Maple Federation',
    icon: '🍁',
    region: 'North America',
    description: 'Friendly neighbor. Too polite to refuse. Economic pressure works wonders.',
    startingResistance: 40,
    startingStability: 85,
    gdp: 'high',
    defense: 'medium',
    corruption: 'low',
    mediaHardness: 'high',
    greatnessPotential: 250,
    nobelOptics: 15,
    specialMechanic: 'trade_dependency',
    specialDescription: 'Can be absorbed through economic integration instead of force.',
  },
  {
    id: 'raincoast_union',
    name: 'Raincoast Union',
    icon: '🌴',
    region: 'Central America',
    description: 'Small, peaceful, idealistic. Perfect for "partnership agreements."',
    startingResistance: 35,
    startingStability: 75,
    gdp: 'medium',
    defense: 'low',
    corruption: 'low',
    mediaHardness: 'medium',
    greatnessPotential: 80,
    nobelOptics: 15,
  },
  {
    id: 'petro_republic',
    name: 'Petro Republic',
    icon: '🛢️',
    region: 'South America',
    description: 'Oil-rich. "Unfriendly" government. El Comandante is... problematic.',
    startingResistance: 65,
    startingStability: 40,
    gdp: 'medium',
    defense: 'medium',
    corruption: 'high',
    mediaHardness: 'low',
    greatnessPotential: 350,
    nobelOptics: -20,
    specialMechanic: 'regime_change',
    specialDescription: 'Sanctions → instability → coup → extract oil. Also: "Extraordinary Rendition" available.',
  },
  {
    id: 'canal_isthmus',
    name: 'Canal Isthmus',
    icon: '🚢',
    region: 'Central America',
    description: 'Tiny nation, vital waterway. Shipping leverage is everything.',
    startingResistance: 30,
    startingStability: 50,
    gdp: 'low',
    defense: 'low',
    corruption: 'high',
    mediaHardness: 'low',
    greatnessPotential: 200,
    nobelOptics: -10,
    specialMechanic: 'canal_leverage',
    specialDescription: 'Control the canal = +15% global Cash. Threaten tariffs for instant compliance.',
  },

  // ── Middle East / Africa ──
  {
    id: 'sand_republic',
    name: 'Sand Republic',
    icon: '🏜️',
    region: 'Middle East',
    description: 'Oil, instability, and a media that can\'t report what it can\'t see.',
    startingResistance: 35,
    startingStability: 35,
    gdp: 'medium',
    defense: 'low',
    corruption: 'high',
    mediaHardness: 'low',
    greatnessPotential: 300,
    nobelOptics: -30,
    specialMechanic: 'refugee_source',
    specialDescription: 'Wars here create refugee waves that destabilize Eurovia and Nordland.',
  },
  {
    id: 'copper_states',
    name: 'Copper States',
    icon: '⛏️',
    region: 'Sub-Saharan Africa',
    description: 'Rich in minerals. Poor in everything else. Ripe for "development partnerships."',
    startingResistance: 25,
    startingStability: 30,
    gdp: 'low',
    defense: 'low',
    corruption: 'high',
    mediaHardness: 'low',
    greatnessPotential: 250,
    nobelOptics: -20,
    specialMechanic: 'refugee_source',
    specialDescription: 'Resource extraction deals. Wars create refugee waves.',
  },

  // ── Asia-Pacific ──
  {
    id: 'jade_empire',
    name: 'Jade Empire',
    icon: '🐉',
    region: 'East Asia',
    description: 'The final boss. Massive GDP, iron media control, nuclear deterrent.',
    startingResistance: 95,
    startingStability: 85,
    gdp: 'very_high',
    defense: 'very_high',
    corruption: 'low',
    mediaHardness: 'very_high',
    greatnessPotential: 500,
    nobelOptics: 0,
  },
  {
    id: 'sun_federation',
    name: 'Sun Federation',
    icon: '☀️',
    region: 'South Asia',
    description: 'Billion people, nuclear power, but corruption opens doors.',
    startingResistance: 50,
    startingStability: 55,
    gdp: 'medium',
    defense: 'medium',
    corruption: 'medium',
    mediaHardness: 'medium',
    greatnessPotential: 200,
    nobelOptics: 0,
  },
  {
    id: 'island_bloc',
    name: 'Island Bloc',
    icon: '🏝️',
    region: 'Pacific',
    description: 'Small islands, big strategic value. Climate change is doing half the work.',
    startingResistance: 20,
    startingStability: 70,
    gdp: 'low',
    defense: 'low',
    corruption: 'low',
    mediaHardness: 'medium',
    greatnessPotential: 50,
    nobelOptics: 15,
  },

  // ── Special Countries ──
  {
    id: 'tundra_republic',
    name: 'Tundra Republic',
    icon: '🐻',
    region: 'Eurasia',
    description: '"Our greatest ally." A partnership built on mutual blackmail and photo ops.',
    startingResistance: 80,
    startingStability: 70,
    gdp: 'high',
    defense: 'high',
    corruption: 'medium',
    mediaHardness: 'low',
    greatnessPotential: 400,
    nobelOptics: -30,
    specialMechanic: 'encirclement',
    specialDescription: 'Fake alliance. Build bases around them. When encirclement hits 100%, they fold.',
  },
  {
    id: 'frostheim',
    name: 'Frostheim',
    icon: '🧊',
    region: 'Arctic',
    description: 'Strategic, mineral-rich, and apparently for sale. Just keep offering.',
    startingResistance: 50,
    startingStability: 80,
    gdp: 'low',
    defense: 'low',
    corruption: 'low',
    mediaHardness: 'low',
    greatnessPotential: 400,
    nobelOptics: 10,
    specialMechanic: 'purchase_offer',
    specialDescription: 'Can be acquired by making escalating cash offers. The world watches in disbelief.',
  },
]

// ── Azure State — The "Ally" with Leverage ──
// Not one of the 14 to conquer — a special entity with unique mechanics

export interface AzureStateDef {
  name: string
  icon: string
  description: string
  kompromatlevel: number        // 0-100: how much leverage they have
  loyaltyToMaster: number      // 0-100: how obedient you are
  aidPerSecond: number          // cash you send them per second
  intelligenceShared: number    // surveillance bonus they provide
  specialOps: string[]          // available operations through their network
}

export const AZURE_STATE: AzureStateDef = {
  name: 'Azure State',
  icon: '🔷',
  description: 'The special relationship. They have files from Eddstein\'s Isle. You have the military. It\'s complicated.',
  kompromatlevel: 80,
  loyaltyToMaster: 60,
  aidPerSecond: 100,
  intelligenceShared: 30,
  specialOps: ['extraordinary_rendition', 'cultural_destabilization', 'regime_change_assist'],
}

// ── Tactic Definitions ──

export type TacticType =
  | 'partnership' | 'trade_leverage' | 'media_infiltration'
  | 'coup_sponsorship' | 'freedom_operation' | 'annexation'
  | 'greatness_referendum' | 'post_war_rebuilding'
  | 'tariff_warfare' | 'social_media_destabilization'
  | 'aid_dependency' | 'election_support' | 'resource_extraction'
  | 'immigration_weaponization'
  // Special tactics
  | 'purchase_offer' | 'trade_integration' | 'cultural_assimilation' | 'absorption_referendum'
  | 'joint_defense' | 'energy_partnership' | 'intelligence_sharing'
  | 'sanctions_campaign' | 'democracy_fund' | 'humanitarian_corridor'
  | 'extraordinary_rendition' | 'freedom_foundation'
  // Azure State tactics
  | 'kompromat_resist' | 'aid_reduction' | 'leverage_reversal' | 'full_absorption'

export interface TacticDef {
  type: TacticType
  name: string
  description: string
  flavorText: string
  duration: number           // seconds
  costCash: number
  costLoyalty: number
  costWarOutput: number
  resistanceReduction: number
  stabilityImpact: number
  legitimacyImpact: number
  nobelImpact: number
  fearGenerated: number
  availableFor?: string[]    // specific country IDs, or undefined = all
  requiresPhase?: number
}

export const TACTICS: TacticDef[] = [
  // ── Standard Tactics ──
  {
    type: 'partnership',
    name: 'Partnership Offer',
    description: 'Diplomatic approach. Slow but maintains appearances.',
    flavorText: 'A handshake is just a leash with better PR.',
    duration: 300,
    costCash: 10000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 5,
    stabilityImpact: 0,
    legitimacyImpact: 5,
    nobelImpact: 20,
    fearGenerated: 0,
  },
  {
    type: 'trade_leverage',
    name: 'Trade Leverage',
    description: 'Economic pressure. Their GDP becomes your lever.',
    flavorText: 'Free trade means they\'re free to comply.',
    duration: 180,
    costCash: 20000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 10,
    stabilityImpact: -5,
    legitimacyImpact: -2,
    nobelImpact: -5,
    fearGenerated: 5,
  },
  {
    type: 'media_infiltration',
    name: 'Media Infiltration',
    description: 'Buy their media. Rewrite their narrative.',
    flavorText: 'Freedom of the press: freedom to press our agenda.',
    duration: 120,
    costCash: 50000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 15,
    stabilityImpact: -10,
    legitimacyImpact: -5,
    nobelImpact: -10,
    fearGenerated: 0,
  },
  {
    type: 'freedom_foundation',
    name: 'Freedom Foundation',
    description: 'Deploy NGOs to "promote democracy." Actually: cultural erosion.',
    flavorText: 'We taught them to hate themselves. Then we offered to help.',
    duration: 240,
    costCash: 80000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 20,
    stabilityImpact: -15,
    legitimacyImpact: 3,
    nobelImpact: 10,
    fearGenerated: 0,
  },
  {
    type: 'coup_sponsorship',
    name: 'Coup Sponsorship',
    description: 'Fund the opposition. Install "Greatness-aligned" leadership.',
    flavorText: 'Democracy: the freedom to choose the leader we picked.',
    duration: 60,
    costCash: 150000,
    costLoyalty: 20,
    costWarOutput: 0,
    resistanceReduction: 30,
    stabilityImpact: -30,
    legitimacyImpact: -15,
    nobelImpact: -50,
    fearGenerated: 10,
  },
  {
    type: 'freedom_operation',
    name: '"Freedom Operation"',
    description: 'Full military intervention. Fast, loud, expensive.',
    flavorText: 'We\'re not invading. We\'re liberating. There\'s a PowerPoint.',
    duration: 30,
    costCash: 500000,
    costLoyalty: 0,
    costWarOutput: 50,
    resistanceReduction: 50,
    stabilityImpact: -50,
    legitimacyImpact: -25,
    nobelImpact: -100,
    fearGenerated: 30,
  },
  {
    type: 'extraordinary_rendition',
    name: 'Extraordinary Rendition',
    description: 'Kidnap their leader. Rebrand as "extraction of hostile actor."',
    flavorText: 'El Comandante is taking an involuntary sabbatical.',
    duration: 15,
    costCash: 200000,
    costLoyalty: 30,
    costWarOutput: 20,
    resistanceReduction: 40,
    stabilityImpact: -40,
    legitimacyImpact: -30,
    nobelImpact: -80,
    fearGenerated: 50,
    availableFor: ['petro_republic', 'sand_republic', 'copper_states'],
  },
  {
    type: 'annexation',
    name: 'Formal Annexation',
    description: 'Once resistance is zero, absorb them into the Greatness Accord.',
    flavorText: 'Welcome to the family. Compliance is mandatory.',
    duration: 10,
    costCash: 0,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 0,
    stabilityImpact: 0,
    legitimacyImpact: -30,
    nobelImpact: -150,
    fearGenerated: 0,
  },
  {
    type: 'post_war_rebuilding',
    name: 'Post-War Rebuilding',
    description: 'Fix what you broke. Great Nobel optics.',
    flavorText: 'We destroyed it, we rebuilt it, we own it. Three revenue streams.',
    duration: 180,
    costCash: 200000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 0,
    stabilityImpact: 20,
    legitimacyImpact: 20,
    nobelImpact: 100,
    fearGenerated: -10,
  },
  {
    type: 'immigration_weaponization',
    name: 'Immigration Weaponization',
    description: 'Start wars → create refugees → blame the destination.',
    flavorText: 'They\'re losing their identity. We should help. With conditions.',
    duration: 120,
    costCash: 30000,
    costLoyalty: 0,
    costWarOutput: 10,
    resistanceReduction: 0,
    stabilityImpact: -20,
    legitimacyImpact: -5,
    nobelImpact: -15,
    fearGenerated: 5,
    availableFor: ['eurovia', 'nordland'],
  },

  // ── Frostheim Special ──
  {
    type: 'purchase_offer',
    name: 'Purchase Offer',
    description: 'Offer to buy the entire country. The world is baffled.',
    flavorText: 'Everything has a price. Even sovereignty.',
    duration: 5,
    costCash: 1000000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 15,
    stabilityImpact: 0,
    legitimacyImpact: -5,
    nobelImpact: 0,
    fearGenerated: 0,
    availableFor: ['frostheim'],
  },

  // ── Maple Federation Special ──
  {
    type: 'trade_integration',
    name: 'Trade Integration',
    description: 'Lock them into economic dependency. They won\'t even notice.',
    flavorText: 'Shared infrastructure, shared currency, shared sovereignty (ours).',
    duration: 180,
    costCash: 100000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 10,
    stabilityImpact: 0,
    legitimacyImpact: 2,
    nobelImpact: 5,
    fearGenerated: 0,
    availableFor: ['maple_federation'],
  },
  {
    type: 'absorption_referendum',
    name: 'Absorption Referendum',
    description: '"Voluntary" merger. They "chose" this. +30 Legitimacy.',
    flavorText: 'Democracy in action. The ballot had one option.',
    duration: 60,
    costCash: 200000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 100,
    stabilityImpact: 0,
    legitimacyImpact: 30,
    nobelImpact: 30,
    fearGenerated: 0,
    availableFor: ['maple_federation'],
  },

  // ── Tundra Republic Special ──
  {
    type: 'joint_defense',
    name: 'Joint Defense Agreement',
    description: 'Place bases around their borders. For "mutual protection."',
    flavorText: 'The noose tightens. They call it friendship.',
    duration: 120,
    costCash: 80000,
    costLoyalty: 0,
    costWarOutput: 10,
    resistanceReduction: 5,
    stabilityImpact: 0,
    legitimacyImpact: 5,
    nobelImpact: 0,
    fearGenerated: 0,
    availableFor: ['tundra_republic'],
  },

  // ── Petro Republic Special ──
  {
    type: 'sanctions_campaign',
    name: 'Sanctions Campaign',
    description: 'Crash their economy. Blame their government.',
    flavorText: 'Economic warfare is not war. It\'s just... economics.',
    duration: 120,
    costCash: 30000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 10,
    stabilityImpact: -20,
    legitimacyImpact: -3,
    nobelImpact: -5,
    fearGenerated: 5,
    availableFor: ['petro_republic', 'tundra_republic', 'jade_empire'],
  },
  {
    type: 'democracy_fund',
    name: '"Democracy Assistance Fund"',
    description: 'Sponsor the opposition. If they win, they owe you.',
    flavorText: 'Regime change, but make it look like a TED talk.',
    duration: 180,
    costCash: 100000,
    costLoyalty: 0,
    costWarOutput: 0,
    resistanceReduction: 15,
    stabilityImpact: -15,
    legitimacyImpact: -5,
    nobelImpact: 10,
    fearGenerated: 0,
    availableFor: ['petro_republic', 'sand_republic'],
  },

  // ── Azure State Tactics ──
  {
    type: 'kompromat_resist',
    name: 'Resist the Leverage',
    description: 'Push back against Azure State demands. Risky.',
    flavorText: 'They have the photos. But you have the nukes.',
    duration: 60,
    costCash: 500000,
    costLoyalty: 50,
    costWarOutput: 0,
    resistanceReduction: 0,
    stabilityImpact: 0,
    legitimacyImpact: -10,
    nobelImpact: 0,
    fearGenerated: 0,
    availableFor: ['azure_state'],
  },
  {
    type: 'aid_reduction',
    name: 'Reduce Aid Package',
    description: 'Cut their funding. Watch them panic.',
    flavorText: 'The special relationship has a new price.',
    duration: 30,
    costCash: 0,
    costLoyalty: 30,
    costWarOutput: 0,
    resistanceReduction: 0,
    stabilityImpact: -10,
    legitimacyImpact: -15,
    nobelImpact: -10,
    fearGenerated: 10,
    availableFor: ['azure_state'],
  },
  {
    type: 'leverage_reversal',
    name: 'Leverage Reversal',
    description: 'You\'ve been gathering intel too. Time to use it.',
    flavorText: 'Turns out we have files too. From that island. And others.',
    duration: 120,
    costCash: 2000000,
    costLoyalty: 100,
    costWarOutput: 20,
    resistanceReduction: 0,
    stabilityImpact: 0,
    legitimacyImpact: -20,
    nobelImpact: -30,
    fearGenerated: 30,
    availableFor: ['azure_state'],
  },
  {
    type: 'full_absorption',
    name: '"Unity Accord"',
    description: 'The final move. They become a state. You become... everything.',
    flavorText: 'Two nations, one flag. Guess whose flag.',
    duration: 300,
    costCash: 5000000,
    costLoyalty: 200,
    costWarOutput: 50,
    resistanceReduction: 100,
    stabilityImpact: -30,
    legitimacyImpact: -40,
    nobelImpact: -200,
    fearGenerated: 50,
    availableFor: ['azure_state'],
  },
]

export function getTacticDef(type: TacticType): TacticDef | undefined {
  return TACTICS.find(t => t.type === type)
}

export function getTacticsForCountry(countryId: string): TacticDef[] {
  return TACTICS.filter(t => !t.availableFor || t.availableFor.includes(countryId))
}

export function getCountryDef(id: string): CountryDef | undefined {
  return COUNTRIES.find(c => c.id === id)
}
