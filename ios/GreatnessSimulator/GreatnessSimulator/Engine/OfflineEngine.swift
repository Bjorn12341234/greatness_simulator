import Foundation

struct OfflineResult {
    let elapsedSeconds: Double
    let greatnessGained: Double
    let cashGained: Double
    let attentionGained: Double
    let legitimacyAfter: Double
}

struct OfflineEngine {
    static let minimumOfflineSeconds: Double = 60

    static func calculate(state: GameState) -> OfflineResult? {
        let now = Date().timeIntervalSince1970
        let elapsed = now - state.lastTickAt

        guard elapsed >= minimumOfflineSeconds else { return nil }

        let gps = GameEngine.calculateGPS(state: state)
        let attPS = GameEngine.calculateAttentionPerSecond(state: state)
        let cashPS = GameEngine.calculateCashPerSecond(state: state)
        let offlineRate = prestigeOfflineRate(upgrades: state.prestigeUpgrades)

        let greatnessGained = gps * elapsed * offlineRate
        let cashGained = cashPS * elapsed * offlineRate
        let attentionGained = attPS * elapsed * offlineRate

        // Legitimacy change during offline
        let legitFloor = prestigeLegitimacyFloor(upgrades: state.prestigeUpgrades)
        let legitimacyAfter = max(legitFloor, min(100, state.legitimacy))

        return OfflineResult(
            elapsedSeconds: elapsed,
            greatnessGained: greatnessGained,
            cashGained: cashGained,
            attentionGained: attentionGained,
            legitimacyAfter: legitimacyAfter
        )
    }

    static func apply(result: OfflineResult, to state: GameState) {
        state.greatness += result.greatnessGained
        state.cash += result.cashGained
        state.attention += result.attentionGained
        state.legitimacy = result.legitimacyAfter
        state.lastTickAt = Date().timeIntervalSince1970
    }
}
