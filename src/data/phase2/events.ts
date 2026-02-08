import type { GameEvent } from '../../store/types'

// ── Phase 2 Events ──
// 20+ events covering institutions, budget, tariffs, loyalty, data centers

export const PHASE2_EVENTS: GameEvent[] = [
  // ── Whistleblower / Scandal ──
  {
    id: 'p2_whistleblower',
    phase: 2,
    category: 'scandal',
    headline: 'WHISTLEBLOWER: Internal memos show institutional "realignment" plan.',
    context: 'A former bureaucrat has leaked detailed plans. Media is circling.',
    choices: [
      {
        label: 'Deny everything',
        description: '-10 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: -10, type: 'add' }],
      },
      {
        label: 'Discredit whistleblower',
        description: '-5 Legitimacy, +500 Attention',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'attention', amount: 500, type: 'add' },
        ],
      },
      {
        label: '"Transparency Initiative"',
        description: '-20,000 Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -20000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
    ],
  },

  // ── Public Concern ──
  {
    id: 'p2_poll_concern',
    phase: 2,
    category: 'crisis',
    headline: 'POLL: 60% of public "concerned" about institutional changes.',
    context: 'Approval ratings dropping. Advisory team recommends immediate action.',
    choices: [
      {
        label: 'Unity Campaign',
        description: '-50,000 Cash, +15 Legitimacy',
        effects: [
          { resource: 'cash', amount: -50000, type: 'add' },
          { resource: 'legitimacy', amount: 15, type: 'add' },
        ],
      },
      {
        label: 'Discredit the polls',
        description: '-8 Legitimacy, +1,000 Attention',
        effects: [
          { resource: 'legitimacy', amount: -8, type: 'add' },
          { resource: 'attention', amount: 1000, type: 'add' },
        ],
      },
      {
        label: 'Launch a merch drop',
        description: '+5,000 Cash',
        effects: [{ resource: 'cash', amount: 5000, type: 'add' }],
      },
    ],
  },

  // ── Military Defiance ──
  {
    id: 'p2_general_refuses',
    phase: 2,
    category: 'crisis',
    headline: 'GENERAL REFUSES TO COMPLY with Greatness Directive.',
    context: 'A senior military official is publicly questioning chain of command.',
    choices: [
      {
        label: 'Replace immediately',
        description: '-15 Legitimacy, Military resistance -20',
        effects: [{ resource: 'legitimacy', amount: -15, type: 'add' }],
      },
      {
        label: 'Negotiate',
        description: '-20,000 Cash',
        effects: [{ resource: 'cash', amount: -20000, type: 'add' }],
      },
      {
        label: '"Special Advisor" role',
        description: '-2 Legitimacy (a nothing position)',
        effects: [{ resource: 'legitimacy', amount: -2, type: 'add' }],
      },
    ],
  },

  // ── CEO Education ──
  {
    id: 'p2_ceo_education',
    phase: 2,
    category: 'opportunity',
    headline: 'CEO OFFERS TO RUN DEPARTMENT OF EDUCATION. "I\'ll make it efficient."',
    context: 'A tech billionaire wants to "disrupt" public education.',
    choices: [
      {
        label: 'Accept',
        description: '-20 Legitimacy, +50,000 Cash',
        effects: [
          { resource: 'legitimacy', amount: -20, type: 'add' },
          { resource: 'cash', amount: 50000, type: 'add' },
        ],
      },
      {
        label: 'Decline gracefully',
        description: '+5 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: 5, type: 'add' }],
      },
      {
        label: '"Public-Private Innovation"',
        description: '-10 Legitimacy, +50,000 Cash',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'cash', amount: 50000, type: 'add' },
        ],
      },
    ],
  },

  // ── Tariff Revenue ──
  {
    id: 'p2_tariff_revenue',
    phase: 2,
    category: 'opportunity',
    headline: 'TARIFF REVENUE UP 300%. Economists warn of "cascading consequences."',
    context: 'Cash is flowing. Experts are worried. Business as usual.',
    choices: [
      {
        label: 'Increase tariffs',
        description: '+200,000 Cash, -15 Legitimacy',
        effects: [
          { resource: 'cash', amount: 200000, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
      {
        label: 'Hold steady',
        description: 'No change',
        effects: [],
      },
      {
        label: 'Fire the economists',
        description: '+500 Attention, -10 Legitimacy',
        effects: [
          { resource: 'attention', amount: 500, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
    ],
  },

  // ── Health Agency Study ──
  {
    id: 'p2_health_study',
    phase: 2,
    category: 'contradiction',
    headline: 'HEALTH AGENCY SCIENTISTS PUBLISH UNFAVORABLE STUDY.',
    context: 'The data contradicts current messaging. Action required.',
    choices: [
      {
        label: 'Suppress the study',
        description: '-10 Legitimacy, +200 Loyalty',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'loyalty', amount: 200, type: 'add' },
        ],
      },
      {
        label: 'Rebrand the findings',
        description: '-50,000 Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -50000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Defund and build data centers',
        description: '+5,000 Attention, -20 Legitimacy',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
    ],
  },

  // ── Worker Protests ──
  {
    id: 'p2_worker_protests',
    phase: 2,
    category: 'crisis',
    headline: 'FEDERAL WORKERS PROTEST LOYALTY PLEDGE REQUIREMENT.',
    context: 'Thousands are refusing to sign. Media coverage is intense.',
    choices: [
      {
        label: 'Fire the protesters',
        description: '+500 Loyalty, -15 Legitimacy',
        effects: [
          { resource: 'loyalty', amount: 500, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
      {
        label: 'Negotiate',
        description: '-5 Loyalty, +10 Legitimacy',
        effects: [
          { resource: 'loyalty', amount: -5, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Automate their jobs',
        description: '+100,000 Cash, -20 Legitimacy',
        effects: [
          { resource: 'cash', amount: 100000, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
    ],
  },

  // ── Private Prison ──
  {
    id: 'p2_private_prison',
    phase: 2,
    category: 'opportunity',
    headline: 'PRIVATE PRISON CONTRACTOR offers to "manage" dissent.',
    context: '"Civic Rehabilitation Centers" — the branding is already done.',
    choices: [
      {
        label: 'Accept the offer',
        description: '+10,000 Cash, +Loyalty, -25 Legitimacy',
        effects: [
          { resource: 'cash', amount: 10000, type: 'add' },
          { resource: 'loyalty', amount: 100, type: 'add' },
          { resource: 'legitimacy', amount: -25, type: 'add' },
        ],
      },
      {
        label: 'Decline',
        description: '+10 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: 10, type: 'add' }],
      },
      {
        label: '"Civic Rehabilitation Centers"',
        description: '+10,000 Cash, +Loyalty, -10 Legitimacy',
        effects: [
          { resource: 'cash', amount: 10000, type: 'add' },
          { resource: 'loyalty', amount: 100, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
    ],
  },

  // ── Budget Crisis ──
  {
    id: 'p2_health_crisis',
    phase: 2,
    category: 'crisis',
    headline: 'HEALTH CRISIS: Hospitals overwhelmed. Emergency funding requested.',
    context: 'Budget committee requests $500,000 for emergency healthcare.',
    choices: [
      {
        label: 'Fund hospitals',
        description: '-500,000 Cash, +20 Legitimacy',
        effects: [
          { resource: 'cash', amount: -500000, type: 'add' },
          { resource: 'legitimacy', amount: 20, type: 'add' },
        ],
      },
      {
        label: '"Healthcare Innovation Hub" (data centers)',
        description: '+2,000 Attention, -15 Legitimacy',
        effects: [
          { resource: 'attention', amount: 2000, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
      {
        label: 'Thoughts and prayers',
        description: '-5 Legitimacy, +500 Attention',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'attention', amount: 500, type: 'add' },
        ],
      },
    ],
  },

  // ── Education Budget ──
  {
    id: 'p2_education_review',
    phase: 2,
    category: 'contradiction',
    headline: 'EDUCATION BUDGET REVIEW: Schools vs. Data Centers.',
    context: 'Both departments request additional funding. You can only fund one.',
    choices: [
      {
        label: 'Fund schools',
        description: '+10 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: 10, type: 'add' }],
      },
      {
        label: 'Fund data centers',
        description: '+5,000 Attention, -8 Legitimacy',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'legitimacy', amount: -8, type: 'add' },
        ],
      },
      {
        label: 'Defund both, boost military',
        description: '+3,000 Attention, -20 Legitimacy',
        effects: [
          { resource: 'attention', amount: 3000, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
    ],
  },

  // ── Workers Benefits ──
  {
    id: 'p2_workers_benefits',
    phase: 2,
    category: 'contradiction',
    headline: 'WORKERS DEMAND BENEFITS: Minimum wage increase proposed.',
    context: 'Workers want more. The budget says less.',
    choices: [
      {
        label: 'Approve increase',
        description: '-50,000 Cash, +15 Legitimacy',
        effects: [
          { resource: 'cash', amount: -50000, type: 'add' },
          { resource: 'legitimacy', amount: 15, type: 'add' },
        ],
      },
      {
        label: '"Greatness Stipend" (nothing)',
        description: '+5 Legitimacy, Reality Drift hint',
        effects: [{ resource: 'legitimacy', amount: 5, type: 'add' }],
      },
      {
        label: 'Replace with AI',
        description: '+100,000 Cash, -25 Legitimacy',
        effects: [
          { resource: 'cash', amount: 100000, type: 'add' },
          { resource: 'legitimacy', amount: -25, type: 'add' },
        ],
      },
    ],
  },

  // ── Veterans ──
  {
    id: 'p2_veterans',
    phase: 2,
    category: 'crisis',
    headline: 'VETERANS NEED CARE: 50,000 veterans require medical support.',
    context: 'The cost is real. The optics are real. Choose wisely.',
    choices: [
      {
        label: 'Fund VA',
        description: '-200,000 Cash, +15 Legitimacy',
        effects: [
          { resource: 'cash', amount: -200000, type: 'add' },
          { resource: 'legitimacy', amount: 15, type: 'add' },
          { resource: 'nobelScore', amount: 50, type: 'add' },
        ],
      },
      {
        label: '"Greatness Gratitude Ceremony"',
        description: '+5,000 Attention, -10 Legitimacy',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
      {
        label: 'Redirect to recruitment',
        description: '+500 Loyalty, -20 Legitimacy',
        effects: [
          { resource: 'loyalty', amount: 500, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
    ],
  },

  // ── Science vs Climate ──
  {
    id: 'p2_climate_research',
    phase: 2,
    category: 'contradiction',
    headline: 'SCIENTISTS REQUEST CLIMATE RESEARCH FUNDING.',
    context: 'Data suggests urgent need. Budget suggests urgent indifference.',
    choices: [
      {
        label: 'Fund research',
        description: '-100,000 Cash, +10 Nobel Score',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'nobelScore', amount: 10, type: 'add' },
        ],
      },
      {
        label: '"Weather Optimization" (military)',
        description: '+1,000 Attention',
        effects: [{ resource: 'attention', amount: 1000, type: 'add' }],
      },
      {
        label: 'Defund and declare victory',
        description: '+5,000 Attention, -15 Legitimacy',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
    ],
  },

  // ── Data Centers Growing ──
  {
    id: 'p2_data_center_growth',
    phase: 2,
    category: 'opportunity',
    headline: 'DATA CENTER CAPACITY DOUBLED. "Innovation" at unprecedented scale.',
    context: 'Processing power grows. Oversight shrinks. Efficiency abounds.',
    choices: [
      {
        label: 'Expand further',
        description: '+10,000 Attention, -5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 10000, type: 'add' },
          { resource: 'legitimacy', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Monetize the data',
        description: '+100,000 Cash',
        effects: [{ resource: 'cash', amount: 100000, type: 'add' }],
      },
      {
        label: '"Open Transparency Platform"',
        description: '+5 Legitimacy, +3,000 Attention',
        effects: [
          { resource: 'legitimacy', amount: 5, type: 'add' },
          { resource: 'attention', amount: 3000, type: 'add' },
        ],
      },
    ],
  },

  // ── Court Challenge ──
  {
    id: 'p2_court_challenge',
    phase: 2,
    category: 'crisis',
    headline: 'COURT CHALLENGES "REALIGNMENT" of Scientific Agencies.',
    context: 'Lower courts are pushing back. The legal battle could set precedent.',
    choices: [
      {
        label: 'Appeal to Supreme Court',
        description: '-30,000 Cash, slow but safe',
        effects: [{ resource: 'cash', amount: -30000, type: 'add' }],
      },
      {
        label: 'Ignore the ruling',
        description: '-20 Legitimacy, +300 Loyalty',
        effects: [
          { resource: 'legitimacy', amount: -20, type: 'add' },
          { resource: 'loyalty', amount: 300, type: 'add' },
        ],
      },
      {
        label: 'Replace the judges',
        description: '-15 Legitimacy, +500 Loyalty',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'loyalty', amount: 500, type: 'add' },
        ],
      },
    ],
  },

  // ── Absurd Events ──
  {
    id: 'p2_intern_policy',
    phase: 2,
    category: 'absurd',
    headline: 'INTERN ACCIDENTALLY PUBLISHES INTERNAL POLICY AS PUBLIC MEMO.',
    context: '"Project Greatness Alignment" now trending on all platforms.',
    choices: [
      {
        label: 'Claim it was intentional',
        description: '+2,000 Attention, -5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 2000, type: 'add' },
          { resource: 'legitimacy', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Blame the intern',
        description: '+500 Attention, +5 Loyalty',
        effects: [
          { resource: 'attention', amount: 500, type: 'add' },
          { resource: 'loyalty', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"It was a transparency exercise"',
        description: '+5 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: 5, type: 'add' }],
      },
    ],
  },

  {
    id: 'p2_ai_writes_speech',
    phase: 2,
    category: 'absurd',
    headline: 'AI SPEECH WRITER MALFUNCTIONS. Generates "surprisingly honest" address.',
    context: 'The speech mentioned "institutional domination" and "loyalty extraction."',
    choices: [
      {
        label: 'Call it satire',
        description: '+3,000 Attention, +5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 3000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Blame foreign hackers',
        description: '+1,000 Attention, +200 Loyalty',
        effects: [
          { resource: 'attention', amount: 1000, type: 'add' },
          { resource: 'loyalty', amount: 200, type: 'add' },
        ],
      },
      {
        label: 'Delete all evidence',
        description: '-5 Legitimacy, +500 Loyalty',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'loyalty', amount: 500, type: 'add' },
        ],
      },
    ],
  },

  {
    id: 'p2_loyalty_app',
    phase: 2,
    category: 'absurd',
    headline: 'NEW "GREAT CITIZEN" APP crashes on launch. 10M downloads anyway.',
    context: 'The app tracks loyalty metrics. It doesn\'t work. Nobody cares.',
    choices: [
      {
        label: 'Fix and relaunch',
        description: '-10,000 Cash, +500 Loyalty',
        effects: [
          { resource: 'cash', amount: -10000, type: 'add' },
          { resource: 'loyalty', amount: 500, type: 'add' },
        ],
      },
      {
        label: 'Ship broken (it\'s a feature)',
        description: '+5,000 Attention',
        effects: [{ resource: 'attention', amount: 5000, type: 'add' }],
      },
      {
        label: 'Mandatory download requirement',
        description: '+1,000 Loyalty, -10 Legitimacy',
        effects: [
          { resource: 'loyalty', amount: 1000, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
    ],
  },

  // ── Nobel-related ──
  {
    id: 'p2_nobel_nomination',
    phase: 2,
    category: 'opportunity',
    headline: 'HUMANITARIAN GROUP offers to nominate for "Greatness in Governance" award.',
    context: 'Not quite the Nobel. But it\'s a start.',
    choices: [
      {
        label: 'Accept with ceremony',
        description: '+10 Nobel Score, -30,000 Cash',
        effects: [
          { resource: 'nobelScore', amount: 10, type: 'add' },
          { resource: 'cash', amount: -30000, type: 'add' },
        ],
      },
      {
        label: '"Only the real thing matters"',
        description: '+1,000 Attention',
        effects: [{ resource: 'attention', amount: 1000, type: 'add' }],
      },
      {
        label: 'Create our own award',
        description: '+5 Nobel Score, +3,000 Attention',
        effects: [
          { resource: 'nobelScore', amount: 5, type: 'add' },
          { resource: 'attention', amount: 3000, type: 'add' },
        ],
      },
    ],
  },

  // ── Austerity Events ──
  {
    id: 'p2_austerity_protest',
    phase: 2,
    category: 'crisis',
    headline: 'MASS PROTESTS: Citizens demand healthcare and education funding.',
    context: 'Austerity measures are popular with the spreadsheet. Less so with the streets.',
    conditions: [{ resource: 'legitimacy', operator: '<', value: 50 }],
    choices: [
      {
        label: 'Increase social spending',
        description: '-100,000 Cash, +20 Legitimacy',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'legitimacy', amount: 20, type: 'add' },
        ],
      },
      {
        label: 'Deploy police',
        description: '+300 Loyalty, -25 Legitimacy',
        effects: [
          { resource: 'loyalty', amount: 300, type: 'add' },
          { resource: 'legitimacy', amount: -25, type: 'add' },
        ],
      },
      {
        label: '"Patriotic Patience" campaign',
        description: '+2,000 Attention, -5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 2000, type: 'add' },
          { resource: 'legitimacy', amount: -5, type: 'add' },
        ],
      },
    ],
  },
]
