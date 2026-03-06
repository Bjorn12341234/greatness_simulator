import SwiftUI

@main
struct GreatnessSimulatorApp: App {
    @State private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(gameState)
                .preferredColorScheme(.dark)
        }
    }
}
