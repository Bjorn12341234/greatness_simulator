// ── Phase 4 Bridge Upgrades ──
// Contradiction resolution chain: addresses Long-Term vs Short-Term tension

export interface BridgeUpgradeDef {
  id: string
  name: string
  costCash: number
  costLoyalty: number
  prerequisite: string | null
  effect: string
  description: string
}

export const BRIDGE_UPGRADES: BridgeUpgradeDef[] = [
  {
    id: 'long_term_thinking',
    name: 'Long-Term Thinking Simulator',
    costCash: 1_000_000,
    costLoyalty: 0,
    prerequisite: null,
    effect: 'spaceResearchSpeed+50%',
    description: 'An AI that simulates thinking about the future so you don\'t have to.',
  },
  {
    id: 'science_rebranding',
    name: 'Science Rebranding Initiative',
    costCash: 2_000_000,
    costLoyalty: 0,
    prerequisite: 'long_term_thinking',
    effect: 'scienceLegitimacyDrainRemoved',
    description: 'Rename "Science" to "Greatness Research." Problem solved.',
  },
  {
    id: 'reality_budgeting',
    name: 'Reality-Compatible Budgeting',
    costCash: 5_000_000,
    costLoyalty: 0,
    prerequisite: 'science_rebranding',
    effect: 'spaceCostReduction30%',
    description: 'Costs are now calculated in a reality where everything is 30% cheaper.',
  },
  {
    id: 'patience_campaign',
    name: 'Patience Campaign',
    costCash: 3_000_000,
    costLoyalty: 500,
    prerequisite: 'reality_budgeting',
    effect: 'slowProgressDrainRemoved',
    description: '"Good things come to those who wait" — delivered via mandatory seminar.',
  },
]

export function getBridgeUpgradeDef(id: string): BridgeUpgradeDef | undefined {
  return BRIDGE_UPGRADES.find(u => u.id === id)
}
