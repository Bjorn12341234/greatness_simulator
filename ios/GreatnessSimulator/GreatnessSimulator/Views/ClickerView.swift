import SwiftUI

struct ClickerView: View {
    @Environment(GameState.self) private var game
    @Environment(\.theme) private var theme
    @State private var buttonScale: CGFloat = 1.0
    @State private var glowPulse: CGFloat = 1.0
    @State private var particles: [ClickParticle] = []

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                if game.greatnessPerSecond > 0 {
                    Text("\(Fmt.compact(game.greatnessPerSecond)) GpS")
                        .font(.subheadline)
                        .foregroundStyle(theme.greatnessColor.opacity(0.7))
                        .contentTransition(.numericText())
                }

                Button(action: handleClick) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [theme.accent.opacity(0.2), theme.accent.opacity(0.05), .clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 90
                                )
                            )
                            .frame(width: 180, height: 180)
                            .scaleEffect(glowPulse)

                        Circle()
                            .strokeBorder(theme.accent.opacity(0.3), lineWidth: 1)
                            .frame(width: 150, height: 150)

                        Circle()
                            .strokeBorder(theme.accent, lineWidth: 2)
                            .frame(width: 160, height: 160)

                        VStack(spacing: 4) {
                            Text("GENERATE")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("ATTENTION")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(theme.accent)
                    }
                }
                .buttonStyle(.plain)
                .scaleEffect(buttonScale)

                VStack(spacing: 4) {
                    Text("+\(Fmt.number(game.attentionPerClick)) attention per tap")
                        .font(.caption)
                        .foregroundStyle(theme.attentionColor.opacity(0.7))

                    Text("\(Fmt.compact(Double(game.clickCount))) taps total")
                        .font(.caption2)
                        .foregroundStyle(theme.textSecondary)
                }

                Spacer()
            }

            // Particle overlay
            TimelineView(.animation(paused: particles.isEmpty)) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    for p in particles {
                        let elapsed = now - p.spawnTime
                        guard elapsed < p.lifetime else { continue }
                        let progress = elapsed / p.lifetime
                        let alpha = 1.0 - progress

                        let x = p.startX + p.vx * elapsed
                        let y = p.startY + p.vy * elapsed + 40 * elapsed * elapsed // gravity

                        let radius = p.size * (1.0 - progress * 0.5)
                        let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                        context.opacity = alpha
                        context.fill(Path(ellipseIn: rect), with: .color(p.color))
                    }
                }
                .allowsHitTesting(false)
                .onChange(of: timeline.date) { _, _ in
                    let now = Date().timeIntervalSinceReferenceDate
                    particles.removeAll { now - $0.spawnTime >= $0.lifetime }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.08
            }
        }
    }

    private func handleClick() {
        game.click()
        Haptics.light()
        AudioEngine.shared.playTap()

        withAnimation(.spring(duration: 0.08, bounce: 0.5)) {
            buttonScale = 0.88
        }
        withAnimation(.spring(duration: 0.35, bounce: 0.5).delay(0.08)) {
            buttonScale = 1.0
        }

        emitParticles()
    }

    private let particleColors: [Color] = [
        Color(red: 1.0, green: 0.4, blue: 0.0),
        Color(red: 1.0, green: 0.53, blue: 0.2),
        Color(red: 1.0, green: 0.67, blue: 0.33),
        Color(red: 1.0, green: 0.33, blue: 0.0),
        Color(red: 1.0, green: 0.8, blue: 0.27),
    ]

    private func emitParticles() {
        let cx = UIScreen.main.bounds.width / 2
        let cy = UIScreen.main.bounds.height / 2 - 20
        let now = Date().timeIntervalSinceReferenceDate
        let count = 12

        for i in 0..<count {
            let angle = (Double.pi * 2 * Double(i)) / Double(count) + Double.random(in: -0.25...0.25)
            let speed = Double.random(in: 80...200)
            particles.append(ClickParticle(
                spawnTime: now,
                lifetime: Double.random(in: 0.5...0.9),
                startX: cx,
                startY: cy,
                vx: cos(angle) * speed,
                vy: sin(angle) * speed - 60,
                size: Double.random(in: 2.5...5),
                color: particleColors.randomElement()!
            ))
        }
    }
}

struct ClickParticle: Identifiable {
    let id = UUID()
    let spawnTime: Double
    let lifetime: Double
    let startX: Double
    let startY: Double
    let vx: Double
    let vy: Double
    let size: Double
    let color: Color
}

#Preview {
    ClickerView()
        .background(.black)
        .environment(GameState())
}
