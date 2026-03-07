import SwiftUI

struct EventModalView: View {
    @Environment(GameState.self) private var game
    let event: GameEvent
    let onDismiss: () -> Void

    @State private var appeared = false
    @State private var buttonsEnabled = false

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {} // block taps

            // Content
            VStack(spacing: 0) {
                Spacer()
                cardContent
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                buttonsEnabled = true
            }
        }
    }

    private var cardContent: some View {
        VStack(spacing: 20) {
            categoryBadge
            headlineText
            contextText
            choiceButtons
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(categoryColor.opacity(0.4), lineWidth: 1)
                )
        )
    }

    private var categoryBadge: some View {
        Text(event.category.rawValue.uppercased())
            .font(.caption2)
            .fontWeight(.bold)
            .tracking(2)
            .foregroundStyle(categoryColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(categoryColor.opacity(0.15))
            )
    }

    private var headlineText: some View {
        Text(event.headline)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }

    private var contextText: some View {
        Text(event.context)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }

    private var choiceButtons: some View {
        VStack(spacing: 12) {
            ForEach(Array(event.choices.enumerated()), id: \.offset) { index, choice in
                choiceButton(choice, index: index)
            }
        }
    }

    private func choiceButton(_ choice: EventChoice, index: Int) -> some View {
        Button {
            game.resolveEvent(choice: choice)
            Haptics.medium()
            withAnimation(.easeOut(duration: 0.2)) {
                appeared = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                onDismiss()
            }
        } label: {
            VStack(spacing: 4) {
                Text(choice.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                if let desc = choice.description {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                effectsPreview(choice.effects)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(!buttonsEnabled)
        .opacity(buttonsEnabled ? 1 : 0.4)
    }

    private func effectsPreview(_ effects: [Effect]) -> some View {
        HStack(spacing: 8) {
            ForEach(Array(effects.enumerated()), id: \.offset) { _, effect in
                let color = effectColor(effect.resource)
                let sign = effect.amount >= 0 ? "+" : ""
                Text("\(sign)\(Fmt.compact(effect.amount)) \(effectLabel(effect.resource))")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(effect.amount >= 0 ? color : .red)
            }
        }
    }

    private func effectColor(_ resource: String) -> Color {
        switch resource {
        case "attention": return .cyan
        case "cash": return .green
        case "greatness": return .yellow
        case "influence": return .purple
        case "legitimacy": return .blue
        default: return .white
        }
    }

    private func effectLabel(_ resource: String) -> String {
        switch resource {
        case "attention": return "attn"
        case "greatness": return "great"
        default: return resource
        }
    }

    private var categoryColor: Color {
        switch event.category {
        case .scandal: return .red
        case .opportunity: return .green
        case .absurd: return .purple
        case .contradiction: return .orange
        case .crisis: return .red
        case .nobel: return .yellow
        case .realityGlitch: return .cyan
        }
    }
}
