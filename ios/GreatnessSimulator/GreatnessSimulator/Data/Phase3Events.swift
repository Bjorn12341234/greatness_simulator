import Foundation

// Phase 3 events — geopolitical satire.
// Add new events to this array; they'll be included in the random event pool.
// Each event needs a unique id, phase number, choices with resource effects.
// Available resources: influence, attention, legitimacy, loyalty, cash,
// fear, nobelScore, warOutput, sanctions, realityDrift, etc.

let phase3Events: [GameEvent] = [
    // ── Trouble in the Oil Republic ──
    // A satirical geopolitical crisis event with three strategic paths.
    GameEvent(
        id: "p3_oil_republic_zahran",
        phase: 3,
        category: .crisis,
        headline: "Trouble in the Oil Republic",
        context: """
            Reports are emerging from the distant Oil Republic of Zahran, \
            a wealthy but deeply traditional state sitting on enormous energy reserves.

            Your advisors claim the regime is unstable, outside your financial network, \
            and allegedly developing "unusual long-range projects".

            Your intelligence agency insists this might threaten "regional stability".

            Your media team is already preparing headlines.
            """,
        choices: [
            EventChoice(
                label: "Launch a Narrative Campaign",
                effects: [
                    Effect(resource: "influence", amount: 500),
                    Effect(resource: "attention", amount: 1000),
                    Effect(resource: "legitimacy", amount: -8),
                ],
                description: "Encourage media partners to highlight suspicious activities. +500 Influence, +1K Attention, -8 Legitimacy"
            ),
            EventChoice(
                label: "Quiet Economic Pressure",
                effects: [
                    Effect(resource: "influence", amount: 300),
                    Effect(resource: "sanctions", amount: 200),
                    Effect(resource: "legitimacy", amount: -5),
                ],
                description: "Isolate Zahran from financial systems. +300 Influence, +200 Sanctions, -5 Legitimacy"
            ),
            EventChoice(
                label: "Ignore the Situation",
                effects: [
                    Effect(resource: "legitimacy", amount: 10),
                    Effect(resource: "influence", amount: -200),
                ],
                description: "Getting involved may cause unnecessary complications. +10 Legitimacy, -200 Influence"
            ),
        ],
        conditions: [
            EventCondition(resource: "influence", op: .gte, value: 100),
        ],
        cooldown: 600,
        unique: true
    ),
]
