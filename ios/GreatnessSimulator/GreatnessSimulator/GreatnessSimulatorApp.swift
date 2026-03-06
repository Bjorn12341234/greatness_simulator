import SwiftUI

@main
struct GreatnessSimulatorApp: App {
    @State private var gameState: GameState
    @State private var gameTimer: Timer?
    @State private var autoSaveTimer: Timer?
    @State private var offlineResult: OfflineResult?
    @State private var showOfflineReturn = false

    init() {
        if let saved = SaveEngine.load() {
            _gameState = State(initialValue: saved)
        } else {
            _gameState = State(initialValue: GameState())
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .environment(gameState)
                    .preferredColorScheme(.dark)
                    .onAppear { onAppLaunch() }

                if showOfflineReturn, let result = offlineResult {
                    OfflineReturnView(result: result) {
                        showOfflineReturn = false
                        offlineResult = nil
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                _ = SaveEngine.save(state: gameState)
                stopGameLoop()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                handleReturn()
                startGameLoop()
            }
        }
    }

    private func onAppLaunch() {
        // Calculate offline progress if returning
        if let result = OfflineEngine.calculate(state: gameState) {
            OfflineEngine.apply(result: result, to: gameState)
            if result.greatnessGained > 0 || result.cashGained > 0 || result.attentionGained > 0 {
                offlineResult = result
                showOfflineReturn = true
            }
        }
        startGameLoop()
        startAutoSave()
    }

    private func handleReturn() {
        if let result = OfflineEngine.calculate(state: gameState) {
            OfflineEngine.apply(result: result, to: gameState)
            if result.greatnessGained > 0 || result.cashGained > 0 || result.attentionGained > 0 {
                offlineResult = result
                showOfflineReturn = true
            }
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

    private func startAutoSave() {
        guard autoSaveTimer == nil else { return }
        let state = gameState
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            MainActor.assumeIsolated {
                state.lastSaveAt = Date().timeIntervalSince1970
                _ = SaveEngine.save(state: state)
            }
        }
    }
}
