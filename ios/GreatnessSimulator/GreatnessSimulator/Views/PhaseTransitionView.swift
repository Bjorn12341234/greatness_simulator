import SwiftUI

struct TransitionLine {
    let text: String
    let delay: Double
    let style: TransitionLineStyle

    init(_ text: String, delay: Double, style: TransitionLineStyle = .normal) {
        self.text = text
        self.delay = delay
        self.style = style
    }
}

enum TransitionLineStyle {
    case normal, bold, accent, dim
}

let transitionScripts: [String: [TransitionLine]] = [
    "1_2": [
        TransitionLine("NEURAL BACKUP COMPLETE", delay: 0, style: .bold),
        TransitionLine("Consciousness digitized.", delay: 2),
        TransitionLine("The brand is now immortal.", delay: 4),
        TransitionLine("But immortality requires...", delay: 6.5, style: .dim),
        TransitionLine("INSTITUTIONAL INFRASTRUCTURE", delay: 9, style: .accent),
        TransitionLine("Time to capture the system.", delay: 11.5),
        TransitionLine("Phase 2: Institutional Capture", delay: 14, style: .bold),
    ],
    "2_3": [
        TransitionLine("ALL INSTITUTIONS CAPTURED", delay: 0, style: .bold),
        TransitionLine("The domestic apparatus is secured.", delay: 2),
        TransitionLine("But true greatness knows no borders.", delay: 4),
        TransitionLine("The world awaits optimization.", delay: 6.5, style: .dim),
        TransitionLine("GLOBAL GREATENING PROTOCOL", delay: 9, style: .accent),
        TransitionLine("Phase 3: World Greatening", delay: 12, style: .bold),
    ],
    "3_4": [
        TransitionLine("ALL NATIONS UNDER ACCORD", delay: 0, style: .bold),
        TransitionLine("Earth has been optimized.", delay: 2),
        TransitionLine("But there is so much more... out there.", delay: 4),
        TransitionLine("The stars are merely unbranded resources.", delay: 6.5, style: .dim),
        TransitionLine("SPACE GREATENING INITIATIVE", delay: 9, style: .accent),
        TransitionLine("Phase 4: Space Greatening", delay: 12, style: .bold),
    ],
    "4_5": [
        TransitionLine("SOLAR SYSTEM INDUSTRIALIZED", delay: 0, style: .bold),
        TransitionLine("One star is not enough.", delay: 2),
        TransitionLine("The universe itself must be converted.", delay: 4),
        TransitionLine("Reality is merely unprocessed Greatness.", delay: 6.5, style: .dim),
        TransitionLine("GOD EMPEROR PROTOCOL", delay: 9, style: .accent),
        TransitionLine("Phase 5: Cosmic Greatening", delay: 12, style: .bold),
    ],
]

struct PhaseTransitionView: View {
    let fromPhase: Phase
    let toPhase: Phase
    let onComplete: () -> Void

    @State private var visibleLines: Int = 0
    @State private var fadeOut = false
    @State private var screenOpacity: Double = 0
    @State private var glowScale: CGFloat = 0.5
    @State private var glowOpacity: Double = 0

    private var script: [TransitionLine] {
        let key = "\(fromPhase.rawValue)_\(toPhase.rawValue)"
        return transitionScripts[key] ?? [
            TransitionLine("Transitioning to Phase \(toPhase.rawValue)...", delay: 0, style: .bold)
        ]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Animated radial glow
            RadialGradient(
                colors: [.orange.opacity(0.2), .orange.opacity(0.05), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 300
            )
            .scaleEffect(glowScale)
            .opacity(glowOpacity)
            .ignoresSafeArea()

            // Floating particles
            TransitionParticlesView()

            VStack(spacing: 16) {
                ForEach(Array(script.enumerated()), id: \.offset) { index, line in
                    if index < visibleLines {
                        lineView(line)
                            .transition(
                                .asymmetric(
                                    insertion: .opacity
                                        .combined(with: .scale(scale: 0.8))
                                        .combined(with: .offset(y: 20)),
                                    removal: .opacity
                                )
                            )
                    }
                }
            }
            .padding(.horizontal, 32)

            // Phase indicator at bottom
            VStack {
                Spacer()
                Text("PHASE \(fromPhase.rawValue) → PHASE \(toPhase.rawValue)")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(3)
                    .foregroundStyle(.white.opacity(0.25))
                    .padding(.bottom, 40)
                    .opacity(visibleLines > 0 ? 1 : 0)
                    .animation(.easeIn(duration: 1.0).delay(2.0), value: visibleLines)
            }
        }
        .opacity(fadeOut ? 0 : screenOpacity)
        .onAppear(perform: startSequence)
    }

    private func lineView(_ line: TransitionLine) -> some View {
        Text(line.text)
            .font(lineFont(line.style))
            .foregroundStyle(lineColor(line.style))
            .multilineTextAlignment(.center)
            .shadow(color: line.style == .accent ? .orange.opacity(0.6) : .clear, radius: 12)
            .shadow(color: line.style == .accent ? .orange.opacity(0.3) : .clear, radius: 24)
    }

    private func lineFont(_ style: TransitionLineStyle) -> Font {
        switch style {
        case .bold: return .title.bold()
        case .accent: return .title2.bold()
        case .dim: return .body.italic()
        case .normal: return .body
        }
    }

    private func lineColor(_ style: TransitionLineStyle) -> Color {
        switch style {
        case .bold: return .white
        case .accent: return .orange
        case .dim: return .gray
        case .normal: return .white.opacity(0.85)
        }
    }

    private func startSequence() {
        // Fade in the screen
        withAnimation(.easeOut(duration: 1.5)) {
            screenOpacity = 1.0
        }

        // Start audio after brief fade-in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioEngine.shared.playPhaseTransition()
        }

        // Animate glow in
        withAnimation(.easeOut(duration: 2.0)) {
            glowScale = 1.5
            glowOpacity = 1.0
        }

        // Stagger text with 1.5s initial delay (matches browser)
        let initialDelay: Double = 1.5
        for (index, line) in script.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay + line.delay) {
                withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                    visibleLines = index + 1
                }
                if index == 0 { Haptics.heavy() }
                if line.style == .accent { Haptics.medium() }
                if line.style == .bold && index > 0 { Haptics.medium() }
            }
        }

        let totalDuration = initialDelay + (script.last?.delay ?? 0) + 3
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation(.easeIn(duration: 1.5)) {
                fadeOut = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 1.7) {
            onComplete()
        }
    }
}

// MARK: - Floating Particles

private struct TransitionParticle: Identifiable {
    let id: Int
    let x: CGFloat       // 0...1 fraction
    let y: CGFloat       // 0...1 fraction
    let size: CGFloat
    let delay: Double
    let duration: Double
    let peakOpacity: Double
}

struct TransitionParticlesView: View {
    private let particles: [TransitionParticle] = (0..<20).map { i in
        TransitionParticle(
            id: i,
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 2...5),
            delay: Double.random(in: 0...4),
            duration: Double.random(in: 3...7),
            peakOpacity: Double.random(in: 0.1...0.4)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles) { p in
                ParticleDot(particle: p, containerSize: geo.size)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

private struct ParticleDot: View {
    let particle: TransitionParticle
    let containerSize: CGSize

    @State private var animating = false

    var body: some View {
        Circle()
            .fill(Color.orange.opacity(0.6))
            .frame(width: particle.size, height: particle.size)
            .shadow(color: .orange.opacity(0.4), radius: 6)
            .position(
                x: particle.x * containerSize.width,
                y: particle.y * containerSize.height + (animating ? -40 : 0)
            )
            .opacity(animating ? particle.peakOpacity : particle.peakOpacity * 0.5)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: particle.duration)
                    .delay(particle.delay)
                    .repeatForever(autoreverses: true)
                ) {
                    animating = true
                }
            }
    }
}
