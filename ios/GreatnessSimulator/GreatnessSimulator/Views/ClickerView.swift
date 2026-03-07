import SwiftUI

struct ClickerView: View {
    @Environment(GameState.self) private var game
    @Environment(\.theme) private var theme
    @State private var buttonScale: CGFloat = 1.0
    @State private var glowPulse: CGFloat = 1.0
    @State private var floatingTexts: [FloatingText] = []

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
                            Text("DECLARE")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("GREATNESS")
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

            ForEach(floatingTexts) { ft in
                Text("+\(Fmt.compact(ft.amount))")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.attentionColor)
                    .position(x: ft.x, y: ft.y)
                    .opacity(ft.opacity)
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

        spawnFloatingText()
    }

    private func spawnFloatingText() {
        let id = UUID()
        let xOffset = CGFloat.random(in: -40...40)
        let ft = FloatingText(
            id: id,
            amount: game.attentionPerClick,
            x: UIScreen.main.bounds.width / 2 + xOffset,
            y: UIScreen.main.bounds.height / 2 - 40,
            opacity: 1.0
        )
        floatingTexts.append(ft)

        withAnimation(.easeOut(duration: 0.8)) {
            if let i = floatingTexts.firstIndex(where: { $0.id == id }) {
                floatingTexts[i].y -= 60
                floatingTexts[i].opacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            floatingTexts.removeAll { $0.id == id }
        }
    }
}

struct FloatingText: Identifiable {
    let id: UUID
    let amount: Double
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}

#Preview {
    ClickerView()
        .background(.black)
        .environment(GameState())
}
