// ── Phase 2: Institution Definitions ──
// 13 institutions to capture for the Greatness State

export interface InstitutionDef {
  id: string
  name: string
  icon: string
  description: string
  resistance: number          // starting resistance 0-100
  corruptionSusceptibility: number  // 0-1, how easy to bribe
  greatnessOutput: number     // GpS when captured
  legitimacyImpact: number    // legitimacy hit on capture (negative)
  loyaltyGeneration: number   // loyalty/sec when captured
  category: 'media' | 'judicial' | 'security' | 'civic' | 'regulatory'
}

export const INSTITUTIONS: InstitutionDef[] = [
  // ── Media ──
  {
    id: 'cable_media',
    name: 'Cable Media',
    icon: '📺',
    description: 'The 24-hour opinion cycle. Already halfway there.',
    resistance: 25,
    corruptionSusceptibility: 0.8,
    greatnessOutput: 50,
    legitimacyImpact: -2,
    loyaltyGeneration: 0.5,
    category: 'media',
  },
  {
    id: 'print_media',
    name: 'Print Media',
    icon: '📰',
    description: 'Declining relevance makes them desperate. Perfect.',
    resistance: 45,
    corruptionSusceptibility: 0.5,
    greatnessOutput: 30,
    legitimacyImpact: -5,
    loyaltyGeneration: 0.3,
    category: 'media',
  },
  {
    id: 'social_platforms',
    name: 'Social Platforms',
    icon: '📱',
    description: 'Algorithms optimized for engagement. Engagement means outrage.',
    resistance: 20,
    corruptionSusceptibility: 0.8,
    greatnessOutput: 80,
    legitimacyImpact: -3,
    loyaltyGeneration: 0.8,
    category: 'media',
  },

  // ── Judicial ──
  {
    id: 'lower_courts',
    name: 'Lower Courts',
    icon: '⚖️',
    description: 'Justice is blind. We can work with that.',
    resistance: 50,
    corruptionSusceptibility: 0.5,
    greatnessOutput: 20,
    legitimacyImpact: -8,
    loyaltyGeneration: 0.2,
    category: 'judicial',
  },
  {
    id: 'supreme_court',
    name: 'Supreme Court',
    icon: '🏛️',
    description: 'Lifetime appointments ensure lasting alignment.',
    resistance: 75,
    corruptionSusceptibility: 0.2,
    greatnessOutput: 100,
    legitimacyImpact: -15,
    loyaltyGeneration: 0.5,
    category: 'judicial',
  },

  // ── Security ──
  {
    id: 'police',
    name: 'Police Forces',
    icon: '🚔',
    description: 'Law and order. Emphasis on order.',
    resistance: 30,
    corruptionSusceptibility: 0.5,
    greatnessOutput: 60,
    legitimacyImpact: -10,
    loyaltyGeneration: 1.0,
    category: 'security',
  },
  {
    id: 'military',
    name: 'Military',
    icon: '🎖️',
    description: 'The ultimate guarantor. Handle with strategic flattery.',
    resistance: 70,
    corruptionSusceptibility: 0.2,
    greatnessOutput: 200,
    legitimacyImpact: -20,
    loyaltyGeneration: 2.0,
    category: 'security',
  },
  {
    id: 'intelligence',
    name: 'Intelligence Services',
    icon: '🕵️',
    description: 'They already know everything. Now they report to us.',
    resistance: 65,
    corruptionSusceptibility: 0.4,
    greatnessOutput: 100,
    legitimacyImpact: -5,
    loyaltyGeneration: 1.5,
    category: 'security',
  },

  // ── Civic ──
  {
    id: 'bureaucracy',
    name: 'Federal Bureaucracy',
    icon: '🏢',
    description: 'Slow, unwieldy, full of loyalists-in-waiting.',
    resistance: 40,
    corruptionSusceptibility: 0.7,
    greatnessOutput: 40,
    legitimacyImpact: -5,
    loyaltyGeneration: 0.6,
    category: 'civic',
  },
  {
    id: 'education',
    name: 'Education System',
    icon: '🎓',
    description: 'Invest in the youth. Or don\'t. Either way, capture it.',
    resistance: 50,
    corruptionSusceptibility: 0.3,
    greatnessOutput: 30,
    legitimacyImpact: -12,
    loyaltyGeneration: 0.4,
    category: 'civic',
  },
  {
    id: 'health_agencies',
    name: 'Health Agencies',
    icon: '🏥',
    description: 'Public health is a narrative. Narratives can be optimized.',
    resistance: 45,
    corruptionSusceptibility: 0.4,
    greatnessOutput: 40,
    legitimacyImpact: -10,
    loyaltyGeneration: 0.3,
    category: 'civic',
  },
  {
    id: 'scientific_agencies',
    name: 'Scientific Agencies',
    icon: '🔬',
    description: 'Facts are just data points. Data points can be curated.',
    resistance: 70,
    corruptionSusceptibility: 0.2,
    greatnessOutput: 50,
    legitimacyImpact: -15,
    loyaltyGeneration: 0.2,
    category: 'civic',
  },

  // ── Regulatory ──
  {
    id: 'finance_regulators',
    name: 'Finance Regulators',
    icon: '💰',
    description: 'Deregulation is just regulation with better branding.',
    resistance: 45,
    corruptionSusceptibility: 0.7,
    greatnessOutput: 150,
    legitimacyImpact: -8,
    loyaltyGeneration: 0.5,
    category: 'regulatory',
  },
]

// Get institution def by id
export function getInstitutionDef(id: string): InstitutionDef | undefined {
  return INSTITUTIONS.find(i => i.id === id)
}

// ── Action Definitions ──

export type InstitutionActionType = 'co-opt' | 'replace' | 'purge' | 'rebrand' | 'automate' | 'privatize' | 'loyalty_test'

export interface InstitutionActionDef {
  type: InstitutionActionType
  name: string
  description: string
  duration: number      // seconds to complete
  costCash: number
  costLoyalty: number
  resistanceReduction: number
  legitimacyImpact: number
  requiresCaptured?: boolean  // only available after capture
}

export const INSTITUTION_ACTIONS: InstitutionActionDef[] = [
  {
    type: 'co-opt',
    name: 'Co-opt',
    description: 'Place loyalists in key positions. Slow but quiet.',
    duration: 180,       // 3 minutes
    costCash: 5000,
    costLoyalty: 0,
    resistanceReduction: 25,
    legitimacyImpact: -2,
  },
  {
    type: 'replace',
    name: 'Replace',
    description: 'Swap leadership entirely. Moderately disruptive.',
    duration: 90,        // 1.5 minutes
    costCash: 15000,
    costLoyalty: 10,
    resistanceReduction: 40,
    legitimacyImpact: -8,
  },
  {
    type: 'purge',
    name: 'Purge',
    description: 'Remove and replace all staff. Fast but devastating to optics.',
    duration: 30,        // 30 seconds
    costCash: 0,
    costLoyalty: 25,
    resistanceReduction: 60,
    legitimacyImpact: -20,
  },
  {
    type: 'rebrand',
    name: 'Rebrand',
    description: '"Modernization Initiative." Restores public trust.',
    duration: 60,
    costCash: 30000,
    costLoyalty: 0,
    resistanceReduction: 0,
    legitimacyImpact: 15,  // positive — restores legitimacy
    requiresCaptured: true,
  },
  {
    type: 'automate',
    name: 'Automate',
    description: 'AI-managed governance. No further management needed.',
    duration: 120,
    costCash: 100000,
    costLoyalty: 0,
    resistanceReduction: 0,
    legitimacyImpact: 0,
    requiresCaptured: true,
  },
  {
    type: 'privatize',
    name: 'Privatize',
    description: 'Sell to highest bidder. Cash now, consequences later.',
    duration: 45,
    costCash: 0,
    costLoyalty: 0,
    resistanceReduction: 0,
    legitimacyImpact: -12,
    requiresCaptured: true,
  },
  {
    type: 'loyalty_test',
    name: 'Loyalty Test',
    description: 'Fire anyone who fails. Survivors are motivated.',
    duration: 20,
    costCash: 0,
    costLoyalty: 5,
    resistanceReduction: 15,
    legitimacyImpact: -5,
  },
]

export function getActionDef(type: InstitutionActionType): InstitutionActionDef | undefined {
  return INSTITUTION_ACTIONS.find(a => a.type === type)
}
