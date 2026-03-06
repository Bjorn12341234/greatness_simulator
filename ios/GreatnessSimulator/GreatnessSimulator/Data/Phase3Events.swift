import Foundation

let phase3Events: [GameEvent] = [
    // Trouble in the Oil Republic (original)
    GameEvent(
        id: "p3_oil_republic_zahran",
        phase: 3,
        category: .crisis,
        headline: "Trouble in the Oil Republic",
        context: "Reports from the Oil Republic of Zahran: wealthy but unstable, sitting on enormous energy reserves. Your intelligence agency insists this threatens \"regional stability.\"",
        choices: [
            EventChoice(label: "Launch a Narrative Campaign", effects: [
                Effect(resource: "influence", amount: 500),
                Effect(resource: "attention", amount: 1000),
                Effect(resource: "legitimacy", amount: -8),
            ], description: "+500 Influence, +1K Attention, -8 Legitimacy"),
            EventChoice(label: "Quiet Economic Pressure", effects: [
                Effect(resource: "influence", amount: 300),
                Effect(resource: "sanctions", amount: 200),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+300 Influence, +200 Sanctions, -5 Legitimacy"),
            EventChoice(label: "Ignore the Situation", effects: [
                Effect(resource: "legitimacy", amount: 10),
                Effect(resource: "influence", amount: -200),
            ], description: "+10 Legitimacy, -200 Influence"),
        ],
        conditions: [EventCondition(resource: "influence", op: .gte, value: 100)],
        cooldown: 600,
        unique: true
    ),

    // Nobel Prize Events
    GameEvent(
        id: "p3_nobel_nomination",
        phase: 3,
        category: .nobel,
        headline: "BREAKING: Orange Man nominated for Nobel Peace Prize.",
        context: "The Nobel Committee has taken notice of your \"peace-building efforts.\" You are currently running multiple military operations.",
        choices: [
            EventChoice(label: "Run Peace Summit", effects: [
                Effect(resource: "nobelScore", amount: 200),
                Effect(resource: "warOutput", amount: -500),
            ], description: "+200 Nobel, -500 War Output"),
            EventChoice(label: "Accept while launching op", effects: [
                Effect(resource: "nobelScore", amount: 100),
                Effect(resource: "warOutput", amount: 200),
                Effect(resource: "realityDrift", amount: 0.05),
            ], description: "+100 Nobel, +200 War Output, dubious"),
            EventChoice(label: "Ignore nomination", effects: [
                Effect(resource: "warOutput", amount: 500),
                Effect(resource: "nobelScore", amount: -100),
            ], description: "+500 War Output, -100 Nobel"),
        ],
        conditions: [EventCondition(resource: "nobelScore", op: .gte, value: 30)],
        cooldown: 300
    ),

    // Warship Leak
    GameEvent(
        id: "p3_warship_leak",
        phase: 3,
        category: .scandal,
        headline: "LEAK: Orange Class Warship blueprint is literally a gold yacht.",
        context: "Internal documents show the Golden Dreadnought is just a luxury yacht with cannons bolted on. The internet is having a field day.",
        choices: [
            EventChoice(label: "Deny the leak", effects: [
                Effect(resource: "legitimacy", amount: -10),
            ], description: "-10 Legitimacy"),
            EventChoice(label: "\"Luxury Deterrence Vessel\"", effects: [
                Effect(resource: "cash", amount: -50000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-50K Cash, +5 Legitimacy"),
            EventChoice(label: "Arrest the leaker", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "loyalty", amount: 200),
            ], description: "-15 Legitimacy, +200 Loyalty"),
        ],
        unique: true
    ),

    // Coalition Condemnation
    GameEvent(
        id: "p3_coalition_condemns",
        phase: 3,
        category: .crisis,
        headline: "COALITION OF NATIONS condemns recent Freedom Operation.",
        context: "Multiple countries are calling for sanctions and an emergency UN session. Your diplomats are sweating.",
        choices: [
            EventChoice(label: "Issue apology", effects: [
                Effect(resource: "legitimacy", amount: 15),
                Effect(resource: "warOutput", amount: -500),
            ], description: "+15 Legitimacy, -500 War Output"),
            EventChoice(label: "Sanction the coalition", effects: [
                Effect(resource: "legitimacy", amount: -20),
                Effect(resource: "fear", amount: 15),
            ], description: "-20 Legitimacy, assert dominance"),
            EventChoice(label: "Invite them to a summit", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "nobelScore", amount: 50),
                Effect(resource: "legitimacy", amount: 10),
            ], description: "-100K Cash, +50 Nobel, +10 Legitimacy"),
        ],
        conditions: [EventCondition(resource: "fear", op: .gte, value: 20)],
        cooldown: 180
    ),

    // Refugee Crisis
    GameEvent(
        id: "p3_refugees_arrive",
        phase: 3,
        category: .crisis,
        headline: "REFUGEES from Freedom Operation arrive at borders.",
        context: "The wars you started have displaced millions. What an inconvenience.",
        choices: [
            EventChoice(label: "Accept refugees", effects: [
                Effect(resource: "legitimacy", amount: 20),
                Effect(resource: "nobelScore", amount: 100),
                Effect(resource: "cash", amount: -10000),
            ], description: "+20 Legit, +100 Nobel, -10K Cash"),
            EventChoice(label: "\"Greatness Welcome Centers\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "nobelScore", amount: -50),
                Effect(resource: "cash", amount: 5000),
            ], description: "-10 Legit, -50 Nobel, +5K Cash"),
            EventChoice(label: "\"Freedom Seekers\" rebrand", effects: [
                Effect(resource: "legitimacy", amount: 5),
                Effect(resource: "nobelScore", amount: 30),
                Effect(resource: "realityDrift", amount: 0.02),
            ], description: "+5 Legit, +30 Nobel, dubious"),
        ],
        cooldown: 240
    ),

    // Frostheim Special
    GameEvent(
        id: "p3_frostheim_not_for_sale",
        phase: 3,
        category: .absurd,
        headline: "FROSTHEIM PRIME MINISTER: \"We are not for sale.\"",
        context: "You offered to buy an entire country. They said no. Again. The internet is confused about whether this is satire.",
        choices: [
            EventChoice(label: "Increase the offer", effects: [
                Effect(resource: "cash", amount: -500000),
                Effect(resource: "attention", amount: 15000),
            ], description: "-500K Cash, reduce resistance"),
            EventChoice(label: "Send \"research vessels\"", effects: [
                Effect(resource: "warOutput", amount: 500),
                Effect(resource: "fear", amount: 10),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+500 War Output, +10 Fear"),
            EventChoice(label: "Tweet about it", effects: [
                Effect(resource: "attention", amount: 25000),
                Effect(resource: "realityDrift", amount: 0.01),
            ], description: "+25K Attention, dubious"),
        ],
        cooldown: 300
    ),

    // Eurovia Refugee Wave
    GameEvent(
        id: "p3_eurovia_overwhelmed",
        phase: 3,
        category: .opportunity,
        headline: "EUROVIA OVERWHELMED: Refugee wave from Sand Republic destabilizes coalition.",
        context: "The wars you started in the Middle East have sent refugees to Eurovia. Their unity is cracking. How convenient.",
        choices: [
            EventChoice(label: "Offer humanitarian aid", effects: [
                Effect(resource: "nobelScore", amount: 20),
                Effect(resource: "cash", amount: -50000),
            ], description: "+20 Nobel, -50K Cash"),
            EventChoice(label: "\"Eurovia has lost its way\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "fear", amount: 5),
            ], description: "-10 Legitimacy, weaken them"),
            EventChoice(label: "\"Greatness Stability Pact\"", effects: [
                Effect(resource: "legitimacy", amount: 10),
                Effect(resource: "realityDrift", amount: 0.02),
            ], description: "+10 Legit (you caused this)"),
        ],
        cooldown: 240
    ),

    // Maple Federation Trade
    GameEvent(
        id: "p3_maple_trade_deficit",
        phase: 3,
        category: .opportunity,
        headline: "MAPLE FEDERATION TRADE DEFICIT hits historic low.",
        context: "Your trade integration strategy is working perfectly. Their economy is becoming dependent on yours.",
        choices: [
            EventChoice(label: "Offer bailout (with conditions)", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-100K Cash, +5 Legitimacy"),
            EventChoice(label: "\"They need us more than we need them\"", effects: [
                Effect(resource: "attention", amount: 5000),
            ], description: "+5K Attention, provoke them"),
            EventChoice(label: "Propose currency union", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "nobelScore", amount: -10),
            ], description: "-5 Legitimacy, absorption step"),
        ],
        cooldown: 300
    ),

    // Tundra Republic Alliance
    GameEvent(
        id: "p3_tundra_alliance",
        phase: 3,
        category: .absurd,
        headline: "TUNDRA REPUBLIC LEADER: \"Our alliance has never been stronger.\"",
        context: "He says this while you build your 5th military base on his border. The cognitive dissonance is palpable.",
        choices: [
            EventChoice(label: "Agree publicly, build base", effects: [
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+5 Legitimacy, +15% encirclement"),
            EventChoice(label: "Joint exercise (on their border)", effects: [
                Effect(resource: "warOutput", amount: 2000),
            ], description: "+2K War Output"),
            EventChoice(label: "Gift a golden telephone", effects: [
                Effect(resource: "attention", amount: 1000),
                Effect(resource: "legitimacy", amount: 3),
            ], description: "+1K Attention, +3 Legitimacy"),
        ],
        cooldown: 300
    ),

    // Petro Republic Opposition
    GameEvent(
        id: "p3_petro_opposition",
        phase: 3,
        category: .opportunity,
        headline: "PETRO REPUBLIC OPPOSITION asks for \"support.\" Wink.",
        context: "A rebel leader is asking for funding, weapons, and \"election observers\" (who happen to be special forces).",
        choices: [
            EventChoice(label: "Fund them secretly", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "nobelScore", amount: -5),
            ], description: "-100K Cash, -5 Nobel"),
            EventChoice(label: "Fund them openly (\"democracy!\")", effects: [
                Effect(resource: "cash", amount: -200000),
                Effect(resource: "nobelScore", amount: 10),
            ], description: "-200K Cash, +10 Nobel"),
            EventChoice(label: "Send \"election observers\"", effects: [
                Effect(resource: "legitimacy", amount: -20),
                Effect(resource: "fear", amount: 15),
            ], description: "-20 Legitimacy, very effective"),
        ],
        cooldown: 240
    ),

    // Canal Isthmus Fees
    GameEvent(
        id: "p3_canal_fees",
        phase: 3,
        category: .crisis,
        headline: "CANAL ISTHMUS THREATENS to raise transit fees.",
        context: "A tiny nation just realized they have leverage. Time to explain how leverage really works.",
        choices: [
            EventChoice(label: "Negotiate", effects: [
                Effect(resource: "cash", amount: -50000),
            ], description: "-50K Cash, status quo"),
            EventChoice(label: "Economic pressure", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "fear", amount: 5),
            ], description: "-5 Legitimacy"),
            EventChoice(label: "Station carrier group \"nearby\"", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "fear", amount: 20),
            ], description: "-15 Legit, +20 Fear"),
        ],
        cooldown: 240
    ),

    // Azure State Demands
    GameEvent(
        id: "p3_azure_demands",
        phase: 3,
        category: .crisis,
        headline: "AZURE STATE \"reminds\" you about Eddstein's Isle. Requests increased aid.",
        context: "They have the files. You have the nukes. This dance continues.",
        choices: [
            EventChoice(label: "Comply and increase aid", effects: [
                Effect(resource: "cash", amount: -200000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-200K Cash, keep the secret"),
            EventChoice(label: "Refuse and threaten", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "fear", amount: 10),
                Effect(resource: "loyalty", amount: -50),
            ], description: "-15 Legitimacy, assert power"),
            EventChoice(label: "\"What files?\"", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "realityDrift", amount: 0.03),
            ], description: "+5K Attention, dubious"),
        ],
        cooldown: 300
    ),

    // Freedom Foundation Backlash
    GameEvent(
        id: "p3_ngo_backlash",
        phase: 3,
        category: .scandal,
        headline: "INVESTIGATION: \"Freedom Foundations\" linked to cultural erosion programs.",
        context: "Someone noticed that your NGOs are destroying cultures instead of helping them. Shocking.",
        choices: [
            EventChoice(label: "\"They were already weak\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "attention", amount: 5000),
            ], description: "-10 Legitimacy, +5K Attention"),
            EventChoice(label: "Rebrand to \"Heritage Partners\"", effects: [
                Effect(resource: "cash", amount: -30000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-30K Cash, +5 Legitimacy"),
            EventChoice(label: "Double down on \"development\"", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "nobelScore", amount: 20),
            ], description: "-5 Legitimacy, +20 Nobel"),
        ],
        cooldown: 240
    ),

    // Peace Summit Opportunity
    GameEvent(
        id: "p3_peace_summit",
        phase: 3,
        category: .opportunity,
        headline: "Opportunity: Host a \"World Peace Summit\" at the Golden Resort.",
        context: "A photo op with world leaders at your branded resort. The optics are incredible. The sincerity is zero.",
        choices: [
            EventChoice(label: "Host the summit", effects: [
                Effect(resource: "cash", amount: -500000),
                Effect(resource: "nobelScore", amount: 150),
                Effect(resource: "legitimacy", amount: 20),
            ], description: "-500K Cash, +150 Nobel, +20 Legit"),
            EventChoice(label: "Host + announce arms deal", effects: [
                Effect(resource: "cash", amount: -200000),
                Effect(resource: "nobelScore", amount: 80),
                Effect(resource: "warOutput", amount: 500),
            ], description: "-200K, +80 Nobel, +500 War"),
            EventChoice(label: "Skip it. More ships.", effects: [
                Effect(resource: "warOutput", amount: 1000),
                Effect(resource: "nobelScore", amount: -30),
            ], description: "+1000 War Output"),
        ],
        conditions: [EventCondition(resource: "cash", op: .gte, value: 500000)],
        cooldown: 360
    ),

    // Extraordinary Rendition Aftermath
    GameEvent(
        id: "p3_rendition_fallout",
        phase: 3,
        category: .scandal,
        headline: "BREAKING: \"Extracted hostile actor\" turns up alive in black site.",
        context: "The kidnapped leader is making calls from a secret prison. Diplomats are demanding answers.",
        choices: [
            EventChoice(label: "\"Voluntary relocation\"", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "attention", amount: 10000),
            ], description: "-15 Legitimacy, +10K Attention"),
            EventChoice(label: "Release with NDA", effects: [
                Effect(resource: "cash", amount: -200000),
                Effect(resource: "legitimacy", amount: 10),
            ], description: "-200K Cash, +10 Legitimacy"),
            EventChoice(label: "\"What black site?\"", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "realityDrift", amount: 0.03),
                Effect(resource: "fear", amount: 20),
            ], description: "-5 Legit, dubious"),
        ],
        unique: true
    ),

    // Jade Empire Warning
    GameEvent(
        id: "p3_jade_empire_warning",
        phase: 3,
        category: .crisis,
        headline: "JADE EMPIRE issues formal warning: \"We see what you are doing.\"",
        context: "The final boss has noticed your expansion. They have nukes. And a plan.",
        choices: [
            EventChoice(label: "Diplomatic de-escalation", effects: [
                Effect(resource: "legitimacy", amount: 15),
                Effect(resource: "warOutput", amount: -200),
            ], description: "+15 Legitimacy, -200 War Output"),
            EventChoice(label: "\"We see what YOU are doing\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "fear", amount: 10),
            ], description: "-10 Legitimacy, +10 Fear"),
            EventChoice(label: "Send Peace Cruisers to their coast", effects: [
                Effect(resource: "fear", amount: 30),
                Effect(resource: "legitimacy", amount: -20),
                Effect(resource: "nobelScore", amount: 5),
            ], description: "+30 Fear, -20 Legit, +5 Nobel"),
        ],
        conditions: [EventCondition(resource: "fear", op: .gte, value: 40)],
        cooldown: 300
    ),

    // Nobel While at War (ironic)
    GameEvent(
        id: "p3_ironic_nobel",
        phase: 3,
        category: .absurd,
        headline: "EDITORIAL: \"How did he win the Nobel Prize while running 3 active wars?\"",
        context: "The editorial board is confused. You are not.",
        choices: [
            EventChoice(label: "\"Peace through strength\"", effects: [
                Effect(resource: "attention", amount: 20000),
                Effect(resource: "nobelScore", amount: 10),
            ], description: "+20K Attention, +10 Nobel"),
            EventChoice(label: "\"These are Freedom Operations\"", effects: [
                Effect(resource: "legitimacy", amount: 5),
                Effect(resource: "realityDrift", amount: 0.02),
            ], description: "+5 Legitimacy, dubious"),
            EventChoice(label: "Ignore and build more ships", effects: [
                Effect(resource: "warOutput", amount: 500),
            ], description: "+500 War Output"),
        ],
        conditions: [EventCondition(resource: "nobelScore", op: .gte, value: 50)],
        cooldown: 300
    ),

    // Island Bloc Climate
    GameEvent(
        id: "p3_island_climate",
        phase: 3,
        category: .opportunity,
        headline: "ISLAND BLOC begs for climate aid. Half their territory is underwater.",
        context: "Climate change is doing your work for you. A \"rescue\" package could bring them into the Accord.",
        choices: [
            EventChoice(label: "Climate aid package", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "nobelScore", amount: 50),
                Effect(resource: "legitimacy", amount: 10),
            ], description: "-100K Cash, +50 Nobel"),
            EventChoice(label: "\"Relocate\" them to your territory", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "greatness", amount: 5000),
            ], description: "-5 Legitimacy, absorb population"),
            EventChoice(label: "Blame them for bad planning", effects: [
                Effect(resource: "attention", amount: 10000),
                Effect(resource: "nobelScore", amount: -10),
            ], description: "+10K Attention, -10 Nobel"),
        ],
        cooldown: 300
    ),

    // Arms Deal
    GameEvent(
        id: "p3_arms_deal",
        phase: 3,
        category: .opportunity,
        headline: "SECRET: Major arms deal available. \"Surplus equipment\" to undisclosed buyers.",
        context: "Some of these weapons will definitely end up where they shouldn't. But the profit margins are incredible.",
        choices: [
            EventChoice(label: "Approve the deal", effects: [
                Effect(resource: "cash", amount: 500000),
                Effect(resource: "nobelScore", amount: -20),
                Effect(resource: "fear", amount: 15),
            ], description: "+500K Cash, -20 Nobel, +15 Fear"),
            EventChoice(label: "Sell \"humanitarian equipment\"", effects: [
                Effect(resource: "cash", amount: 200000),
                Effect(resource: "nobelScore", amount: 5),
                Effect(resource: "realityDrift", amount: 0.02),
            ], description: "+200K Cash, +5 Nobel (it's weapons)"),
            EventChoice(label: "Decline -- too risky", effects: [
                Effect(resource: "legitimacy", amount: 10),
            ], description: "+10 Legitimacy"),
        ],
        cooldown: 240
    ),
]
