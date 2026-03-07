import SwiftUI

struct ClickerView: View {
    @Environment(GameState.self) private var game
    @Environment(\.theme) private var theme
    @State private var buttonScale: CGFloat = 1.0
    @State private var glowPulse: CGFloat = 1.0
    @State private var particles: [ClickParticle] = []
    @State private var buttonFrame: CGRect = .zero

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    // GpS display
                    if game.greatnessPerSecond > 0 {
                        Text("\(Fmt.compact(game.greatnessPerSecond)) GpS")
                            .font(.subheadline)
                            .foregroundStyle(theme.greatnessColor.opacity(0.7))
                            .contentTransition(.numericText())
                            .padding(.top, 8)
                    }

                    // Click button
                    Button(action: handleClick) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [theme.accent.opacity(0.2), theme.accent.opacity(0.05), .clear],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .scaleEffect(glowPulse)

                            Circle()
                                .strokeBorder(theme.accent.opacity(0.3), lineWidth: 1)
                                .frame(width: 130, height: 130)

                            Circle()
                                .strokeBorder(theme.accent, lineWidth: 2)
                                .frame(width: 140, height: 140)

                            VStack(spacing: 3) {
                                Text("GENERATE")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("ATTENTION")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            .foregroundStyle(theme.accent)
                        }
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(buttonScale)
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                buttonFrame = geo.frame(in: .global)
                            }.onChange(of: geo.frame(in: .global)) { _, newFrame in
                                buttonFrame = newFrame
                            }
                        }
                    )

                    // Click stats
                    HStack(spacing: 16) {
                        Text("+\(Fmt.number(game.attentionPerClick)) per tap")
                            .font(.caption)
                            .foregroundStyle(theme.attentionColor.opacity(0.7))
                        Text("\(Fmt.compact(Double(game.clickCount))) taps")
                            .font(.caption)
                            .foregroundStyle(theme.textSecondary)
                    }

                    // Upgrades section
                    UpgradeListContent()
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
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
                        let y = p.startY + p.vy * elapsed + 40 * elapsed * elapsed

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
        let cx = buttonFrame.midX
        let cy = buttonFrame.midY
        let now = Date().timeIntervalSinceReferenceDate

        for i in 0..<12 {
            let angle = (Double.pi * 2 * Double(i)) / 12.0 + Double.random(in: -0.25...0.25)
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
