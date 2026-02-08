// ── Phase 2: Data Center Upgrades ──
// The GPU/TPU empire — surveillance tools in Silicon Valley packaging

export interface DataCenterUpgradeDef {
  id: string
  name: string
  icon: string
  description: string
  flavorText: string
  cost: number                 // cash
  prerequisite?: string        // previous upgrade ID
  effects: {
    attentionMultiplier?: number
    surveillanceBonus?: number
    propagandaMultiplier?: number
    legitimacyRecoveryBonus?: number
    nobelScorePassive?: number
    institutionEfficiency?: number
    unrestReduction?: number
    realityDriftDelay?: number
  }
}

export const DATA_CENTER_UPGRADES: DataCenterUpgradeDef[] = [
  {
    id: 'dc_surveillance',
    name: 'Surveillance Array',
    icon: '📡',
    description: '+10% Propaganda effectiveness',
    flavorText: 'Keeping citizens safe from misinformation',
    cost: 50000,
    effects: {
      propagandaMultiplier: 0.10,
      surveillanceBonus: 10,
    },
  },
  {
    id: 'dc_predictive',
    name: 'Predictive Loyalty Engine',
    icon: '🧠',
    description: 'Institutions resist uncapture',
    flavorText: 'AI-powered patriotism detection',
    cost: 200000,
    prerequisite: 'dc_surveillance',
    effects: {
      institutionEfficiency: 0.15,
      surveillanceBonus: 20,
    },
  },
  {
    id: 'dc_content',
    name: 'Content Optimization Farm',
    icon: '📺',
    description: '+50% Attention generation',
    flavorText: 'Telling people what they want to hear, at scale',
    cost: 500000,
    prerequisite: 'dc_predictive',
    effects: {
      attentionMultiplier: 0.50,
    },
  },
  {
    id: 'dc_deepfake',
    name: 'Deepfake Diplomacy Suite',
    icon: '🤝',
    description: '+30 Nobel Score passive',
    flavorText: 'Historic handshakes, generated on demand',
    cost: 1000000,
    prerequisite: 'dc_content',
    effects: {
      nobelScorePassive: 0.5, // per second
    },
  },
  {
    id: 'dc_autonomous',
    name: 'Autonomous Governance AI',
    icon: '🤖',
    description: 'Institutions auto-manage, -50% budget needed',
    flavorText: 'Government, but efficient',
    cost: 5000000,
    prerequisite: 'dc_deepfake',
    effects: {
      institutionEfficiency: 0.50,
    },
  },
  {
    id: 'dc_reality',
    name: 'Reality Processing Cluster',
    icon: '⚡',
    description: 'Reality Drift effects delayed by 20%',
    flavorText: 'If we compute hard enough, the truth becomes optional',
    cost: 10000000,
    prerequisite: 'dc_autonomous',
    effects: {
      realityDriftDelay: 0.20,
    },
  },
  {
    id: 'dc_neural',
    name: 'Neural Compliance Network',
    icon: '🔮',
    description: 'Public unrest permanently reduced by 50%',
    flavorText: 'Citizens report 98% satisfaction. The other 2% are being recalibrated.',
    cost: 50000000,
    prerequisite: 'dc_reality',
    effects: {
      unrestReduction: 0.50,
      legitimacyRecoveryBonus: 0.05,
    },
  },
]

export function getDataCenterDef(id: string): DataCenterUpgradeDef | undefined {
  return DATA_CENTER_UPGRADES.find(d => d.id === id)
}
