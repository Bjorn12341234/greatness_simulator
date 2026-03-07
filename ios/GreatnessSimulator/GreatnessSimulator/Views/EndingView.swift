import SwiftUI

struct FloatingParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let duration: Double
    let delay: Double
}

struct EndingView: View {
    @Environment(GameState.self) private var game
    @State private var currentScreen = 0
    @State private var lineOpacities: [Double] = [0, 0, 0, 0]
    @State private var visible = true
    @State private var particlesActive = false

    private let cosmicAccent = Color(red: 0.6, green: 0.2, blue: 1.0)

    private let particles: [FloatingParticle] = (0..<20).map { _ in
        FloatingParticle(
            x: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 2...6),
            duration: Double.random(in: 3...6),
            delay: Double.random(in: 0...3)
        )
    }

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

                // Floating particles
                GeometryReader { geo in
                    ForEach(particles) { p in
                        Circle()
                            .fill(cosmicAccent.opacity(particlesActive ? 0.6 : 0))
                            .frame(width: p.size, height: p.size)
                            .position(
                                x: p.x * geo.size.width,
                                y: particlesActive
                                    ? geo.size.height * CGFloat.random(in: 0.1...0.4)
                                    : geo.size.height * 0.8
                            )
                            .scaleEffect(particlesActive ? 1.5 : 0)
                            .animation(
                                .easeOut(duration: p.duration)
                                    .delay(p.delay)
                                    .repeatForever(autoreverses: false),
                                value: particlesActive
                            )
                    }
                }
                .allowsHitTesting(false)

                // Content
                VStack {
                    Spacer()
                    screenContent
                    Spacer()
                }
                .padding(.horizontal, 32)
            }
            .transition(.opacity)
            .onAppear {
                particlesActive = true
                startSequence()
            }
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
