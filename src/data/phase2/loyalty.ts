// ── Phase 2: Loyalty Economy ──
// Systems for extracting and spending loyalty

export interface LoyaltyUpgradeDef {
  id: string
  name: string
  icon: string
  description: string
  flavorText: string
  cost: number              // loyalty cost
  cashCost: number          // cash cost
  purchased: boolean
  effects: {
    loyaltyGeneration?: number     // bonus loyalty/sec
    institutionEfficiency?: number // % change to institution output
    surveillanceBonus?: number
    legitimacyImpact?: number     // per second
    realityDriftIncrease?: number // per second
    propagandaMultiplier?: number
  }
}

export const LOYALTY_UPGRADES: LoyaltyUpgradeDef[] = [
  {
    id: 'loyalty_pledges',
    name: 'Loyalty Pledges',
    icon: '✋',
    description: 'Require from all government employees. +Loyalty, -10% efficiency.',
    flavorText: 'I pledge allegiance to Greatness, and to the brand for which it stands.',
    cost: 20,
    cashCost: 10000,
    purchased: false,
    effects: {
      loyaltyGeneration: 0.5,
      institutionEfficiency: -0.10,
    },
  },
  {
    id: 'loyalty_scores',
    name: 'Loyalty Scores',
    icon: '📊',
    description: 'Track citizen compliance. +Surveillance, -15 Legitimacy.',
    flavorText: 'Your Loyalty Score is 847. Please maintain eye contact with the screen.',
    cost: 50,
    cashCost: 50000,
    purchased: false,
    effects: {
      surveillanceBonus: 25,
      legitimacyImpact: -0.005,
    },
  },
  {
    id: 'loyalty_rewards',
    name: 'Loyalty Rewards Program',
    icon: '⭐',
    description: 'Gamify compliance. +Loyalty, Reality Drift +2%.',
    flavorText: 'Earn Great Points for reporting dissent! Redeem for approved merchandise!',
    cost: 80,
    cashCost: 100000,
    purchased: false,
    effects: {
      loyaltyGeneration: 1.0,
      realityDriftIncrease: 0.0003,
      propagandaMultiplier: 0.15,
    },
  },
  {
    id: 'loyalty_hiring',
    name: 'Loyalty-Based Hiring',
    icon: '🎯',
    description: 'All positions require Loyalty Score. Institutions never rebel.',
    flavorText: 'Competence is optional. Compliance is mandatory.',
    cost: 150,
    cashCost: 250000,
    purchased: false,
    effects: {
      loyaltyGeneration: 2.0,
      institutionEfficiency: -0.20,
      legitimacyImpact: -0.003,
    },
  },
]

export function getLoyaltyUpgradeDef(id: string): LoyaltyUpgradeDef | undefined {
  return LOYALTY_UPGRADES.find(u => u.id === id)
}
