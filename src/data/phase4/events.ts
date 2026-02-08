import type { GameEvent } from '../../store/types'

// ── Phase 4 Events ──
// Space Greatening: colonization absurdity, branding lunacy, Mars renaming

export const PHASE4_EVENTS: GameEvent[] = [
  // ── GDD Events ──
  {
    id: 'p4_colonist_revolt',
    phase: 4,
    category: 'crisis',
    headline: 'BREAKING: Mars colonists demand "basic rights." Outrageous.',
    context: 'The colonists want healthcare, breathable air, and a say in governance. This is exactly the kind of short-term thinking the Long-Term Thinking Simulator was supposed to prevent.',
    choices: [
      {
        label: 'Grant limited rights',
        description: '+10 Legitimacy, -2M Cash, colonist morale boost',
        effects: [
          { resource: 'legitimacy', amount: 10, type: 'add' },
          { resource: 'cash', amount: -2_000_000, type: 'add' },
          { resource: 'colonists', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"Rights are an Earth concept"',
        description: '-15 Legitimacy, +10K Attention',
        effects: [
          { resource: 'legitimacy', amount: -15, type: 'add' },
          { resource: 'attention', amount: 10_000, type: 'add' },
          { resource: 'realityDrift', amount: 0.5, type: 'add' },
        ],
      },
      {
        label: 'Replace colonists with drones',
        description: '-20 Colonists, +5 Orbital Industry',
        effects: [
          { resource: 'colonists', amount: -20, type: 'add' },
          { resource: 'orbitalIndustry', amount: 5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'colonists', operator: '>=', value: 10 }],
    cooldown: 300,
  },

  {
    id: 'p4_greatium_discovery',
    phase: 4,
    category: 'opportunity',
    headline: 'SCIENTISTS DISCOVER NEW ELEMENT: Dubbed "Greatium" by naming committee.',
    context: 'Asteroid miners found an element that doesn\'t exist on Earth. The naming rights were auctioned. You won.',
    choices: [
      {
        label: 'Patent it immediately',
        description: '+5M Cash, -10 Nobel',
        effects: [
          { resource: 'cash', amount: 5_000_000, type: 'add' },
          { resource: 'nobelScore', amount: -10, type: 'add' },
        ],
      },
      {
        label: 'Fund research',
        description: '+20 Nobel, +10 Orbital Industry',
        effects: [
          { resource: 'nobelScore', amount: 20, type: 'add' },
          { resource: 'orbitalIndustry', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Weaponize it',
        description: '+3K War Output, +50 Fear, dubious',
        effects: [
          { resource: 'warOutput', amount: 3000, type: 'add' },
          { resource: 'fear', amount: 50, type: 'add' },
          { resource: 'realityDrift', amount: 0.3, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'miningOutput', operator: '>=', value: 20 }],
    unique: true,
  },

  {
    id: 'p4_alien_signal',
    phase: 4,
    category: 'absurd',
    headline: 'DEEP SPACE ARRAY detects possible alien signal. Contains what appears to be a complaint.',
    context: 'The signal translates roughly to: "Please stop. Your propaganda satellites are interfering with our frequencies." First contact is going great.',
    choices: [
      {
        label: 'Reply with friendship message',
        description: '+30 Nobel, +20K Attention',
        effects: [
          { resource: 'nobelScore', amount: 30, type: 'add' },
          { resource: 'attention', amount: 20_000, type: 'add' },
        ],
      },
      {
        label: '"Alien market = new customers"',
        description: '+10M Cash, -20 Legitimacy',
        effects: [
          { resource: 'cash', amount: 10_000_000, type: 'add' },
          { resource: 'legitimacy', amount: -20, type: 'add' },
        ],
      },
      {
        label: 'Aim the Diplomatic Railgun at the signal',
        description: '+100 Fear, +5K War Output, dubious',
        effects: [
          { resource: 'fear', amount: 100, type: 'add' },
          { resource: 'warOutput', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 1, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'orbitalIndustry', operator: '>=', value: 50 }],
    unique: true,
  },

  // ── Original Events ──
  {
    id: 'p4_launch_failure',
    phase: 4,
    category: 'crisis',
    headline: 'LAUNCH FAILURE: Greatness Rocket explodes on pad. "Planned rapid disassembly."',
    context: 'The rocket was branded before it was tested. Branding survived the explosion. Engineering did not.',
    choices: [
      {
        label: 'Fund investigation',
        description: '-3M Cash, +5 Legitimacy',
        effects: [
          { resource: 'cash', amount: -3_000_000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"Planned rapid disassembly"',
        description: '-10 Legitimacy, +5K Attention',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 0.2, type: 'add' },
        ],
      },
      {
        label: 'Blame contractor, build faster',
        description: '-1M Cash, +10 Rocket Mass',
        effects: [
          { resource: 'cash', amount: -1_000_000, type: 'add' },
          { resource: 'rocketMass', amount: 10, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  {
    id: 'p4_mars_dust_storm',
    phase: 4,
    category: 'crisis',
    headline: 'MARS DUST STORM threatens colony. Colonists shelter in branded bunkers.',
    context: 'The bunker walls are covered in motivational posters. "Breathe Greatness" hits different when there\'s no air.',
    choices: [
      {
        label: 'Emergency supply drop',
        description: '-5M Cash, +5 Colonists',
        effects: [
          { resource: 'cash', amount: -5_000_000, type: 'add' },
          { resource: 'colonists', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"Natural selection in action"',
        description: '-10 Colonists, -15 Legitimacy',
        effects: [
          { resource: 'colonists', amount: -10, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
      {
        label: 'Rebrand it "Character Building Weather"',
        description: '-5 Legitimacy, dubious',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'realityDrift', amount: 0.3, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'colonists', operator: '>=', value: 5 }],
    cooldown: 300,
  },

  {
    id: 'p4_asteroid_dispute',
    phase: 4,
    category: 'scandal',
    headline: 'JADE EMPIRE claims asteroid belt mining rights. Presents ancient star maps.',
    context: 'They claim their ancestors mapped the asteroids first. The maps are clearly from 2024.',
    choices: [
      {
        label: 'Share mining rights',
        description: '+15 Legitimacy, -50 Mining Output',
        effects: [
          { resource: 'legitimacy', amount: 15, type: 'add' },
          { resource: 'miningOutput', amount: -50, type: 'add' },
        ],
      },
      {
        label: '"First come, first mine"',
        description: '-10 Legitimacy, +30 Fear',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'fear', amount: 30, type: 'add' },
        ],
      },
      {
        label: 'Counter-claim with "ancient" tweet',
        description: '+15K Attention, dubious',
        effects: [
          { resource: 'attention', amount: 15_000, type: 'add' },
          { resource: 'realityDrift', amount: 0.2, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'miningOutput', operator: '>=', value: 10 }],
    cooldown: 300,
  },

  {
    id: 'p4_space_tourism',
    phase: 4,
    category: 'opportunity',
    headline: 'SPACE TOURISM DEMAND surges. Billionaires want branded orbital selfies.',
    context: 'They\'ll pay $10M each to float in zero gravity with your logo in the background. The brand exposure is literally cosmic.',
    choices: [
      {
        label: 'Launch tourism program',
        description: '+15M Cash, +20K Attention',
        effects: [
          { resource: 'cash', amount: 15_000_000, type: 'add' },
          { resource: 'attention', amount: 20_000, type: 'add' },
        ],
      },
      {
        label: 'Mandatory "Greatness Experience"',
        description: '+8M Cash, +5 Legitimacy (indoctrination)',
        effects: [
          { resource: 'cash', amount: 8_000_000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Military-only flights',
        description: '+5 Orbital Industry, +1K War Output',
        effects: [
          { resource: 'orbitalIndustry', amount: 5, type: 'add' },
          { resource: 'warOutput', amount: 1000, type: 'add' },
        ],
      },
    ],
    cooldown: 240,
  },

  {
    id: 'p4_lunar_heritage_vandalism',
    phase: 4,
    category: 'absurd',
    headline: 'VANDALS at Lunar Heritage Site replace original Apollo flag with golden one.',
    context: 'Wait — that was you. You ordered that. The "vandals" were your employees.',
    choices: [
      {
        label: '"History is being updated"',
        description: '+5K Attention, dubious',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'realityDrift', amount: 0.3, type: 'add' },
        ],
      },
      {
        label: 'Deny everything',
        description: '-5 Legitimacy, +10K Attention',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'attention', amount: 10_000, type: 'add' },
        ],
      },
      {
        label: 'Sell the original flag at auction',
        description: '+2M Cash, -10 Legitimacy',
        effects: [
          { resource: 'cash', amount: 2_000_000, type: 'add' },
          { resource: 'legitimacy', amount: -10, type: 'add' },
        ],
      },
    ],
    unique: true,
  },

  {
    id: 'p4_satellite_hack',
    phase: 4,
    category: 'crisis',
    headline: 'PROPAGANDA SATELLITES HACKED: Now broadcasting "actual news." Crisis mode.',
    context: 'Someone reprogrammed your satellites to broadcast facts. The horror. Legitimacy is spiking because people trust the satellites now — but the wrong kind of trust.',
    choices: [
      {
        label: 'Retake control immediately',
        description: '-5M Cash, restore normal propaganda',
        effects: [
          { resource: 'cash', amount: -5_000_000, type: 'add' },
        ],
      },
      {
        label: '"We meant to do that"',
        description: '+10 Legitimacy, -5 Satellites\' effectiveness',
        effects: [
          { resource: 'legitimacy', amount: 10, type: 'add' },
          { resource: 'realityDrift', amount: -0.5, type: 'add' },
        ],
      },
      {
        label: 'Arrest the hackers, double the propaganda',
        description: '-10 Legitimacy, +50 Fear, +5K Attention',
        effects: [
          { resource: 'legitimacy', amount: -10, type: 'add' },
          { resource: 'fear', amount: 50, type: 'add' },
          { resource: 'attention', amount: 5000, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'orbitalIndustry', operator: '>=', value: 20 }],
    cooldown: 300,
  },

  {
    id: 'p4_mars_renaming',
    phase: 4,
    category: 'absurd',
    headline: 'MARS OFFICIALLY RENAMED: Scientists weep. Branding team celebrates.',
    context: 'The International Astronomical Union has been replaced by the International Greatness Union. Mars is now "The Orange Planet." Olympus Mons is "Victory Peak."',
    choices: [
      {
        label: 'Mandate new textbooks',
        description: '+20K Attention, +5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 20_000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Sell naming rights to features',
        description: '+10M Cash',
        effects: [
          { resource: 'cash', amount: 10_000_000, type: 'add' },
        ],
      },
      {
        label: '"The planet wanted this"',
        description: '-5 Legitimacy, +30K Attention, dubious',
        effects: [
          { resource: 'legitimacy', amount: -5, type: 'add' },
          { resource: 'attention', amount: 30_000, type: 'add' },
          { resource: 'realityDrift', amount: 0.5, type: 'add' },
        ],
      },
    ],
    unique: true,
    conditions: [{ resource: 'terraformProgress', operator: '>=', value: 25 }],
  },

  {
    id: 'p4_space_debris',
    phase: 4,
    category: 'crisis',
    headline: 'SPACE DEBRIS CRISIS: Kessler syndrome threatens orbital operations.',
    context: 'All those rushed launches left a mess. Debris is colliding with debris. Your insurance company has stopped returning calls.',
    choices: [
      {
        label: 'Fund cleanup mission',
        description: '-8M Cash, protect infrastructure',
        effects: [
          { resource: 'cash', amount: -8_000_000, type: 'add' },
          { resource: 'legitimacy', amount: 5, type: 'add' },
        ],
      },
      {
        label: '"Debris is just unmined resources"',
        description: '+5 Mining Output, dubious',
        effects: [
          { resource: 'miningOutput', amount: 5, type: 'add' },
          { resource: 'realityDrift', amount: 0.3, type: 'add' },
        ],
      },
      {
        label: 'Blame previous administration',
        description: '+5K Attention, -5 Legitimacy',
        effects: [
          { resource: 'attention', amount: 5000, type: 'add' },
          { resource: 'legitimacy', amount: -5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'orbitalIndustry', operator: '>=', value: 30 }],
    cooldown: 300,
  },

  {
    id: 'p4_dyson_proposal',
    phase: 4,
    category: 'opportunity',
    headline: 'SCIENTISTS PROPOSE Dyson Swarm. "The sun is just sitting there, doing nothing useful."',
    context: 'Your lead scientist presents a plan to harvest solar energy on a stellar scale. The PowerPoint is 300 slides. All of them have your logo.',
    choices: [
      {
        label: 'Approve and fund immediately',
        description: '-20M Cash, +20 Orbital Industry',
        effects: [
          { resource: 'cash', amount: -20_000_000, type: 'add' },
          { resource: 'orbitalIndustry', amount: 20, type: 'add' },
        ],
      },
      {
        label: '"Only if we name the sun"',
        description: '+30K Attention, dubious',
        effects: [
          { resource: 'attention', amount: 30_000, type: 'add' },
          { resource: 'realityDrift', amount: 0.5, type: 'add' },
        ],
      },
      {
        label: 'Militarize it',
        description: '+5K War Output, +100 Fear, -15 Legitimacy',
        effects: [
          { resource: 'warOutput', amount: 5000, type: 'add' },
          { resource: 'fear', amount: 100, type: 'add' },
          { resource: 'legitimacy', amount: -15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'orbitalIndustry', operator: '>=', value: 60 }],
    unique: true,
  },
]
