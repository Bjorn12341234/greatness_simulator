import Foundation

let phase2Events: [GameEvent] = [

    // -- Scandal --

    GameEvent(
        id: "p2_whistleblower",
        phase: 2,
        category: .scandal,
        headline: "WHISTLEBLOWER: Internal memos show institutional \"realignment\" plan.",
        context: "A former bureaucrat has leaked detailed plans. Media is circling.",
        choices: [
            EventChoice(label: "Deny everything", effects: [
                Effect(resource: "legitimacy", amount: -10),
            ], description: "-10 Legitimacy"),
            EventChoice(label: "Discredit whistleblower", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "attention", amount: 500),
            ], description: "-5 Legitimacy, +500 Attention"),
            EventChoice(label: "\"Transparency Initiative\"", effects: [
                Effect(resource: "cash", amount: -20000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-20K Cash, +5 Legitimacy"),
        ]
    ),

    // -- Crisis --

    GameEvent(
        id: "p2_poll_concern",
        phase: 2,
        category: .crisis,
        headline: "POLL: 60% of public \"concerned\" about institutional changes.",
        context: "Approval ratings dropping. Advisory team recommends immediate action.",
        choices: [
            EventChoice(label: "Unity Campaign", effects: [
                Effect(resource: "cash", amount: -50000),
                Effect(resource: "legitimacy", amount: 15),
            ], description: "-50K Cash, +15 Legitimacy"),
            EventChoice(label: "Discredit the polls", effects: [
                Effect(resource: "legitimacy", amount: -8),
                Effect(resource: "attention", amount: 1000),
            ], description: "-8 Legitimacy, +1K Attention"),
            EventChoice(label: "Launch a merch drop", effects: [
                Effect(resource: "cash", amount: 5000),
            ], description: "+5K Cash"),
        ]
    ),

    GameEvent(
        id: "p2_general_refuses",
        phase: 2,
        category: .crisis,
        headline: "GENERAL REFUSES TO COMPLY with Greatness Directive.",
        context: "A senior military official is publicly questioning chain of command.",
        choices: [
            EventChoice(label: "Replace immediately", effects: [
                Effect(resource: "legitimacy", amount: -15),
            ], description: "-15 Legitimacy, Military resistance -20"),
            EventChoice(label: "Negotiate", effects: [
                Effect(resource: "cash", amount: -20000),
            ], description: "-20K Cash"),
            EventChoice(label: "\"Special Advisor\" role", effects: [
                Effect(resource: "legitimacy", amount: -2),
            ], description: "-2 Legitimacy (a nothing position)"),
        ]
    ),

    GameEvent(
        id: "p2_worker_protests",
        phase: 2,
        category: .crisis,
        headline: "FEDERAL WORKERS PROTEST LOYALTY PLEDGE REQUIREMENT.",
        context: "Thousands are refusing to sign. Media coverage is intense.",
        choices: [
            EventChoice(label: "Fire the protesters", effects: [
                Effect(resource: "loyalty", amount: 500),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "+500 Loyalty, -15 Legitimacy"),
            EventChoice(label: "Negotiate", effects: [
                Effect(resource: "loyalty", amount: -5),
                Effect(resource: "legitimacy", amount: 10),
            ], description: "-5 Loyalty, +10 Legitimacy"),
            EventChoice(label: "Automate their jobs", effects: [
                Effect(resource: "cash", amount: 100000),
                Effect(resource: "legitimacy", amount: -20),
            ], description: "+100K Cash, -20 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_health_crisis",
        phase: 2,
        category: .crisis,
        headline: "HEALTH CRISIS: Hospitals overwhelmed. Emergency funding requested.",
        context: "Budget committee requests $500,000 for emergency healthcare.",
        choices: [
            EventChoice(label: "Fund hospitals", effects: [
                Effect(resource: "cash", amount: -500000),
                Effect(resource: "legitimacy", amount: 20),
            ], description: "-500K Cash, +20 Legitimacy"),
            EventChoice(label: "\"Healthcare Innovation Hub\"", effects: [
                Effect(resource: "attention", amount: 2000),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "+2K Attention, -15 Legitimacy"),
            EventChoice(label: "Thoughts and prayers", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "attention", amount: 500),
            ], description: "-5 Legitimacy, +500 Attention"),
        ]
    ),

    GameEvent(
        id: "p2_veterans",
        phase: 2,
        category: .crisis,
        headline: "VETERANS NEED CARE: 50,000 veterans require medical support.",
        context: "The cost is real. The optics are real. Choose wisely.",
        choices: [
            EventChoice(label: "Fund VA", effects: [
                Effect(resource: "cash", amount: -200000),
                Effect(resource: "legitimacy", amount: 15),
                Effect(resource: "nobelScore", amount: 50),
            ], description: "-200K Cash, +15 Legitimacy, +50 Nobel"),
            EventChoice(label: "\"Greatness Gratitude Ceremony\"", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "legitimacy", amount: -10),
            ], description: "+5K Attention, -10 Legitimacy"),
            EventChoice(label: "Redirect to recruitment", effects: [
                Effect(resource: "loyalty", amount: 500),
                Effect(resource: "legitimacy", amount: -20),
            ], description: "+500 Loyalty, -20 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_court_challenge",
        phase: 2,
        category: .crisis,
        headline: "COURT CHALLENGES \"REALIGNMENT\" of Scientific Agencies.",
        context: "Lower courts are pushing back. The legal battle could set precedent.",
        choices: [
            EventChoice(label: "Appeal to Supreme Court", effects: [
                Effect(resource: "cash", amount: -30000),
            ], description: "-30K Cash, slow but safe"),
            EventChoice(label: "Ignore the ruling", effects: [
                Effect(resource: "legitimacy", amount: -20),
                Effect(resource: "loyalty", amount: 300),
            ], description: "-20 Legitimacy, +300 Loyalty"),
            EventChoice(label: "Replace the judges", effects: [
                Effect(resource: "legitimacy", amount: -15),
                Effect(resource: "loyalty", amount: 500),
            ], description: "-15 Legitimacy, +500 Loyalty"),
        ]
    ),

    GameEvent(
        id: "p2_austerity_protest",
        phase: 2,
        category: .crisis,
        headline: "MASS PROTESTS: Citizens demand healthcare and education funding.",
        context: "Austerity measures are popular with the spreadsheet. Less so with the streets.",
        choices: [
            EventChoice(label: "Increase social spending", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "legitimacy", amount: 20),
            ], description: "-100K Cash, +20 Legitimacy"),
            EventChoice(label: "Deploy police", effects: [
                Effect(resource: "loyalty", amount: 300),
                Effect(resource: "legitimacy", amount: -25),
            ], description: "+300 Loyalty, -25 Legitimacy"),
            EventChoice(label: "\"Patriotic Patience\" campaign", effects: [
                Effect(resource: "attention", amount: 2000),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+2K Attention, -5 Legitimacy"),
        ],
        conditions: [EventCondition(resource: "legitimacy", op: .lt, value: 50)]
    ),

    // -- Opportunity --

    GameEvent(
        id: "p2_ceo_education",
        phase: 2,
        category: .opportunity,
        headline: "CEO OFFERS TO RUN DEPARTMENT OF EDUCATION. \"I'll make it efficient.\"",
        context: "A tech billionaire wants to \"disrupt\" public education.",
        choices: [
            EventChoice(label: "Accept", effects: [
                Effect(resource: "legitimacy", amount: -20),
                Effect(resource: "cash", amount: 50000),
            ], description: "-20 Legitimacy, +50K Cash"),
            EventChoice(label: "Decline gracefully", effects: [
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+5 Legitimacy"),
            EventChoice(label: "\"Public-Private Innovation\"", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "cash", amount: 50000),
            ], description: "-10 Legitimacy, +50K Cash"),
        ]
    ),

    GameEvent(
        id: "p2_tariff_revenue",
        phase: 2,
        category: .opportunity,
        headline: "TARIFF REVENUE UP 300%. Economists warn of \"cascading consequences.\"",
        context: "Cash is flowing. Experts are worried. Business as usual.",
        choices: [
            EventChoice(label: "Increase tariffs", effects: [
                Effect(resource: "cash", amount: 200000),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "+200K Cash, -15 Legitimacy"),
            EventChoice(label: "Hold steady", effects: [], description: "No change"),
            EventChoice(label: "Fire the economists", effects: [
                Effect(resource: "attention", amount: 500),
                Effect(resource: "legitimacy", amount: -10),
            ], description: "+500 Attention, -10 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_private_prison",
        phase: 2,
        category: .opportunity,
        headline: "PRIVATE PRISON CONTRACTOR offers to \"manage\" dissent.",
        context: "\"Civic Rehabilitation Centers\" -- the branding is already done.",
        choices: [
            EventChoice(label: "Accept the offer", effects: [
                Effect(resource: "cash", amount: 10000),
                Effect(resource: "loyalty", amount: 100),
                Effect(resource: "legitimacy", amount: -25),
            ], description: "+10K Cash, +Loyalty, -25 Legitimacy"),
            EventChoice(label: "Decline", effects: [
                Effect(resource: "legitimacy", amount: 10),
            ], description: "+10 Legitimacy"),
            EventChoice(label: "\"Civic Rehabilitation Centers\"", effects: [
                Effect(resource: "cash", amount: 10000),
                Effect(resource: "loyalty", amount: 100),
                Effect(resource: "legitimacy", amount: -10),
            ], description: "+10K Cash, +Loyalty, -10 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_data_center_growth",
        phase: 2,
        category: .opportunity,
        headline: "DATA CENTER CAPACITY DOUBLED. \"Innovation\" at unprecedented scale.",
        context: "Processing power grows. Oversight shrinks. Efficiency abounds.",
        choices: [
            EventChoice(label: "Expand further", effects: [
                Effect(resource: "attention", amount: 10000),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+10K Attention, -5 Legitimacy"),
            EventChoice(label: "Monetize the data", effects: [
                Effect(resource: "cash", amount: 100000),
            ], description: "+100K Cash"),
            EventChoice(label: "\"Open Transparency Platform\"", effects: [
                Effect(resource: "legitimacy", amount: 5),
                Effect(resource: "attention", amount: 3000),
            ], description: "+5 Legitimacy, +3K Attention"),
        ]
    ),

    GameEvent(
        id: "p2_nobel_nomination",
        phase: 2,
        category: .opportunity,
        headline: "HUMANITARIAN GROUP offers to nominate for \"Greatness in Governance\" award.",
        context: "Not quite the Nobel. But it's a start.",
        choices: [
            EventChoice(label: "Accept with ceremony", effects: [
                Effect(resource: "nobelScore", amount: 10),
                Effect(resource: "cash", amount: -30000),
            ], description: "+10 Nobel Score, -30K Cash"),
            EventChoice(label: "\"Only the real thing matters\"", effects: [
                Effect(resource: "attention", amount: 1000),
            ], description: "+1K Attention"),
            EventChoice(label: "Create our own award", effects: [
                Effect(resource: "nobelScore", amount: 5),
                Effect(resource: "attention", amount: 3000),
            ], description: "+5 Nobel Score, +3K Attention"),
        ]
    ),

    // -- Contradiction --

    GameEvent(
        id: "p2_health_study",
        phase: 2,
        category: .contradiction,
        headline: "HEALTH AGENCY SCIENTISTS PUBLISH UNFAVORABLE STUDY.",
        context: "The data contradicts current messaging. Action required.",
        choices: [
            EventChoice(label: "Suppress the study", effects: [
                Effect(resource: "legitimacy", amount: -10),
                Effect(resource: "loyalty", amount: 200),
            ], description: "-10 Legitimacy, +200 Loyalty"),
            EventChoice(label: "Rebrand the findings", effects: [
                Effect(resource: "cash", amount: -50000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "-50K Cash, +5 Legitimacy"),
            EventChoice(label: "Defund and build data centers", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "legitimacy", amount: -20),
            ], description: "+5K Attention, -20 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_education_review",
        phase: 2,
        category: .contradiction,
        headline: "EDUCATION BUDGET REVIEW: Schools vs. Data Centers.",
        context: "Both departments request additional funding. You can only fund one.",
        choices: [
            EventChoice(label: "Fund schools", effects: [
                Effect(resource: "legitimacy", amount: 10),
            ], description: "+10 Legitimacy"),
            EventChoice(label: "Fund data centers", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "legitimacy", amount: -8),
            ], description: "+5K Attention, -8 Legitimacy"),
            EventChoice(label: "Defund both, boost military", effects: [
                Effect(resource: "attention", amount: 3000),
                Effect(resource: "legitimacy", amount: -20),
            ], description: "+3K Attention, -20 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_workers_benefits",
        phase: 2,
        category: .contradiction,
        headline: "WORKERS DEMAND BENEFITS: Minimum wage increase proposed.",
        context: "Workers want more. The budget says less.",
        choices: [
            EventChoice(label: "Approve increase", effects: [
                Effect(resource: "cash", amount: -50000),
                Effect(resource: "legitimacy", amount: 15),
            ], description: "-50K Cash, +15 Legitimacy"),
            EventChoice(label: "\"Greatness Stipend\" (nothing)", effects: [
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+5 Legitimacy, Reality Drift hint"),
            EventChoice(label: "Replace with AI", effects: [
                Effect(resource: "cash", amount: 100000),
                Effect(resource: "legitimacy", amount: -25),
            ], description: "+100K Cash, -25 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_climate_research",
        phase: 2,
        category: .contradiction,
        headline: "SCIENTISTS REQUEST CLIMATE RESEARCH FUNDING.",
        context: "Data suggests urgent need. Budget suggests urgent indifference.",
        choices: [
            EventChoice(label: "Fund research", effects: [
                Effect(resource: "cash", amount: -100000),
                Effect(resource: "nobelScore", amount: 10),
            ], description: "-100K Cash, +10 Nobel Score"),
            EventChoice(label: "\"Weather Optimization\" (military)", effects: [
                Effect(resource: "attention", amount: 1000),
            ], description: "+1K Attention"),
            EventChoice(label: "Defund and declare victory", effects: [
                Effect(resource: "attention", amount: 5000),
                Effect(resource: "legitimacy", amount: -15),
            ], description: "+5K Attention, -15 Legitimacy"),
        ]
    ),

    // -- Absurd --

    GameEvent(
        id: "p2_intern_policy",
        phase: 2,
        category: .absurd,
        headline: "INTERN ACCIDENTALLY PUBLISHES INTERNAL POLICY AS PUBLIC MEMO.",
        context: "\"Project Greatness Alignment\" now trending on all platforms.",
        choices: [
            EventChoice(label: "Claim it was intentional", effects: [
                Effect(resource: "attention", amount: 2000),
                Effect(resource: "legitimacy", amount: -5),
            ], description: "+2K Attention, -5 Legitimacy"),
            EventChoice(label: "Blame the intern", effects: [
                Effect(resource: "attention", amount: 500),
                Effect(resource: "loyalty", amount: 5),
            ], description: "+500 Attention, +5 Loyalty"),
            EventChoice(label: "\"It was a transparency exercise\"", effects: [
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+5 Legitimacy"),
        ]
    ),

    GameEvent(
        id: "p2_ai_writes_speech",
        phase: 2,
        category: .absurd,
        headline: "AI SPEECH WRITER MALFUNCTIONS. Generates \"surprisingly honest\" address.",
        context: "The speech mentioned \"institutional domination\" and \"loyalty extraction.\"",
        choices: [
            EventChoice(label: "Call it satire", effects: [
                Effect(resource: "attention", amount: 3000),
                Effect(resource: "legitimacy", amount: 5),
            ], description: "+3K Attention, +5 Legitimacy"),
            EventChoice(label: "Blame foreign hackers", effects: [
                Effect(resource: "attention", amount: 1000),
                Effect(resource: "loyalty", amount: 200),
            ], description: "+1K Attention, +200 Loyalty"),
            EventChoice(label: "Delete all evidence", effects: [
                Effect(resource: "legitimacy", amount: -5),
                Effect(resource: "loyalty", amount: 500),
            ], description: "-5 Legitimacy, +500 Loyalty"),
        ]
    ),

    GameEvent(
        id: "p2_loyalty_app",
        phase: 2,
        category: .absurd,
        headline: "NEW \"GREAT CITIZEN\" APP crashes on launch. 10M downloads anyway.",
        context: "The app tracks loyalty metrics. It doesn't work. Nobody cares.",
        choices: [
            EventChoice(label: "Fix and relaunch", effects: [
                Effect(resource: "cash", amount: -10000),
                Effect(resource: "loyalty", amount: 500),
            ], description: "-10K Cash, +500 Loyalty"),
            EventChoice(label: "Ship broken (it's a feature)", effects: [
                Effect(resource: "attention", amount: 5000),
            ], description: "+5K Attention"),
            EventChoice(label: "Mandatory download requirement", effects: [
                Effect(resource: "loyalty", amount: 1000),
                Effect(resource: "legitimacy", amount: -10),
            ], description: "+1K Loyalty, -10 Legitimacy"),
        ]
    ),
]
