// ── Phase 2: Tariff Definitions ──

export interface TariffDef {
  id: string
  name: string
  icon: string
  description: string
  cashPerMinute: number[]     // per level [0, low, medium, high]
  legitimacyDrain: number[]   // per level
  productionPenalty: number[] // per level (multiplied across all production)
  resistanceIncrease: number  // applied to countries (Phase 3)
}

export const TARIFFS: TariffDef[] = [
  {
    id: 'consumer_goods',
    name: 'Consumer Goods',
    icon: '🛒',
    description: 'Everyday items cost more. "Price Adjustment Initiative."',
    cashPerMinute: [0, 10000, 20000, 35000],
    legitimacyDrain: [0, -0.005, -0.01, -0.02],
    productionPenalty: [0, 0, -0.02, -0.05],
    resistanceIncrease: 0,
  },
  {
    id: 'industrial',
    name: 'Industrial Materials',
    icon: '🏭',
    description: 'Steel, aluminum, components. "Domestic Production Protection."',
    cashPerMinute: [0, 25000, 50000, 80000],
    legitimacyDrain: [0, 0, -0.005, -0.015],
    productionPenalty: [0, -0.03, -0.07, -0.10],
    resistanceIncrease: 0,
  },
  {
    id: 'technology',
    name: 'Technology Imports',
    icon: '💻',
    description: 'Chips, phones, software. "Tech Independence Mandate."',
    cashPerMinute: [0, 15000, 30000, 50000],
    legitimacyDrain: [0, 0, -0.005, -0.01],
    productionPenalty: [0, -0.02, -0.05, -0.10],
    resistanceIncrease: 0,
  },
  {
    id: 'agricultural',
    name: 'Agricultural Products',
    icon: '🌾',
    description: 'Food imports taxed. "Food Freedom Initiative."',
    cashPerMinute: [0, 8000, 16000, 28000],
    legitimacyDrain: [0, -0.008, -0.015, -0.03],
    productionPenalty: [0, 0, -0.01, -0.03],
    resistanceIncrease: 0,
  },
  {
    id: 'allied_nations',
    name: 'Allied Nations',
    icon: '🤝',
    description: 'Tax your friends. "Alliance Contribution Fee."',
    cashPerMinute: [0, 30000, 60000, 100000],
    legitimacyDrain: [0, -0.01, -0.02, -0.04],
    productionPenalty: [0, -0.02, -0.05, -0.08],
    resistanceIncrease: 5,
  },
  {
    id: 'everyone',
    name: 'Universal Tariff',
    icon: '🌍',
    description: 'Tax everything from everywhere. "Global Fairness Adjustment."',
    cashPerMinute: [0, 100000, 200000, 350000],
    legitimacyDrain: [0, -0.03, -0.06, -0.10],
    productionPenalty: [0, -0.05, -0.10, -0.20],
    resistanceIncrease: 10,
  },
]

export function getTariffDef(id: string): TariffDef | undefined {
  return TARIFFS.find(t => t.id === id)
}
