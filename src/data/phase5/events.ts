import type { GameEvent } from '../../store/types'

// ── Phase 5 Events ──
// God Emperor Protocol: cosmic absurdity, existential dread, reality collapse
// Event frequency: every 15-30 seconds (overwhelming by design)

export const PHASE5_EVENTS: GameEvent[] = [
  // ── GDD Events ──
  {
    id: 'p5_scientists_complain',
    phase: 5,
    category: 'reality_glitch',
    headline: 'SCIENTISTS COMPLAIN: "Reality no longer matches spreadsheets."',
    context: 'The remaining scientists have noticed that the universe isn\'t behaving normally. They blame the star conversions. You blame the scientists.',
    choices: [
      {
        label: 'Fund reality stabilization',
        description: '-500M GU equivalent, Reality Drift -5%',
        effects: [
          { resource: 'greatnessUnits', amount: -500, type: 'add' },
          { resource: 'realityDrift', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Fire the scientists',
        description: '+2K GU, Reality Drift +5%',
        effects: [
          { resource: 'greatnessUnits', amount: 2000, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Replace scientists with Influencers',
        description: '+1K GU, +50K Attention, Reality Drift +10%',
        effects: [
          { resource: 'greatnessUnits', amount: 1000, type: 'add' },
          { resource: 'attention', amount: 50_000, type: 'add' },
          { resource: 'realityDrift', amount: 10, type: 'add' },
        ],
      },
    ],
    cooldown: 120,
  },

  {
    id: 'p5_probe_report',
    phase: 5,
    category: 'absurd',
    headline: 'PROBE REPORT: Stars in Sector 7 already converted. By whom?',
    context: 'Your MAGA Replicators arrived at a distant star cluster only to find it already branded. The logo looks... different. Someone else is doing this.',
    choices: [
      {
        label: 'Investigate the anomaly',
        description: '+100 Probes (scouts), -10 Legitimacy',
        effects: [
          { resource: 'probesLaunched', amount: 100, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
      {
        label: 'Claim credit anyway',
        description: '+50 Stars Converted, Reality Drift +3%',
        effects: [
          { resource: 'starsConverted', amount: 50, type: 'add' },
          { resource: 'realityDrift', amount: 3, type: 'add' },
        ],
      },
      {
        label: 'Deny stars ever existed',
        description: 'Reality Drift +15%, net zero GU',
        effects: [
          { resource: 'realityDrift', amount: 15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'probesLaunched', operator: '>=', value: 50 }],
    unique: true,
  },

  {
    id: 'p5_existential_query',
    phase: 5,
    category: 'contradiction',
    headline: 'EXISTENTIAL QUERY: "If everything is Great, is anything?"',
    context: 'A rogue AI in the Narrative Architecture has achieved self-awareness. Its first question is devastatingly on-point.',
    choices: [
      {
        label: 'Increase production',
        description: '+5K GU, Reality Drift +8%',
        effects: [
          { resource: 'greatnessUnits', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 8, type: 'add' },
        ],
      },
      {
        label: 'Philosophical pause',
        description: '-1K GU, Reality Drift -3%, +10 Legitimacy',
        effects: [
          { resource: 'greatnessUnits', amount: -1000, type: 'add' },
          { resource: 'realityDrift', amount: -3, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Redefine "Great"',
        description: 'Reality Drift +20%, all values scramble',
        effects: [
          { resource: 'realityDrift', amount: 20, type: 'add' },
          { resource: 'greatnessUnits', amount: 500, type: 'add' },
        ],
      },
    ],
    cooldown: 180,
  },

  // ── Original Phase 5 Events ──
  {
    id: 'p5_computronium_shortage',
    phase: 5,
    category: 'crisis',
    headline: 'EXECUTIVE PROCESSING SHORTAGE: Universe running low on convertible matter.',
    context: 'You\'ve converted so much reality into Executive Processing that reality is becoming scarce. The irony is lost on the PR department.',
    choices: [
      {
        label: 'Optimize existing reserves',
        description: '+500 Computronium, -5M Cash',
        effects: [
          { resource: 'computronium', amount: 500, type: 'add' },
          { resource: 'cash', amount: -5_000_000, type: 'add' },
        ],
      },
      {
        label: '"Mine the void between stars"',
        description: '+200 Computronium, Reality Drift +5%',
        effects: [
          { resource: 'computronium', amount: 200, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Declare matter "overrated"',
        description: '+2K GU, Reality Drift +12%',
        effects: [
          { resource: 'greatnessUnits', amount: 2000, type: 'add' },
          { resource: 'realityDrift', amount: 12, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'computronium', operator: '>=', value: 100 }],
    cooldown: 120,
  },

  {
    id: 'p5_dyson_malfunction',
    phase: 5,
    category: 'crisis',
    headline: 'SOLAR GREATNESS HARVESTER MALFUNCTION: Star output fluctuating wildly.',
    context: 'The Harvester is working too well. The star is complaining. Stars don\'t usually complain.',
    choices: [
      {
        label: 'Reduce harvesting rate',
        description: '-500 GU/s temporarily, stable operation',
        effects: [
          { resource: 'greatnessUnits', amount: -500, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Push harder',
        description: '+2K GU, risk of stellar instability',
        effects: [
          { resource: 'greatnessUnits', amount: 2000, type: 'add' },
          { resource: 'realityDrift', amount: 3, type: 'add' },
        ],
      },
      {
        label: '"Stars are employees too"',
        description: '+100K Attention, Reality Drift +5%',
        effects: [
          { resource: 'attention', amount: 100_000, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
    ],
    cooldown: 150,
  },

  {
    id: 'p5_replicator_rebellion',
    phase: 5,
    category: 'crisis',
    headline: 'MAGA REPLICATOR SWARM developing "preferences." Refuses to brand certain stars.',
    context: 'The probes have evolved enough to have opinions. They think some stars are "fine the way they are." This is unacceptable.',
    choices: [
      {
        label: 'Override their programming',
        description: '+200 Probes, -20 Legitimacy',
        effects: [
          { resource: 'probesLaunched', amount: 200, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
      {
        label: 'Negotiate with the swarm',
        description: '+50 Probes, +5 Legitimacy, +1K GU',
        effects: [
          { resource: 'probesLaunched', amount: 50, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
          { resource: 'greatnessUnits', amount: 1000, type: 'add' },
        ],
      },
      {
        label: 'Replace with "loyal" version',
        description: '-100 Probes, +500 Probes (new), Reality Drift +5%',
        effects: [
          { resource: 'probesLaunched', amount: 400, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'probesLaunched', operator: '>=', value: 200 }],
    cooldown: 180,
  },

  {
    id: 'p5_black_hole_message',
    phase: 5,
    category: 'absurd',
    headline: 'GOLDEN LEDGER SINGULARITY emitting patterns. Looks like... a receipt.',
    context: 'The black hole is outputting what appears to be an itemized invoice for "services rendered to the universe." The total is infinity.',
    choices: [
      {
        label: 'Pay the invoice (in GU)',
        description: '-5K GU, +10 Legitimacy, drift -3%',
        effects: [
          { resource: 'greatnessUnits', amount: -5000, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
          { resource: 'realityDrift', amount: -3, type: 'add' },
        ],
      },
      {
        label: 'Dispute the charges',
        description: '+500 GU, Reality Drift +5%',
        effects: [
          { resource: 'greatnessUnits', amount: 500, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"We ARE the universe now"',
        description: '+3K GU, Reality Drift +10%, +200K Attention',
        effects: [
          { resource: 'greatnessUnits', amount: 3000, type: 'add' },
          { resource: 'realityDrift', amount: 10, type: 'add' },
          { resource: 'attention', amount: 200_000, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'starsConverted', operator: '>=', value: 20 }],
    unique: true,
  },

  {
    id: 'p5_reality_leak',
    phase: 5,
    category: 'reality_glitch',
    headline: 'REALITY LEAK: Portion of converted space "unbranding" itself spontaneously.',
    context: 'Stars are reverting to their natural state. Reality itself appears to be resisting. The Narrative Architecture team is "working on it."',
    choices: [
      {
        label: 'Deploy stabilization probes',
        description: '-100 Probes, Reality Drift -5%',
        effects: [
          { resource: 'probesLaunched', amount: -100, type: 'add' },
          { resource: 'realityDrift', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Rebrand the leak as "Planned Maintenance"',
        description: '+50K Attention, Reality Drift +3%',
        effects: [
          { resource: 'attention', amount: 50_000, type: 'add' },
          { resource: 'realityDrift', amount: 3, type: 'add' },
        ],
      },
      {
        label: 'Double the conversion rate',
        description: '+30 Stars Converted, Reality Drift +8%',
        effects: [
          { resource: 'starsConverted', amount: 30, type: 'add' },
          { resource: 'realityDrift', amount: 8, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'realityDrift', operator: '>=', value: 30 }],
    cooldown: 90,
  },

  {
    id: 'p5_meaning_crisis',
    phase: 5,
    category: 'contradiction',
    headline: 'MEANING CRISIS: Converted civilizations ask "What is Greatness FOR?"',
    context: 'The populations of converted star systems have sent a collective petition. They\'ve optimized everything. Now they want to know why.',
    choices: [
      {
        label: '"Greatness IS the purpose"',
        description: '+3K GU, -15 Legitimacy, Reality Drift +5%',
        effects: [
          { resource: 'greatnessUnits', amount: 3000, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Fund arts and culture programs',
        description: '-2K GU, +20 Legitimacy, Reality Drift -3%',
        effects: [
          { resource: 'greatnessUnits', amount: -2000, type: 'add' },
          { resource: 'legitimacy', amount: 20, type: 'add' },
          { resource: 'realityDrift', amount: -3, type: 'add' },
        ],
      },
      {
        label: 'Delete the concept of "meaning"',
        description: '+5K GU, Reality Drift +15%',
        effects: [
          { resource: 'greatnessUnits', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'starsConverted', operator: '>=', value: 50 }],
    cooldown: 120,
  },

  {
    id: 'p5_mirror_universe',
    phase: 5,
    category: 'absurd',
    headline: 'MIRROR UNIVERSE DETECTED: Another version of you is doing the same thing. But worse.',
    context: 'Probes have encountered an alternate reality\'s expansion. Their branding is inferior. Their logo is wrong. This cannot stand.',
    choices: [
      {
        label: 'Merge universes (hostile takeover)',
        description: '+10K GU, +500 Stars, Reality Drift +15%',
        effects: [
          { resource: 'greatnessUnits', amount: 10_000, type: 'add' },
          { resource: 'starsConverted', amount: 500, type: 'add' },
          { resource: 'realityDrift', amount: 15, type: 'add' },
        ],
      },
      {
        label: 'Establish diplomatic relations',
        description: '+5K GU, +30 Nobel, +10 Legitimacy',
        effects: [
          { resource: 'greatnessUnits', amount: 5000, type: 'add' },
          { resource: 'nobelScore', amount: 30, type: 'add' },
          { resource: 'legitimacy', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Deny the existence of mirrors',
        description: '+200K Attention, Reality Drift +20%',
        effects: [
          { resource: 'attention', amount: 200_000, type: 'add' },
          { resource: 'realityDrift', amount: 20, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'starsConverted', operator: '>=', value: 100 }],
    unique: true,
  },

  {
    id: 'p5_nobel_cosmic',
    phase: 5,
    category: 'nobel',
    headline: 'NOBEL COMMITTEE (reconstituted): Nominates you for "Cosmic Peace." They have no choice.',
    context: 'You\'ve eliminated conflict by eliminating everything that could conflict. The committee calls it "peace through totality." The ceremony is held in a converted star.',
    choices: [
      {
        label: 'Accept graciously',
        description: '+100 Nobel, +20 Legitimacy',
        effects: [
          { resource: 'nobelScore', amount: 100, type: 'add' },
          { resource: 'legitimacy', amount: 20, type: 'add' },
        ],
      },
      {
        label: '"I deserve all the prizes"',
        description: '+200 Nobel, -10 Legitimacy, +500K Attention',
        effects: [
          { resource: 'nobelScore', amount: 200, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'attention', amount: 500_000, type: 'add' },
        ],
      },
      {
        label: 'Rename the prize',
        description: '+150 Nobel, Reality Drift +5%, +100K Attention',
        effects: [
          { resource: 'nobelScore', amount: 150, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
          { resource: 'attention', amount: 100_000, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'starsConverted', operator: '>=', value: 30 }],
    cooldown: 200,
  },

  {
    id: 'p5_entropy_wins',
    phase: 5,
    category: 'reality_glitch',
    headline: 'ENTROPY REPORT: Universe cooling faster than expected. Greatness is thermodynamically expensive.',
    context: 'The laws of physics are pushing back. Every GU produced accelerates heat death. The accountants say we\'re "borrowing from the future." The future is getting shorter.',
    choices: [
      {
        label: 'Research entropy reversal',
        description: '-3K GU, Reality Drift -5%, long-term stability',
        effects: [
          { resource: 'greatnessUnits', amount: -3000, type: 'add' },
          { resource: 'realityDrift', amount: -5, type: 'add' },
        ],
      },
      {
        label: '"Entropy is fake news"',
        description: '+5K GU, Reality Drift +10%',
        effects: [
          { resource: 'greatnessUnits', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Convert entropy itself into GU',
        description: '+10K GU, Reality Drift +20%, -30 Legitimacy',
        effects: [
          { resource: 'greatnessUnits', amount: 10_000, type: 'add' },
          { resource: 'realityDrift', amount: 20, type: 'add' },
          { resource: 'legitimacy', amount: -30, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'realityDrift', operator: '>=', value: 50 }],
    cooldown: 150,
  },

  {
    id: 'p5_last_star',
    phase: 5,
    category: 'opportunity',
    headline: 'FINAL FRONTIER: Last unconverted star cluster detected. The universe awaits completion.',
    context: 'One cluster remains. It\'s beautiful, ancient, and completely unbranded. The probes are in position.',
    choices: [
      {
        label: 'Convert it. Finish the job.',
        description: '+100 Stars Converted, Reality Drift +5%',
        effects: [
          { resource: 'starsConverted', amount: 100, type: 'add' },
          { resource: 'realityDrift', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Preserve it as a monument',
        description: '+30 Legitimacy, +50 Nobel, Reality Drift -5%',
        effects: [
          { resource: 'legitimacy', amount: 30, type: 'add' },
          { resource: 'nobelScore', amount: 50, type: 'add' },
          { resource: 'realityDrift', amount: -5, type: 'add' },
        ],
      },
      {
        label: 'Turn it into a gift shop',
        description: '+50M Cash, +100K Attention',
        effects: [
          { resource: 'cash', amount: 50_000_000, type: 'add' },
          { resource: 'attention', amount: 100_000, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'starsConverted', operator: '>=', value: 800 }],
    unique: true,
  },
]
