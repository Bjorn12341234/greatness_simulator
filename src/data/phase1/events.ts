import type { GameEvent } from '../../store/types'

export const PHASE1_EVENTS: GameEvent[] = [
  // ── Scandals ──
  {
    id: 'p1_scandal_tweet',
    phase: 1,
    category: 'scandal',
    headline: 'Controversial Tweet Goes Viral',
    context: 'A late-night post sparks international outrage. The algorithm is feeding.',
    choices: [
      {
        label: 'Double Down',
        description: 'More attention, less credibility',
        effects: [
          { resource: 'attention', amount: 50, type: 'add' },
          { resource: 'greatness', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Issue Non-Apology',
        description: '"I\'m sorry you were offended"',
        effects: [
          { resource: 'attention', amount: 20, type: 'add' },
          { resource: 'greatness', amount: 2, type: 'add' },
        ],
      },
    ],
  },
  {
    id: 'p1_scandal_tax',
    phase: 1,
    category: 'scandal',
    headline: 'Tax Records Surface Online',
    context: 'Someone leaked financial documents. The numbers are... creative.',
    choices: [
      {
        label: '"Smart Business"',
        description: 'Spin it as genius',
        effects: [
          { resource: 'attention', amount: 40, type: 'add' },
          { resource: 'cash', amount: 50, type: 'add' },
        ],
      },
      {
        label: 'Threaten Lawsuit',
        description: 'Fear is a resource',
        effects: [
          { resource: 'attention', amount: 30, type: 'add' },
          { resource: 'influence', amount: 10, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'clickCount', operator: '>=', value: 20 }],
  },
  {
    id: 'p1_scandal_ghostwriter',
    phase: 1,
    category: 'scandal',
    headline: 'Ghostwriter Reveals All',
    context: 'The person who actually wrote your bestseller is doing interviews.',
    choices: [
      {
        label: 'Deny Everything',
        description: 'Who are you going to believe?',
        effects: [
          { resource: 'attention', amount: 60, type: 'add' },
        ],
      },
      {
        label: 'Sue for NDA Violation',
        description: 'Legal intimidation works',
        effects: [
          { resource: 'cash', amount: -20, type: 'add' },
          { resource: 'influence', amount: 15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'greatness', operator: '>=', value: 20 }],
  },

  // ── Opportunities ──
  {
    id: 'p1_opp_rally',
    phase: 1,
    category: 'opportunity',
    headline: 'Rally Opportunity',
    context: 'A venue just opened up. Time to give the people what they want.',
    choices: [
      {
        label: 'Pack the Arena',
        description: 'Maximum crowd, maximum attention',
        effects: [
          { resource: 'attention', amount: 80, type: 'add' },
          { resource: 'greatness', amount: 10, type: 'add' },
        ],
      },
      {
        label: 'Intimate Fundraiser',
        description: 'Less spectacle, more donations',
        effects: [
          { resource: 'cash', amount: 100, type: 'add' },
          { resource: 'attention', amount: 20, type: 'add' },
        ],
      },
    ],
  },
  {
    id: 'p1_opp_endorsement',
    phase: 1,
    category: 'opportunity',
    headline: 'Celebrity Endorsement Offer',
    context: 'A reality TV star wants to publicly support the brand. Very on-brand.',
    choices: [
      {
        label: 'Accept Gladly',
        description: 'Free publicity',
        effects: [
          { resource: 'attention', amount: 100, type: 'add' },
          { resource: 'greatness', amount: 8, type: 'add' },
        ],
      },
      {
        label: 'Demand Payment',
        description: 'Nothing is free in this game',
        effects: [
          { resource: 'cash', amount: 75, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'attention', operator: '>=', value: 50 }],
  },
  {
    id: 'p1_opp_book_deal',
    phase: 1,
    category: 'opportunity',
    headline: 'Book Deal on the Table',
    context: 'A publisher wants your name on a new title. Content optional.',
    choices: [
      {
        label: 'Cash Advance',
        description: 'Take the money upfront',
        effects: [
          { resource: 'cash', amount: 200, type: 'add' },
        ],
      },
      {
        label: 'Publicity Blitz',
        description: 'Book tour generates attention',
        effects: [
          { resource: 'attention', amount: 120, type: 'add' },
          { resource: 'greatness', amount: 15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'greatness', operator: '>=', value: 10 }],
  },
  {
    id: 'p1_opp_merch_viral',
    phase: 1,
    category: 'opportunity',
    headline: 'Merchandise Goes Viral',
    context: 'Your branded products are trending on social media. Everyone wants one.',
    choices: [
      {
        label: 'Limited Edition Drop',
        description: 'Scarcity creates demand',
        effects: [
          { resource: 'cash', amount: 150, type: 'add' },
          { resource: 'attention', amount: 40, type: 'add' },
        ],
      },
      {
        label: 'Mass Production',
        description: 'Flood the market',
        effects: [
          { resource: 'cash', amount: 80, type: 'add' },
          { resource: 'attention', amount: 80, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'attention', operator: '>=', value: 100 }],
  },

  // ── Absurd ──
  {
    id: 'p1_absurd_covfefe',
    phase: 1,
    category: 'absurd',
    headline: 'Mysterious Post Baffles Internet',
    context: 'You posted a single incomprehensible word at 3 AM. It\'s now a movement.',
    choices: [
      {
        label: '"Meant Every Word"',
        description: 'Own the mystery',
        effects: [
          { resource: 'attention', amount: 70, type: 'add' },
          { resource: 'greatness', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Sell the Merchandise',
        description: 'Put it on a hat',
        effects: [
          { resource: 'cash', amount: 60, type: 'add' },
          { resource: 'attention', amount: 30, type: 'add' },
        ],
      },
    ],
  },
  {
    id: 'p1_absurd_steak',
    phase: 1,
    category: 'absurd',
    headline: 'Steak Brand Controversy',
    context: 'Food critics unanimously pan your branded steaks. Sales are through the roof.',
    choices: [
      {
        label: '"Best Steaks, Believe Me"',
        description: 'Critics don\'t know real food',
        effects: [
          { resource: 'cash', amount: 40, type: 'add' },
          { resource: 'attention', amount: 50, type: 'add' },
        ],
      },
      {
        label: 'Challenge Critics to Taste Test',
        description: 'Content goldmine',
        effects: [
          { resource: 'attention', amount: 90, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'clickCount', operator: '>=', value: 30 }],
  },
  {
    id: 'p1_absurd_impersonator',
    phase: 1,
    category: 'absurd',
    headline: 'Professional Impersonator Goes Viral',
    context: 'Someone is impersonating you so well that even supporters are confused.',
    choices: [
      {
        label: 'Hire Them',
        description: 'Two of you = twice the attention',
        effects: [
          { resource: 'attention', amount: 60, type: 'add' },
          { resource: 'cash', amount: -30, type: 'add' },
        ],
      },
      {
        label: 'Sue Them',
        description: 'There can only be one',
        effects: [
          { resource: 'influence', amount: 10, type: 'add' },
          { resource: 'cash', amount: -15, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'attention', operator: '>=', value: 200 }],
  },

  // ── Contradictions ──
  {
    id: 'p1_contra_billionaire_populist',
    phase: 1,
    category: 'contradiction',
    headline: 'Billionaire Populism Questioned',
    context: 'A reporter asks how a gold-penthouse dweller understands working families.',
    choices: [
      {
        label: '"I Eat McDonald\'s"',
        description: 'Relatable! Just like you!',
        effects: [
          { resource: 'attention', amount: 50, type: 'add' },
          { resource: 'greatness', amount: 3, type: 'add' },
        ],
      },
      {
        label: 'Attack the Reporter',
        description: 'The best defense',
        effects: [
          { resource: 'attention', amount: 70, type: 'add' },
          { resource: 'influence', amount: 5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'cash', operator: '>=', value: 50 }],
  },
  {
    id: 'p1_contra_freedom_censorship',
    phase: 1,
    category: 'contradiction',
    headline: 'Free Speech Champion Blocks Critics',
    context: 'Your "free speech" platform is suspending accounts that disagree with you.',
    choices: [
      {
        label: '"Maintaining Standards"',
        description: 'Free speech doesn\'t mean consequence-free speech',
        effects: [
          { resource: 'influence', amount: 15, type: 'add' },
          { resource: 'attention', amount: 20, type: 'add' },
        ],
      },
      {
        label: 'Unblock Everyone',
        description: 'The algorithm will bury them anyway',
        effects: [
          { resource: 'attention', amount: 40, type: 'add' },
          { resource: 'greatness', amount: 5, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'greatness', operator: '>=', value: 50 }],
  },

  // ── Crisis ──
  {
    id: 'p1_crisis_investigation',
    phase: 1,
    category: 'crisis',
    headline: 'Federal Investigation Announced',
    context: 'Authorities are looking into your business practices. This could be trouble.',
    choices: [
      {
        label: '"Witch Hunt!"',
        description: 'Rally the base around persecution',
        effects: [
          { resource: 'attention', amount: 150, type: 'add' },
          { resource: 'cash', amount: -50, type: 'add' },
          { resource: 'greatness', amount: 20, type: 'add' },
        ],
      },
      {
        label: 'Cooperate Quietly',
        description: 'Boring but safe',
        effects: [
          { resource: 'cash', amount: -100, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'greatness', operator: '>=', value: 100 }],
  },
  {
    id: 'p1_crisis_lawsuit',
    phase: 1,
    category: 'crisis',
    headline: 'Class Action Lawsuit Filed',
    context: 'Former "university" students want their money back. How unreasonable.',
    choices: [
      {
        label: 'Settle Quietly',
        description: 'Make it go away',
        effects: [
          { resource: 'cash', amount: -75, type: 'add' },
        ],
      },
      {
        label: 'Counter-Sue',
        description: 'Offense is the best defense',
        effects: [
          { resource: 'attention', amount: 60, type: 'add' },
          { resource: 'cash', amount: -30, type: 'add' },
          { resource: 'influence', amount: 10, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'attention', operator: '>=', value: 300 }],
  },

  // ── More Opportunities (to reach 15+) ──
  {
    id: 'p1_opp_podcast',
    phase: 1,
    category: 'opportunity',
    headline: 'Podcast Appearance Invite',
    context: 'The #1 podcast wants you on. Three hours of unfiltered conversation.',
    choices: [
      {
        label: 'Go Long',
        description: 'Three hours of pure content',
        effects: [
          { resource: 'attention', amount: 200, type: 'add' },
          { resource: 'greatness', amount: 25, type: 'add' },
        ],
      },
      {
        label: 'Counter-Offer: Your Platform Only',
        description: 'Drive traffic to your platform',
        effects: [
          { resource: 'attention', amount: 80, type: 'add' },
          { resource: 'influence', amount: 20, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'greatness', operator: '>=', value: 30 }],
  },
  {
    id: 'p1_opp_meme',
    phase: 1,
    category: 'opportunity',
    headline: 'You\'ve Become a Meme',
    context: 'The internet has turned your latest gaffe into a viral meme format.',
    choices: [
      {
        label: 'Embrace It',
        description: 'Post the meme yourself',
        effects: [
          { resource: 'attention', amount: 100, type: 'add' },
          { resource: 'greatness', amount: 8, type: 'add' },
        ],
      },
      {
        label: 'Copyright Claim Everything',
        description: 'Your face, your rules',
        effects: [
          { resource: 'cash', amount: 30, type: 'add' },
          { resource: 'influence', amount: 10, type: 'add' },
        ],
      },
    ],
  },
  {
    id: 'p1_absurd_gold_toilet',
    phase: 1,
    category: 'absurd',
    headline: 'Gold Toilet Photo Leaks',
    context: 'Paparazzi captured your bathroom renovation. It\'s... golden.',
    choices: [
      {
        label: '"That\'s Called Success"',
        description: 'If you\'ve got it, flush it',
        effects: [
          { resource: 'attention', amount: 80, type: 'add' },
          { resource: 'greatness', amount: 5, type: 'add' },
        ],
      },
      {
        label: 'Launch Gold Bathroom Line',
        description: 'If they want it, sell it',
        effects: [
          { resource: 'cash', amount: 120, type: 'add' },
          { resource: 'attention', amount: 40, type: 'add' },
        ],
      },
    ],
    conditions: [{ resource: 'cash', operator: '>=', value: 100 }],
  },
]
