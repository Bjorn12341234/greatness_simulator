import SwiftUI

struct EndingView: View {
    @Environment(GameState.self) private var game
    @State private var currentScreen = 0
    @State private var lineOpacities: [Double] = [0, 0, 0, 0]
    @State private var visible = true

    private let cosmicAccent = Color(red: 0.6, green: 0.2, blue: 1.0)

    var body: some View {
        if visible {
            ZStack {
                // Background
                RadialGradient(
                    colors: [Color(red: 0.04, green: 0, blue: 0.08), .black],
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
                .ignoresSafeArea()

                // Content
                VStack {
                    Spacer()
                    screenContent
                    Spacer()
                }
                .padding(.horizontal, 32)
            }
            .transition(.opacity)
            .onAppear { startSequence() }
        }
    }

    @ViewBuilder
    private var screenContent: some View {
        switch currentScreen {
        case 0:
            Text("THE UNIVERSE IS NOW GREAT.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(cosmicAccent)
                .shadow(color: cosmicAccent.opacity(0.5), radius: 30)
                .multilineTextAlignment(.center)
                .transition(.opacity.combined(with: .scale))

        case 1:
            Text("...")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .transition(.opacity)

        case 2:
            Text("GREATNESS MUST BE MAINTAINED.")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .transition(.opacity.combined(with: .scale))

        case 3:
            VStack(spacing: 12) {
                ForEach(0..<4) { i in
                    Text(finalLines[i])
                        .font(.body)
                        .fontWeight(i == 3 ? .bold : .regular)
                        .foregroundStyle(i == 3 ? .red : .white)
                        .shadow(color: i == 3 ? .red.opacity(0.3) : .clear, radius: 20)
                        .opacity(lineOpacities[i])
                }
            }
            .multilineTextAlignment(.center)
            .transition(.opacity)

        default:
            EmptyView()
        }
    }

    private let finalLines = [
        "ALERT: GREATNESS DECAY DETECTED.",
        "MAINTENANCE PROTOCOL: ACTIVE.",
        "OPTIMIZATION: REQUIRED.",
        "FOREVER.",
    ]

    private func startSequence() {
        // Screen 0: 0-5s
        // Screen 1: 5-10s
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.5)) { currentScreen = 1 }
        }
        // Screen 2: 10-15s
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation(.easeInOut(duration: 1.5)) { currentScreen = 2 }
        }
        // Screen 3: 15-23s (with staggered lines)
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            withAnimation(.easeInOut(duration: 1.5)) { currentScreen = 3 }
            for i in 0..<4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                    withAnimation(.easeIn(duration: 0.8)) { lineOpacities[i] = 1.0 }
                }
            }
        }
        // Dismiss after ~23s
        DispatchQueue.main.asyncAfter(deadline: .now() + 23) {
            withAnimation(.easeOut(duration: 1.5)) { visible = false }
            game.universe.endingComplete = true
        }
    }
}
