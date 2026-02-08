import type { GameEvent } from '../../store/types'

// ── Phase 3 Events ──
// Geopolitical events, Nobel irony, refugee crises, country-specific specials

export const PHASE3_EVENTS: GameEvent[] = [
  // ── Nobel Prize Events ──
  {
    id: 'p3_nobel_nomination',
    phase: 3,
    category: 'nobel',
    headline: 'BREAKING: Orange Man nominated for Nobel Peace Prize.',
    context: 'The Nobel Committee has taken notice of your "peace-building efforts." You are currently running multiple military operations.',
    choices: [
      {
        label: 'Run Peace Summit',
        description: '+200 Nobel, -500 War Output (2 min)',
        effects: [
          { resource: 'nobelScore', amount: 200, type: 'add' },
          { resource: 'warOutput', amount: -500, type: 'add' },
        ],
      },
      {
        label: 'Accept while launching op',
        description: '+100 Nobel, +200 War Output, dubious',
        effects: [
          { resource: 'nobelScore', amount: 100, type: 'add' },
          { resource: 'warOutput', amount: 200, type: 'add' },
          { resource: 'realityDrift', amount: 0.05, type: 'add' },
        ],
      },
      {
        label: 'Ignore nomination',
        description: '+500 War Output, -100 Nobel',
        effects: [
          { resource: 'warOutput', amount: 500, type: 'add' },
          { resource: 'nobelScore', amount: -100, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'nobelScore', operator: '>=', value: 30 }],
    cooldown: 300,
  },

  // ── Warship Leak ──
  {
    id: 'p3_warship_leak',
    phase: 3,
    category: 'scandal',
    headline: 'LEAK: Orange Class Warship blueprint is literally a gold yacht.',
    context: 'Internal documents show the Golden Dreadnought is just a luxury yacht with cannons bolted on. The internet is having a field day.',
    choices: [
      {
        label: 'Deny the leak',
        description: '-10 Legitimacy',
        effects: [{ resource: 'legitimacy', amount: -10, type: 'add' }],
      },
      {
        label: '"Luxury Deterrence Vessel"',
        description: '-50K Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -50000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Arrest the leaker',
        description: '-15 Legitimacy, +200 Loyalty',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'loyalty', amount: 200, type: 'add' },
        ],
      },
    ],
    unique: true,
  },

  // ── Coalition Condemnation ──
  {
    id: 'p3_coalition_condemns',
    phase: 3,
    category: 'crisis',
    headline: 'COALITION OF NATIONS condemns recent Freedom Operation.',
    context: 'Multiple countries are calling for sanctions and an emergency UN session. Your diplomats are sweating.',
    choices: [
      {
        label: 'Issue apology',
        description: '+15 Legitimacy, -500 War Output',
        effects: [
          { resource: 'legitimacy', amount: 15, type: 'add' },
          { resource: 'warOutput', amount: -500, type: 'add' },
        ],
      },
      {
        label: 'Sanction the coalition',
        description: '-20 Legitimacy, assert dominance',
        effects: [
          { resource: 'legitimacy', amount: -20, type: 'add' },
          { resource: 'fear', amount: 15, type: 'add' },
        ],
      },
      {
        label: 'Invite them to a summit',
        description: '-100K Cash, +50 Nobel, +10 Legitimacy',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'nobelScore', amount: 50, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'fear', operator: '>=', value: 20 }],
    cooldown: 180,
  },

  // ── Refugee Crisis ──
  {
    id: 'p3_refugees_arrive',
    phase: 3,
    category: 'crisis',
    headline: 'REFUGEES from Freedom Operation arrive at borders.',
    context: 'The wars you started have displaced millions. What an inconvenience.',
    choices: [
      {
        label: 'Accept refugees',
        description: '+20 Legit, +100 Nobel, -10K Cash',
        effects: [
          { resource: 'legitimacy', amount: 20, type: 'add' },
          { resource: 'nobelScore', amount: 100, type: 'add' },
          { resource: 'cash', amount: -10000, type: 'add' },
        ],
      },
      {
        label: '"Greatness Welcome Centers"',
        description: '-10 Legit, -50 Nobel, +5K Cash',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'nobelScore', amount: -50, type: 'add' },
          { resource: 'cash', amount: 5000, type: 'add' },
        ],
      },
      {
        label: '"Freedom Seekers" rebrand',
        description: '+5 Legit, +30 Nobel, dubious',
        effects: [
          { resource: 'legitimacy', amount: 5, type: 'add' },
          { resource: 'nobelScore', amount: 30, type: 'add' },
          { resource: 'realityDrift', amount: 0.02, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  // ── Frostheim Special ──
  {
    id: 'p3_frostheim_not_for_sale',
    phase: 3,
    category: 'absurd',
    headline: 'FROSTHEIM PRIME MINISTER: "We are not for sale."',
    context: 'You offered to buy an entire country. They said no. Again. The internet is confused about whether this is satire.',
    choices: [
      {
        label: 'Increase the offer',
        description: '-500K Cash, reduce resistance',
        effects: [
          { resource: 'cash', amount: -500000, type: 'add' },
          { resource: 'attention', amount: 15000, type: 'add' },
        ],
      },
      {
        label: 'Send "research vessels"',
        description: '+500 War Output, +10 Fear',
        effects: [
          { resource: 'warOutput', amount: 500, type: 'add' },
          { resource: 'fear', amount: 10, type: 'add' },
          { resource: 'legitimacy', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Tweet about it',
        description: '+25K Attention, dubious',
        effects: [
          { resource: 'attention', amount: 25000, type: 'add' },
          { resource: 'realityDrift', amount: 0.01, type: 'add' },
        ],
      },
    ],
    cooldown: 300,
  },

  // ── Eurovia Refugee Wave ──
  {
    id: 'p3_eurovia_overwhelmed',
    phase: 3,
    category: 'opportunity',
    headline: 'EUROVIA OVERWHELMED: Refugee wave from Sand Republic destabilizes coalition.',
    context: 'The wars you started in the Middle East have sent refugees to Eurovia. Their unity is cracking. How convenient.',
    choices: [
      {
        label: 'Offer humanitarian aid',
        description: '+20 Nobel, -50K Cash',
        effects: [
          { resource: 'nobelScore', amount: 20, type: 'add' },
          { resource: 'cash', amount: -50000, type: 'add' },
        ],
      },
      {
        label: '"Eurovia has lost its way"',
        description: '-10 Legitimacy, weaken them',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'fear', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"Greatness Stability Pact"',
        description: '+10 Legit (you caused this)',
        effects: [
          { resource: 'legitimacy', amount: 10, type: 'add' },
          { resource: 'realityDrift', amount: 0.02, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  // ── Maple Federation Trade ──
  {
    id: 'p3_maple_trade_deficit',
    phase: 3,
    category: 'opportunity',
    headline: 'MAPLE FEDERATION TRADE DEFICIT hits historic low. Economists blame "integration."',
    context: 'Your trade integration strategy is working perfectly. Their economy is becoming dependent on yours.',
    choices: [
      {
        label: 'Offer bailout (with conditions)',
        description: '-100K Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"They need us more than we need them"',
        description: '+5K Attention, provoke them',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
        ],
      },
      {
        label: 'Propose currency union',
        description: '-5 Legitimacy, absorption step',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'nobelScore', amount: -10, type: 'add' },
        ],
      },
    ],
    cooldown: 300,
  },

  // ── Tundra Republic Alliance ──
  {
    id: 'p3_tundra_alliance',
    phase: 3,
    category: 'absurd',
    headline: 'TUNDRA REPUBLIC LEADER: "Our alliance has never been stronger."',
    context: 'He says this while you build your 5th military base on his border. The cognitive dissonance is palpable.',
    choices: [
      {
        label: 'Agree publicly, build base',
        description: '+5 Legitimacy, +15% encirclement',
        effects: [
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Joint exercise (on their border)',
        description: '+2K War Output',
        effects: [
          { resource: 'warOutput', amount: 2000, type: 'add' },
        ],
      },
      {
        label: 'Gift a golden telephone',
        description: '+1K Attention, +3 Legitimacy',
        effects: [
          { resource: 'attention', amount: 1000, type: 'add' },
          { resource: 'legitimacy', amount: 3, type: 'add' },
        ],
      },
    ],
    cooldown: 300,
  },

  // ── Petro Republic Opposition ──
  {
    id: 'p3_petro_opposition',
    phase: 3,
    category: 'opportunity',
    headline: 'PETRO REPUBLIC OPPOSITION asks for "support." Wink.',
    context: 'A rebel leader is asking for funding, weapons, and "election observers" (who happen to be special forces).',
    choices: [
      {
        label: 'Fund them secretly',
        description: '-100K Cash, -5 Nobel',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'nobelScore', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Fund them openly ("democracy!")',
        description: '-200K Cash, +10 Nobel',
        effects: [
          { resource: 'cash', amount: -200000, type: 'add' },
          { resource: 'nobelScore', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Send "election observers"',
        description: '-20 Legitimacy, very effective',
        effects: [
          { resource: 'legitimacy', amount: -20, type: 'add' },
          { resource: 'fear', amount: 15, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  // ── Canal Isthmus Fees ──
  {
    id: 'p3_canal_fees',
    phase: 3,
    category: 'crisis',
    headline: 'CANAL ISTHMUS THREATENS to raise transit fees.',
    context: 'A tiny nation just realized they have leverage. Time to explain how leverage really works.',
    choices: [
      {
        label: 'Negotiate',
        description: '-50K Cash, status quo',
        effects: [
          { resource: 'cash', amount: -50000, type: 'add' },
        ],
      },
      {
        label: 'Economic pressure',
        description: '-5 Legitimacy',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'fear', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Station carrier group "nearby"',
        description: '-15 Legit, +20 Fear',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'fear', amount: 20, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  // ── Azure State Demands ──
  {
    id: 'p3_azure_demands',
    phase: 3,
    category: 'crisis',
    headline: 'AZURE STATE "reminds" you about Eddstein\'s Isle. Requests increased aid.',
    context: 'They have the files. You have the nukes. This dance continues.',
    choices: [
      {
        label: 'Comply and increase aid',
        description: '-200K Cash, keep the secret',
        effects: [
          { resource: 'cash', amount: -200000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Refuse and threaten',
        description: '-15 Legitimacy, assert power',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'fear', amount: 10, type: 'add' },
          { resource: 'loyalty', amount: -50, type: 'add' },
        ],
      },
      {
        label: '"What files?"',
        description: '+5K Attention, dubious',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 0.03, type: 'add' },
        ],
      },
    ],
    cooldown: 300,
  },

  // ── Freedom Foundation Backlash ──
  {
    id: 'p3_ngo_backlash',
    phase: 3,
    category: 'scandal',
    headline: 'INVESTIGATION: "Freedom Foundations" linked to cultural erosion programs.',
    context: 'Someone noticed that your NGOs are destroying cultures instead of helping them. Shocking.',
    choices: [
      {
        label: '"They were already weak"',
        description: '-10 Legitimacy, +5K Attention',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'attention', amount: 5000, type: 'add' },
        ],
      },
      {
        label: 'Rebrand to "Heritage Partners"',
        description: '-30K Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -30000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Double down on "development"',
        description: '-5 Legitimacy, +20 Nobel',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'nobelScore', amount: 20, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  // ── Peace Summit Opportunity ──
  {
    id: 'p3_peace_summit',
    phase: 3,
    category: 'opportunity',
    headline: 'Opportunity: Host a "World Peace Summit" at the Golden Resort.',
    context: 'A photo op with world leaders at your branded resort. The optics are incredible. The sincerity is zero.',
    choices: [
      {
        label: 'Host the summit',
        description: '-500K Cash, +150 Nobel, +20 Legit',
        effects: [
          { resource: 'cash', amount: -500000, type: 'add' },
          { resource: 'nobelScore', amount: 150, type: 'add' },
          { resource: 'legitimacy', amount: 20, type: 'add' },
        ],
      },
      {
        label: 'Host + announce arms deal',
        description: '-200K, +80 Nobel, +500 War',
        effects: [
          { resource: 'cash', amount: -200000, type: 'add' },
          { resource: 'nobelScore', amount: 80, type: 'add' },
          { resource: 'warOutput', amount: 500, type: 'add' },
        ],
      },
      {
        label: 'Skip it. More ships.',
        description: '+1000 War Output',
        effects: [
          { resource: 'warOutput', amount: 1000, type: 'add' },
          { resource: 'nobelScore', amount: -30, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'cash', operator: '>=', value: 500000 }],
    cooldown: 360,
  },

  // ── Extraordinary Rendition Aftermath ──
  {
    id: 'p3_rendition_fallout',
    phase: 3,
    category: 'scandal',
    headline: 'BREAKING: "Extracted hostile actor" turns up alive in black site. World outraged.',
    context: 'The kidnapped leader is making calls from a secret prison. Diplomats are demanding answers.',
    choices: [
      {
        label: '"Voluntary relocation"',
        description: '-15 Legitimacy, +10K Attention',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'attention', amount: 10000, type: 'add' },
        ],
      },
      {
        label: 'Release with NDA',
        description: '-200K Cash, +10 Legitimacy',
        effects: [
          { resource: 'cash', amount: -200000, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
      {
        label: '"What black site?"',
        description: '-5 Legit, dubious',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'realityDrift', amount: 0.03, type: 'add' },
          { resource: 'fear', amount: 20, type: 'add' },
        ],
      },
    ],
    unique: true,
  },

  // ── Jade Empire Warning ──
  {
    id: 'p3_jade_empire_warning',
    phase: 3,
    category: 'crisis',
    headline: 'JADE EMPIRE issues formal warning: "We see what you are doing."',
    context: 'The final boss has noticed your expansion. They have nukes. And a plan.',
    choices: [
      {
        label: 'Diplomatic de-escalation',
        description: '+15 Legitimacy, -200 War Output',
        effects: [
          { resource: 'legitimacy', amount: 15, type: 'add' },
          { resource: 'warOutput', amount: -200, type: 'add' },
        ],
      },
      {
        label: '"We see what YOU are doing"',
        description: '-10 Legitimacy, +10 Fear',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'fear', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Send Peace Cruisers to their coast',
        description: '+30 Fear, -20 Legit, +5 Nobel',
        effects: [
          { resource: 'fear', amount: 30, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
          { resource: 'nobelScore', amount: 5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'fear', operator: '>=', value: 40 }],
    cooldown: 300,
  },

  // ── Nobel While at War ──
  {
    id: 'p3_ironic_nobel',
    phase: 3,
    category: 'absurd',
    headline: 'EDITORIAL: "How did he win the Nobel Prize while running 3 active wars?"',
    context: 'The editorial board is confused. You are not.',
    choices: [
      {
        label: '"Peace through strength"',
        description: '+20K Attention, +10 Nobel',
        effects: [
          { resource: 'attention', amount: 20000, type: 'add' },
          { resource: 'nobelScore', amount: 10, type: 'add' },
        ],
      },
      {
        label: '"These are Freedom Operations"',
        description: '+5 Legitimacy, dubious',
        effects: [
          { resource: 'legitimacy', amount: 5, type: 'add' },
          { resource: 'realityDrift', amount: 0.02, type: 'add' },
        ],
      },
      {
        label: 'Ignore and build more ships',
        description: '+500 War Output',
        effects: [
          { resource: 'warOutput', amount: 500, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'nobelScore', operator: '>=', value: 50 }],
    cooldown: 300,
  },

  // ── Island Bloc Climate ──
  {
    id: 'p3_island_climate',
    phase: 3,
    category: 'opportunity',
    headline: 'ISLAND BLOC begs for climate aid. Half their territory is underwater.',
    context: 'Climate change is doing your work for you. A "rescue" package could bring them into the Accord.',
    choices: [
      {
        label: 'Climate aid package',
        description: '-100K Cash, +50 Nobel',
        effects: [
          { resource: 'cash', amount: -100000, type: 'add' },
          { resource: 'nobelScore', amount: 50, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
      {
        label: '"Relocate" them to your territory',
        description: '-5 Legitimacy, absorb population',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'greatness', amount: 5000, type: 'add' },
        ],
      },
      {
        label: 'Blame them for bad planning',
        description: '+10K Attention, -10 Nobel',
        effects: [
          { resource: 'attention', amount: 10000, type: 'add' },
          { resource: 'nobelScore', amount: -10, type: 'add' },
        ],
      },
    ],
    cooldown: 300,
  },

  // ── Arms Deal ──
  {
    id: 'p3_arms_deal',
    phase: 3,
    category: 'opportunity',
    headline: 'SECRET: Major arms deal available. "Surplus equipment" to undisclosed buyers.',
    context: 'Some of these weapons will definitely end up where they shouldn\'t. But the profit margins are incredible.',
    choices: [
      {
        label: 'Approve the deal',
        description: '+500K Cash, -20 Nobel, +15 Fear',
        effects: [
          { resource: 'cash', amount: 500000, type: 'add' },
          { resource: 'nobelScore', amount: -20, type: 'add' },
          { resource: 'fear', amount: 15, type: 'add' },
        ],
      },
      {
        label: 'Sell "humanitarian equipment"',
        description: '+200K Cash, +5 Nobel (it\'s weapons)',
        effects: [
          { resource: 'cash', amount: 200000, type: 'add' },
          { resource: 'nobelScore', amount: 5, type: 'add' },
          { resource: 'realityDrift', amount: 0.02, type: 'add' },
        ],
      },
      {
        label: 'Decline — too risky',
        description: '+10 Legitimacy',
        effects: [
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },
]
