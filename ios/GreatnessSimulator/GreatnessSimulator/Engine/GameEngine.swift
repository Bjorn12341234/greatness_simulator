import Foundation

struct GameEngine {

    // MARK: - Tick (called every 100ms)

    static func tick(state: GameState, now: Double) {
        let dt = now - state.lastTickAt
        guard dt > 0, dt < 10 else {
            // Clamp: skip ticks > 10s (handle offline separately)
            state.lastTickAt = now
            return
        }

        state.totalPlayTime += dt
        state.lastTickAt = now

        // Recalculate derived rates
        let gps = calculateGPS(state: state)
        let attPerSec = calculateAttentionPerSecond(state: state)
        let cashPerSec = calculateCashPerSecond(state: state)

        state.greatnessPerSecond = gps

        // Apply production
        state.greatness += gps * dt
        state.attention += attPerSec * dt
        state.cash += cashPerSec * dt
    }

    // MARK: - GpS Calculation

    static func calculateGPS(state: GameState) -> Double {
        var baseGPS: Double = 0
        var gpsMultiplier: Double = 1.0

        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }

            // Base production
            baseGPS += data.production * Double(upgradeState.count)

            // GPS multiplier effects
            for effect in data.effects where effect.type == .gpsMultiplier {
                gpsMultiplier *= effect.value
            }
        }

        let phaseMultiplier = Self.phaseMultiplier(for: state.phase)
        return baseGPS * gpsMultiplier * phaseMultiplier
    }

    // MARK: - Attention Per Second

    static func calculateAttentionPerSecond(state: GameState) -> Double {
        var total: Double = 0
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .attentionPerSecond {
                total += effect.value * Double(upgradeState.count)
            }
        }
        return total
    }

    // MARK: - Cash Per Second

    static func calculateCashPerSecond(state: GameState) -> Double {
        var total: Double = 0
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .cashPerSecond {
                total += effect.value * Double(upgradeState.count)
            }
        }
        return total
    }

    // MARK: - Upgrade Cost

    static func upgradeCost(data: UpgradeData, currentCount: Int) -> Double {
        data.baseCost * pow(1.15, Double(currentCount))
    }

    // MARK: - Phase Multiplier

    static func phaseMultiplier(for phase: Phase) -> Double {
        switch phase {
        case .personalBrand: return 1
        case .institutionalCapture: return 10
        case .worldGreatening: return 100
        case .spaceGreatening: return 10_000
        case .cosmicGreatening: return 1_000_000
        }
    }

    // MARK: - Attention Per Click (base + upgrade bonuses)

    static func calculateAttentionPerClick(state: GameState) -> Double {
        var total: Double = 1.0 // base
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .attentionPerClick {
                total += effect.value * Double(upgradeState.count)
            }
        }
        return total
    }
}
