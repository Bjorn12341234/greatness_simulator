import Foundation

let phase4Events: [GameEvent] = [
    GameEvent(
        id: "p4_colonist_revolt",
        phase: 4,
        category: .crisis,
        headline: "BREAKING: Mars colonists demand \"basic rights.\" Outrageous.",
        context: "The colonists want healthcare, breathable air, and a say in governance. This is exactly the kind of short-term thinking the Long-Term Thinking Simulator was supposed to prevent.",
        choices: [
            EventChoice(label: "Grant limited rights", effects: [
                Effect(resource: "legitimacy", amount: 10),
                Effect(resource: "cash", amount: -2_000_000),
                Effect(resource: "colonists", amount: 5),
            ], description: "+10 Legitimacy, -2M Cash, colonist morale boost"),
            EventChoice(label: "\"Rights are an Earth concept\"", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "attention", amount: 10_000),
                Effect(resource: "realityDrift", amount: 0.5),
            ], description: "-15 Legitimacy, +10K Attention"),
            EventChoice(label: "Replace colonists with drones", effects: [
                Effect(resource: "colonists", amount: -20),
                Effect(resource: "orbitalIndustry", amount: 5),
            ], description: "-20 Colonists, +5 Orbital Industry"),
        ],
        conditions: [EventCondition(resource: "colonists", op: .gte, value: 10)],
        cooldown: 300
    ),

    GameEvent(
        id: "p4_greatium_discovery",
        phase: 4,
        category: .opportunity,
        headline: "SCIENTISTS DISCOVER NEW ELEMENT: Dubbed \"Greatium\" by naming committee.",
        context: "Asteroid miners found an element that doesn't exist on Earth. The naming rights were auctioned. You won.",
        choices: [
            EventChoice(label: "Patent it immediately", effects: [
                Effect(resource: "cash", amount: 5_000_000),
                Effect(resource: "nobelScore", amount: -10),
            ], description: "+5M Cash, -10 Nobel"),
            EventChoice(label: "Fund research", effects: [
                Effect(resource: "nobelScore", amount: 20),
                Effect(resource: "orbitalIndustry", amount: 10),
            ], description: "+20 Nobel, +10 Orbital Industry"),
            EventChoice(label: "Weaponize it", effects: [
                Effect(resource: "warOutput", amount: 3000),
                Effect(resource: "fear", amount: 50),
                Effect(resource: "realityDrift", amount: 0.3),
            ], description: "+3K War Output, +50 Fear"),
        ],
        conditions: [EventCondition(resource: "miningOutput", op: .gte, value: 20)],
        unique: true
    ),

    GameEvent(
        id: "p4_alien_signal",
        phase: 4,
        category: .absurd,
        headline: "DEEP SPACE ARRAY detects possible alien signal. Contains what appears to be a complaint.",
        context: "The signal translates roughly to: \"Please stop. Your propaganda satellites are interfering with our frequencies.\" First contact is going great.",
        choices: [
            EventChoice(label: "Reply with friendship message", effects: [
                Effect(resource: "nobelScore", amount: 30),
                Effect(resource: "attention", amount: 20_000),
            ], description: "+30 Nobel, +20K Attention"),
            EventChoice(label: "\"Alien market = new customers\"", effects: [
                Effect(resource: "cash", amount: 10_000_000),
                Effect(resource: "legitimacy", amount: -20),
            ], description: "+10M Cash, -20 Legitimacy"),
            EventChoice(label: "Aim the Diplomatic Railgun at the signal", effects: [
                Effect(resource: "fear", amount: 100),
                Effect(resource: "warOutput", amount: 5000),
                Effect(resource: "realityDrift", amount: 1),
            ], description: "+100 Fear, +5K War Output"),
        ],
        conditions: [EventCondition(resource: "orbitalIndustry", op: .gte, value: 50)],
        unique: true
    ),

    GameEvent(
        id: "p4_launch_failure",
        phase: 4,
        category: .crisis,
        headline: "LAUNCH FAILURE: Greatness Rocket explodes on pad. \"Planned rapid disassembly.\"",
        context: "The rocket was branded before it was tested. Branding survived the explosion. Engineering did not.",
        choices: [
            EventChoice(label: "Fund investigation", effects: [
                Effect(resource: "cash", amount: -3_000_000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-3M Cash, +5 Legitimacy"),
            EventChoice(label: "\"Planned rapid disassembly\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "realityDrift", amount: 0.2),
            ], description: "-10 Legitimacy, +5K Attention"),
            EventChoice(label: "Blame contractor, build faster", effects: [
                Effect(resource: "cash", amount: -1_000_000),
                Effect(resource: "rocketMass", amount: 10),
            ], description: "-1M Cash, +10 Rocket Mass"),
        ],
        cooldown: 240
    ),

    GameEvent(
        id: "p4_mars_dust_storm",
        phase: 4,
        category: .crisis,
        headline: "MARS DUST STORM threatens colony. Colonists shelter in branded bunkers.",
        context: "The bunker walls are covered in motivational posters. \"Breathe Greatness\" hits different when there's no air.",
        choices: [
            EventChoice(label: "Emergency supply drop", effects: [
                Effect(resource: "cash", amount: -5_000_000),
                Effect(resource: "colonists", amount: 5),
            ], description: "-5M Cash, +5 Colonists"),
            EventChoice(label: "\"Natural selection in action\"", effects: [
                Effect(resource: "colonists", amount: -10),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "-10 Colonists, -15 Legitimacy"),
            EventChoice(label: "Rebrand it \"Character Building Weather\"", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "realityDrift", amount: 0.3),
            ], description: "-5 Legitimacy, dubious"),
        ],
        conditions: [EventCondition(resource: "colonists", op: .gte, value: 5)],
        cooldown: 300
    ),

    GameEvent(
        id: "p4_asteroid_dispute",
        phase: 4,
        category: .scandal,
        headline: "JADE EMPIRE claims asteroid belt mining rights. Presents ancient star maps.",
        context: "They claim their ancestors mapped the asteroids first. The maps are clearly from 2024.",
        choices: [
            EventChoice(label: "Share mining rights", effects: [
                Effect(resource: "legitimacy", amount: 15),
                Effect(resource: "miningOutput", amount: -50),
            ], description: "+15 Legitimacy, -50 Mining Output"),
            EventChoice(label: "\"First come, first mine\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "fear", amount: 30),
            ], description: "-10 Legitimacy, +30 Fear"),
            EventChoice(label: "Counter-claim with \"ancient\" tweet", effects: [
                Effect(resource: "attention", amount: 15_000),
                Effect(resource: "realityDrift", amount: 0.2),
            ], description: "+15K Attention, dubious"),
        ],
        conditions: [EventCondition(resource: "miningOutput", op: .gte, value: 10)],
        cooldown: 300
    ),

    GameEvent(
        id: "p4_space_tourism",
        phase: 4,
        category: .opportunity,
        headline: "SPACE TOURISM DEMAND surges. Billionaires want branded orbital selfies.",
        context: "They'll pay $10M each to float in zero gravity with your logo in the background. The brand exposure is literally cosmic.",
        choices: [
            EventChoice(label: "Launch tourism program", effects: [
                Effect(resource: "cash", amount: 15_000_000),
                Effect(resource: "attention", amount: 20_000),
            ], description: "+15M Cash, +20K Attention"),
            EventChoice(label: "Mandatory \"Greatness Experience\"", effects: [
                Effect(resource: "cash", amount: 8_000_000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+8M Cash, +5 Legitimacy"),
            EventChoice(label: "Military-only flights", effects: [
                Effect(resource: "orbitalIndustry", amount: 5),
                Effect(resource: "warOutput", amount: 1000),
            ], description: "+5 Orbital Industry, +1K War Output"),
        ],
        cooldown: 240
    ),

    GameEvent(
        id: "p4_lunar_heritage_vandalism",
        phase: 4,
        category: .absurd,
        headline: "VANDALS at Lunar Heritage Site replace original Apollo flag with golden one.",
        context: "Wait — that was you. You ordered that. The \"vandals\" were your employees.",
        choices: [
            EventChoice(label: "\"History is being updated\"", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "realityDrift", amount: 0.3),
            ], description: "+5K Attention, dubious"),
            EventChoice(label: "Deny everything", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "attention", amount: 10_000),
            ], description: "-5 Legitimacy, +10K Attention"),
            EventChoice(label: "Sell the original flag at auction", effects: [
                Effect(resource: "cash", amount: 2_000_000),
                Effect(resource: "legitimacy", amount: -10),
            ], description: "+2M Cash, -10 Legitimacy"),
        ],
        unique: true
    ),

    GameEvent(
        id: "p4_satellite_hack",
        phase: 4,
        category: .crisis,
        headline: "PROPAGANDA SATELLITES HACKED: Now broadcasting \"actual news.\" Crisis mode.",
        context: "Someone reprogrammed your satellites to broadcast facts. The horror. Legitimacy is spiking because people trust the satellites now — but the wrong kind of trust.",
        choices: [
            EventChoice(label: "Retake control immediately", effects: [
                Effect(resource: "cash", amount: -5_000_000),
            ], description: "-5M Cash, restore normal propaganda"),
            EventChoice(label: "\"We meant to do that\"", effects: [
                Effect(resource: "legitimacy", amount: 10),
                Effect(resource: "realityDrift", amount: -0.5),
            ], description: "+10 Legitimacy, -0.5 Drift"),
            EventChoice(label: "Arrest the hackers, double the propaganda", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "fear", amount: 50),
                Effect(resource: "attention", amount: 5000),
            ], description: "-10 Legitimacy, +50 Fear, +5K Attention"),
        ],
        conditions: [EventCondition(resource: "orbitalIndustry", op: .gte, value: 20)],
        cooldown: 300
    ),

    GameEvent(
        id: "p4_mars_renaming",
        phase: 4,
        category: .absurd,
        headline: "MARS OFFICIALLY RENAMED: Scientists weep. Branding team celebrates.",
        context: "The International Astronomical Union has been replaced by the International Greatness Union. Mars is now \"The Orange Planet.\" Olympus Mons is \"Victory Peak.\"",
        choices: [
            EventChoice(label: "Mandate new textbooks", effects: [
                Effect(resource: "attention", amount: 20_000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+20K Attention, +5 Legitimacy"),
            EventChoice(label: "Sell naming rights to features", effects: [
                Effect(resource: "cash", amount: 10_000_000),
            ], description: "+10M Cash"),
            EventChoice(label: "\"The planet wanted this\"", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "attention", amount: 30_000),
                Effect(resource: "realityDrift", amount: 0.5),
            ], description: "-5 Legitimacy, +30K Attention, dubious"),
        ],
        conditions: [EventCondition(resource: "terraformProgress", op: .gte, value: 25)],
        unique: true
    ),

    GameEvent(
        id: "p4_space_debris",
        phase: 4,
        category: .crisis,
        headline: "SPACE DEBRIS CRISIS: Kessler syndrome threatens orbital operations.",
        context: "All those rushed launches left a mess. Debris is colliding with debris. Your insurance company has stopped returning calls.",
        choices: [
            EventChoice(label: "Fund cleanup mission", effects: [
                Effect(resource: "cash", amount: -8_000_000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-8M Cash, protect infrastructure"),
            EventChoice(label: "\"Debris is just unmined resources\"", effects: [
                Effect(resource: "miningOutput", amount: 5),
                Effect(resource: "realityDrift", amount: 0.3),
            ], description: "+5 Mining Output, dubious"),
            EventChoice(label: "Blame previous administration", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+5K Attention, -5 Legitimacy"),
        ],
        conditions: [EventCondition(resource: "orbitalIndustry", op: .gte, value: 30)],
        cooldown: 300
    ),

    GameEvent(
        id: "p4_dyson_proposal",
        phase: 4,
        category: .opportunity,
        headline: "SCIENTISTS PROPOSE Dyson Swarm. \"The sun is just sitting there, doing nothing useful.\"",
        context: "Your lead scientist presents a plan to harvest solar energy on a stellar scale. The PowerPoint is 300 slides. All of them have your logo.",
        choices: [
            EventChoice(label: "Approve and fund immediately", effects: [
                Effect(resource: "cash", amount: -20_000_000),
                Effect(resource: "orbitalIndustry", amount: 20),
            ], description: "-20M Cash, +20 Orbital Industry"),
            EventChoice(label: "\"Only if we name the sun\"", effects: [
                Effect(resource: "attention", amount: 30_000),
                Effect(resource: "realityDrift", amount: 0.5),
            ], description: "+30K Attention, dubious"),
            EventChoice(label: "Militarize it", effects: [
                Effect(resource: "warOutput", amount: 5000),
                Effect(resource: "fear", amount: 100),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "+5K War Output, +100 Fear, -15 Legitimacy"),
        ],
        conditions: [EventCondition(resource: "orbitalIndustry", op: .gte, value: 60)],
        unique: true
    ),
]
