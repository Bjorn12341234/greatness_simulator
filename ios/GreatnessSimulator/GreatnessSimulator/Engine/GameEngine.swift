import Foundation

struct GameEngine {
    // Stub — full implementation in Sprint 3
    static func tick(state: GameState, now: Double) {
        let dt = now - state.lastTickAt
        guard dt > 0 else { return }

        state.totalPlayTime += dt
        state.lastTickAt = now
    }
}
