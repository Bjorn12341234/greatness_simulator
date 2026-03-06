import SwiftUI

@main
struct GreatnessSimulatorApp: App {
    @State private var gameState = GameState()
    @State private var gameTimer: Timer?

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(gameState)
                .preferredColorScheme(.dark)
                .onAppear { startGameLoop() }
                .onDisappear { stopGameLoop() }
        }
    }

    private func startGameLoop() {
        guard gameTimer == nil else { return }
        let state = gameState
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            MainActor.assumeIsolated {
                GameEngine.tick(state: state, now: Date().timeIntervalSince1970)
            }
        }
    }

    private func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
