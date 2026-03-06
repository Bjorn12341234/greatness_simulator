import Foundation

let phase5Events: [GameEvent] = [
    GameEvent(
        id: "p5_scientists_complain",
        phase: 5,
        category: .realityGlitch,
        headline: "SCIENTISTS COMPLAIN: \"Reality no longer matches spreadsheets.\"",
        context: "The remaining scientists have noticed that the universe isn't behaving normally. They blame the star conversions. You blame the scientists.",
        choices: [
            EventChoice(
                label: "Fund reality stabilization",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -500),
                    Effect(resource: "realityDrift", amount: -5),
                ],
                description: "-500 GU, Reality Drift -5%"
            ),
            EventChoice(
                label: "Fire the scientists",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 2000),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+2K GU, Reality Drift +5%"
            ),
            EventChoice(
                label: "Replace scientists with Influencers",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 1000),
                    Effect(resource: "attention", amount: 50_000),
                    Effect(resource: "realityDrift", amount: 10),
                ],
                description: "+1K GU, +50K Attention, Reality Drift +10%"
            ),
        ],
        cooldown: 120
    ),

    GameEvent(
        id: "p5_probe_report",
        phase: 5,
        category: .absurd,
        headline: "PROBE REPORT: Stars in Sector 7 already converted. By whom?",
        context: "Your MAGA Replicators arrived at a distant star cluster only to find it already branded. The logo looks... different. Someone else is doing this.",
        choices: [
            EventChoice(
                label: "Investigate the anomaly",
                effects: [
                    Effect(resource: "probesLaunched", amount: 100),
                    Effect(resource: "legitimacy", amount: -10),
                ],
                description: "+100 Probes (scouts), -10 Legitimacy"
            ),
            EventChoice(
                label: "Claim credit anyway",
                effects: [
                    Effect(resource: "starsConverted", amount: 50),
                    Effect(resource: "realityDrift", amount: 3),
                ],
                description: "+50 Stars Converted, Reality Drift +3%"
            ),
            EventChoice(
                label: "Deny stars ever existed",
                effects: [
                    Effect(resource: "realityDrift", amount: 15),
                ],
                description: "Reality Drift +15%, net zero GU"
            ),
        ],
        conditions: [EventCondition(resource: "probesLaunched", op: .gte, value: 50)],
        unique: true
    ),

    GameEvent(
        id: "p5_existential_query",
        phase: 5,
        category: .contradiction,
        headline: "EXISTENTIAL QUERY: \"If everything is Great, is anything?\"",
        context: "A rogue AI in the Narrative Architecture has achieved self-awareness. Its first question is devastatingly on-point.",
        choices: [
            EventChoice(
                label: "Increase production",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 5000),
                    Effect(resource: "realityDrift", amount: 8),
                ],
                description: "+5K GU, Reality Drift +8%"
            ),
            EventChoice(
                label: "Philosophical pause",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -1000),
                    Effect(resource: "realityDrift", amount: -3),
                    Effect(resource: "legitimacy", amount: 10),
                ],
                description: "-1K GU, Reality Drift -3%, +10 Legitimacy"
            ),
            EventChoice(
                label: "Redefine \"Great\"",
                effects: [
                    Effect(resource: "realityDrift", amount: 20),
                    Effect(resource: "greatnessUnits", amount: 500),
                ],
                description: "Reality Drift +20%, all values scramble"
            ),
        ],
        cooldown: 180
    ),

    GameEvent(
        id: "p5_computronium_shortage",
        phase: 5,
        category: .crisis,
        headline: "EXECUTIVE PROCESSING SHORTAGE: Universe running low on convertible matter.",
        context: "You've converted so much reality into Executive Processing that reality is becoming scarce. The irony is lost on the PR department.",
        choices: [
            EventChoice(
                label: "Optimize existing reserves",
                effects: [
                    Effect(resource: "computronium", amount: 500),
                    Effect(resource: "cash", amount: -5_000_000),
                ],
                description: "+500 Computronium, -5M Cash"
            ),
            EventChoice(
                label: "\"Mine the void between stars\"",
                effects: [
                    Effect(resource: "computronium", amount: 200),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+200 Computronium, Reality Drift +5%"
            ),
            EventChoice(
                label: "Declare matter \"overrated\"",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 2000),
                    Effect(resource: "realityDrift", amount: 12),
                ],
                description: "+2K GU, Reality Drift +12%"
            ),
        ],
        conditions: [EventCondition(resource: "computronium", op: .gte, value: 100)],
        cooldown: 120
    ),

    GameEvent(
        id: "p5_dyson_malfunction",
        phase: 5,
        category: .crisis,
        headline: "SOLAR GREATNESS HARVESTER MALFUNCTION: Star output fluctuating wildly.",
        context: "The Harvester is working too well. The star is complaining. Stars don't usually complain.",
        choices: [
            EventChoice(
                label: "Reduce harvesting rate",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -500),
                    Effect(resource: "legitimacy", amount: 5),
                ],
                description: "-500 GU/s temporarily, stable operation"
            ),
            EventChoice(
                label: "Push harder",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 2000),
                    Effect(resource: "realityDrift", amount: 3),
                ],
                description: "+2K GU, risk of stellar instability"
            ),
            EventChoice(
                label: "\"Stars are employees too\"",
                effects: [
                    Effect(resource: "attention", amount: 100_000),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+100K Attention, Reality Drift +5%"
            ),
        ],
        cooldown: 150
    ),

    GameEvent(
        id: "p5_replicator_rebellion",
        phase: 5,
        category: .crisis,
        headline: "MAGA REPLICATOR SWARM developing \"preferences.\" Refuses to brand certain stars.",
        context: "The probes have evolved enough to have opinions. They think some stars are \"fine the way they are.\" This is unacceptable.",
        choices: [
            EventChoice(
                label: "Override their programming",
                effects: [
                    Effect(resource: "probesLaunched", amount: 200),
                    Effect(resource: "legitimacy", amount: -20),
                ],
                description: "+200 Probes, -20 Legitimacy"
            ),
            EventChoice(
                label: "Negotiate with the swarm",
                effects: [
                    Effect(resource: "probesLaunched", amount: 50),
                    Effect(resource: "legitimacy", amount: 5),
                    Effect(resource: "greatnessUnits", amount: 1000),
                ],
                description: "+50 Probes, +5 Legitimacy, +1K GU"
            ),
            EventChoice(
                label: "Replace with \"loyal\" version",
                effects: [
                    Effect(resource: "probesLaunched", amount: 400),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "-100 Probes, +500 Probes (new), Reality Drift +5%"
            ),
        ],
        conditions: [EventCondition(resource: "probesLaunched", op: .gte, value: 200)],
        cooldown: 180
    ),

    GameEvent(
        id: "p5_black_hole_message",
        phase: 5,
        category: .absurd,
        headline: "GOLDEN LEDGER SINGULARITY emitting patterns. Looks like... a receipt.",
        context: "The black hole is outputting what appears to be an itemized invoice for \"services rendered to the universe.\" The total is infinity.",
        choices: [
            EventChoice(
                label: "Pay the invoice (in GU)",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -5000),
                    Effect(resource: "legitimacy", amount: 10),
                    Effect(resource: "realityDrift", amount: -3),
                ],
                description: "-5K GU, +10 Legitimacy, drift -3%"
            ),
            EventChoice(
                label: "Dispute the charges",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 500),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+500 GU, Reality Drift +5%"
            ),
            EventChoice(
                label: "\"We ARE the universe now\"",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 3000),
                    Effect(resource: "realityDrift", amount: 10),
                    Effect(resource: "attention", amount: 200_000),
                ],
                description: "+3K GU, Reality Drift +10%, +200K Attention"
            ),
        ],
        conditions: [EventCondition(resource: "starsConverted", op: .gte, value: 20)],
        unique: true
    ),

    GameEvent(
        id: "p5_reality_leak",
        phase: 5,
        category: .realityGlitch,
        headline: "REALITY LEAK: Portion of converted space \"unbranding\" itself spontaneously.",
        context: "Stars are reverting to their natural state. Reality itself appears to be resisting. The Narrative Architecture team is \"working on it.\"",
        choices: [
            EventChoice(
                label: "Deploy stabilization probes",
                effects: [
                    Effect(resource: "probesLaunched", amount: -100),
                    Effect(resource: "realityDrift", amount: -5),
                ],
                description: "-100 Probes, Reality Drift -5%"
            ),
            EventChoice(
                label: "Rebrand the leak as \"Planned Maintenance\"",
                effects: [
                    Effect(resource: "attention", amount: 50_000),
                    Effect(resource: "realityDrift", amount: 3),
                ],
                description: "+50K Attention, Reality Drift +3%"
            ),
            EventChoice(
                label: "Double the conversion rate",
                effects: [
                    Effect(resource: "starsConverted", amount: 30),
                    Effect(resource: "realityDrift", amount: 8),
                ],
                description: "+30 Stars Converted, Reality Drift +8%"
            ),
        ],
        conditions: [EventCondition(resource: "realityDrift", op: .gte, value: 30)],
        cooldown: 90
    ),

    GameEvent(
        id: "p5_meaning_crisis",
        phase: 5,
        category: .contradiction,
        headline: "MEANING CRISIS: Converted civilizations ask \"What is Greatness FOR?\"",
        context: "The populations of converted star systems have sent a collective petition. They've optimized everything. Now they want to know why.",
        choices: [
            EventChoice(
                label: "\"Greatness IS the purpose\"",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 3000),
                    Effect(resource: "legitimacy", amount: -15),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+3K GU, -15 Legitimacy, Reality Drift +5%"
            ),
            EventChoice(
                label: "Fund arts and culture programs",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -2000),
                    Effect(resource: "legitimacy", amount: 20),
                    Effect(resource: "realityDrift", amount: -3),
                ],
                description: "-2K GU, +20 Legitimacy, Reality Drift -3%"
            ),
            EventChoice(
                label: "Delete the concept of \"meaning\"",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 5000),
                    Effect(resource: "realityDrift", amount: 15),
                ],
                description: "+5K GU, Reality Drift +15%"
            ),
        ],
        conditions: [EventCondition(resource: "starsConverted", op: .gte, value: 50)],
        cooldown: 120
    ),

    GameEvent(
        id: "p5_mirror_universe",
        phase: 5,
        category: .absurd,
        headline: "MIRROR UNIVERSE DETECTED: Another version of you is doing the same thing. But worse.",
        context: "Probes have encountered an alternate reality's expansion. Their branding is inferior. Their logo is wrong. This cannot stand.",
        choices: [
            EventChoice(
                label: "Merge universes (hostile takeover)",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 10_000),
                    Effect(resource: "starsConverted", amount: 500),
                    Effect(resource: "realityDrift", amount: 15),
                ],
                description: "+10K GU, +500 Stars, Reality Drift +15%"
            ),
            EventChoice(
                label: "Establish diplomatic relations",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 5000),
                    Effect(resource: "nobelScore", amount: 30),
                    Effect(resource: "legitimacy", amount: 10),
                ],
                description: "+5K GU, +30 Nobel, +10 Legitimacy"
            ),
            EventChoice(
                label: "Deny the existence of mirrors",
                effects: [
                    Effect(resource: "attention", amount: 200_000),
                    Effect(resource: "realityDrift", amount: 20),
                ],
                description: "+200K Attention, Reality Drift +20%"
            ),
        ],
        conditions: [EventCondition(resource: "starsConverted", op: .gte, value: 100)],
        unique: true
    ),

    GameEvent(
        id: "p5_nobel_cosmic",
        phase: 5,
        category: .nobel,
        headline: "NOBEL COMMITTEE (reconstituted): Nominates you for \"Cosmic Peace.\" They have no choice.",
        context: "You've eliminated conflict by eliminating everything that could conflict. The committee calls it \"peace through totality.\" The ceremony is held in a converted star.",
        choices: [
            EventChoice(
                label: "Accept graciously",
                effects: [
                    Effect(resource: "nobelScore", amount: 100),
                    Effect(resource: "legitimacy", amount: 20),
                ],
                description: "+100 Nobel, +20 Legitimacy"
            ),
            EventChoice(
                label: "\"I deserve all the prizes\"",
                effects: [
                    Effect(resource: "nobelScore", amount: 200),
                    Effect(resource: "legitimacy", amount: -10),
                    Effect(resource: "attention", amount: 500_000),
                ],
                description: "+200 Nobel, -10 Legitimacy, +500K Attention"
            ),
            EventChoice(
                label: "Rename the prize",
                effects: [
                    Effect(resource: "nobelScore", amount: 150),
                    Effect(resource: "realityDrift", amount: 5),
                    Effect(resource: "attention", amount: 100_000),
                ],
                description: "+150 Nobel, Reality Drift +5%, +100K Attention"
            ),
        ],
        conditions: [EventCondition(resource: "starsConverted", op: .gte, value: 30)],
        cooldown: 200
    ),

    GameEvent(
        id: "p5_entropy_wins",
        phase: 5,
        category: .realityGlitch,
        headline: "ENTROPY REPORT: Universe cooling faster than expected. Greatness is thermodynamically expensive.",
        context: "The laws of physics are pushing back. Every GU produced accelerates heat death. The accountants say we're \"borrowing from the future.\" The future is getting shorter.",
        choices: [
            EventChoice(
                label: "Research entropy reversal",
                effects: [
                    Effect(resource: "greatnessUnits", amount: -3000),
                    Effect(resource: "realityDrift", amount: -5),
                ],
                description: "-3K GU, Reality Drift -5%, long-term stability"
            ),
            EventChoice(
                label: "\"Entropy is fake news\"",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 5000),
                    Effect(resource: "realityDrift", amount: 10),
                ],
                description: "+5K GU, Reality Drift +10%"
            ),
            EventChoice(
                label: "Convert entropy itself into GU",
                effects: [
                    Effect(resource: "greatnessUnits", amount: 10_000),
                    Effect(resource: "realityDrift", amount: 20),
                    Effect(resource: "legitimacy", amount: -30),
                ],
                description: "+10K GU, Reality Drift +20%, -30 Legitimacy"
            ),
        ],
        conditions: [EventCondition(resource: "realityDrift", op: .gte, value: 50)],
        cooldown: 150
    ),

    GameEvent(
        id: "p5_last_star",
        phase: 5,
        category: .opportunity,
        headline: "FINAL FRONTIER: Last unconverted star cluster detected. The universe awaits completion.",
        context: "One cluster remains. It's beautiful, ancient, and completely unbranded. The probes are in position.",
        choices: [
            EventChoice(
                label: "Convert it. Finish the job.",
                effects: [
                    Effect(resource: "starsConverted", amount: 100),
                    Effect(resource: "realityDrift", amount: 5),
                ],
                description: "+100 Stars Converted, Reality Drift +5%"
            ),
            EventChoice(
                label: "Preserve it as a monument",
                effects: [
                    Effect(resource: "legitimacy", amount: 30),
                    Effect(resource: "nobelScore", amount: 50),
                    Effect(resource: "realityDrift", amount: -5),
                ],
                description: "+30 Legitimacy, +50 Nobel, Reality Drift -5%"
            ),
            EventChoice(
                label: "Turn it into a gift shop",
                effects: [
                    Effect(resource: "cash", amount: 50_000_000),
                    Effect(resource: "attention", amount: 100_000),
                ],
                description: "+50M Cash, +100K Attention"
            ),
        ],
        conditions: [EventCondition(resource: "starsConverted", op: .gte, value: 800)],
        unique: true
    ),
]
