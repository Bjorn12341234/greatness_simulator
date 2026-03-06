import SwiftUI

struct ClickerView: View {
    @Environment(GameState.self) private var game
    @State private var buttonScale: CGFloat = 1.0
    @State private var floatingTexts: [FloatingText] = []

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                // GpS display
                if game.greatnessPerSecond > 0 {
                    Text("\(Fmt.compact(game.greatnessPerSecond)) GpS")
                        .font(.subheadline)
                        .foregroundStyle(.yellow.opacity(0.7))
                        .contentTransition(.numericText())
                }

                // Main click button
                Button(action: handleClick) {
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.orange.opacity(0.2), .orange.opacity(0.05), .clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 90
                                )
                            )
                            .frame(width: 180, height: 180)

                        // Inner ring
                        Circle()
                            .strokeBorder(.orange.opacity(0.3), lineWidth: 1)
                            .frame(width: 150, height: 150)

                        // Main circle
                        Circle()
                            .strokeBorder(.orange, lineWidth: 2)
                            .frame(width: 160, height: 160)

                        // Label
                        VStack(spacing: 4) {
                            Text("DECLARE")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("GREATNESS")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundStyle(.orange)
                    }
                }
                .buttonStyle(.plain)
                .scaleEffect(buttonScale)

                // Click stats
                VStack(spacing: 4) {
                    Text("+\(Fmt.number(game.attentionPerClick)) attention per tap")
                        .font(.caption)
                        .foregroundStyle(.cyan.opacity(0.7))

                    Text("\(Fmt.compact(Double(game.clickCount))) taps total")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            // Floating "+N" text particles
            ForEach(floatingTexts) { ft in
                Text("+\(Fmt.compact(ft.amount))")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.cyan)
                    .position(x: ft.x, y: ft.y)
                    .opacity(ft.opacity)
            }
        }
    }

    private func handleClick() {
        game.click()
        Haptics.light()

        // Button press animation
        withAnimation(.spring(duration: 0.1)) {
            buttonScale = 0.92
        }
        withAnimation(.spring(duration: 0.2).delay(0.1)) {
            buttonScale = 1.0
        }

        // Spawn floating text
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

        // Animate up and fade out
        withAnimation(.easeOut(duration: 0.8)) {
            if let i = floatingTexts.firstIndex(where: { $0.id == id }) {
                floatingTexts[i].y -= 60
                floatingTexts[i].opacity = 0
            }
        }

        // Remove after animation
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
