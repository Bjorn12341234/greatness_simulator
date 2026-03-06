import Foundation

struct EventEngine {

    // Category weights for random selection
    private static let categoryWeights: [EventCategory: Double] = [
        .opportunity: 3,
        .scandal: 2,
        .absurd: 2,
        .contradiction: 1.5,
        .crisis: 1,
        .nobel: 0.5,
        .realityGlitch: 0.5,
    ]

    /// Check if it's time for a new event
    static func shouldTrigger(state: GameState, now: Double) -> Bool {
        guard state.activeEvent == nil else { return false }
        return now >= state.nextEventAt && state.nextEventAt > 0
    }

    /// Select a random eligible event from the pool
    static func selectEvent(state: GameState, pool: [GameEvent]) -> GameEvent? {
        let eligible = pool.filter { isEligible($0, state: state) }
        guard !eligible.isEmpty else { return nil }

        // Weighted random selection
        let weights = eligible.map { categoryWeights[$0.category] ?? 1.0 }
        let totalWeight = weights.reduce(0, +)
        var roll = Double.random(in: 0..<totalWeight)

        for i in eligible.indices {
            roll -= weights[i]
            if roll <= 0 { return eligible[i] }
        }

        return eligible.last
    }

    /// Schedule the next event time
    static func scheduleNext(phase: Int, now: Double, prestigeUpgrades: [String: Bool] = [:]) -> Double {
        let baseDelay: Double
        switch phase {
        case 1: baseDelay = Double.random(in: 120...180)
        case 2: baseDelay = Double.random(in: 90...150)
        case 3: baseDelay = Double.random(in: 60...120)
        case 4: baseDelay = Double.random(in: 40...80)
        case 5: baseDelay = Double.random(in: 15...30)
        default: baseDelay = 120
        }
        let delay = baseDelay * prestigeEventCooldownMultiplier(upgrades: prestigeUpgrades)
        return now + delay
    }

    // MARK: - Private

    private static func isEligible(_ event: GameEvent, state: GameState) -> Bool {
        // Phase check
        guard event.phase <= state.phase.rawValue else { return false }

        // Unique events can only fire once
        if event.unique && state.eventHistory.contains(event.id) { return false }

        // Check all conditions
        for condition in event.conditions {
            if !checkCondition(condition, state: state) { return false }
        }

        return true
    }

    private static func checkCondition(_ condition: EventCondition, state: GameState) -> Bool {
        let value: Double
        switch condition.resource {
        case "attention": value = state.attention
        case "cash": value = state.cash
        case "greatness": value = state.greatness
        case "influence": value = state.influence
        case "clickCount": value = Double(state.clickCount)
        case "legitimacy": value = state.legitimacy
        case "fear": value = state.fear
        case "nobelScore": value = state.nobelScore
        case "rocketMass": value = state.rocketMass
        case "orbitalIndustry": value = state.orbitalIndustry
        case "miningOutput": value = state.miningOutput
        case "colonists": value = state.colonists
        case "terraformProgress": value = state.terraformProgress
        case "realityDrift": value = state.realityDrift
        case "probesLaunched": value = state.probesLaunched
        case "starsConverted": value = state.starsConverted
        case "computronium": value = state.computronium
        case "greatnessUnits": value = state.greatnessUnits
        default: value = 0
        }

        switch condition.op {
        case .gt: return value > condition.value
        case .lt: return value < condition.value
        case .gte: return value >= condition.value
        case .lte: return value <= condition.value
        case .eq: return value == condition.value
        }
    }
}
