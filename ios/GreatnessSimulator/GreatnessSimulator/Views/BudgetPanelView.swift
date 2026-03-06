import SwiftUI

struct BudgetPanelView: View {
    @Environment(GameState.self) private var game

    private var isAusterity: Bool {
        game.budget.healthcare < 10 && game.budget.education < 10 && game.budget.socialBenefits < 10
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isAusterity {
                    Text("AUSTERITY CRISIS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.red.opacity(0.15))
                        )
                }

                budgetSlider(label: "Healthcare", icon: "cross.case.fill", color: .green, keyPath: \.healthcare)
                budgetSlider(label: "Education", icon: "graduationcap.fill", color: .blue, keyPath: \.education)
                budgetSlider(label: "Social Benefits", icon: "person.3.fill", color: .teal, keyPath: \.socialBenefits)
                budgetSlider(label: "Military", icon: "shield.fill", color: .red, keyPath: \.military)
                budgetSlider(label: "Data Centers", icon: "server.rack", color: .orange, keyPath: \.dataCenters)
                budgetSlider(label: "Infrastructure", icon: "road.lanes", color: .yellow, keyPath: \.infrastructure)
                budgetSlider(label: "Propaganda", icon: "megaphone.fill", color: .purple, keyPath: \.propagandaBureau)
                budgetSlider(label: "Space Program", icon: "airplane", color: .cyan, keyPath: \.spaceProgram)

                // Summary
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Social Programs")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(Int(game.budget.healthcare + game.budget.education + game.budget.socialBenefits))%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Power Projection")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(Int(game.budget.military + game.budget.dataCenters + game.budget.propagandaBureau))%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(16)
        }
    }

    private func budgetSlider(label: String, icon: String, color: Color, keyPath: WritableKeyPath<BudgetAllocation, Double>) -> some View {
        @Bindable var game = game
        let value = game.budget[keyPath: keyPath]
        return VStack(spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(Int(value))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundStyle(color)
            }
            Slider(value: Binding(
                get: { game.budget[keyPath: keyPath] },
                set: { newValue in
                    adjustBudget(keyPath: keyPath, newValue: newValue)
                }
            ), in: 0...50, step: 1)
            .tint(color)
        }
    }

    private func adjustBudget(keyPath: WritableKeyPath<BudgetAllocation, Double>, newValue: Double) {
        let oldValue = game.budget[keyPath: keyPath]
        let diff = newValue - oldValue
        if abs(diff) < 0.5 { return }

        // Set the new value
        game.budget[keyPath: keyPath] = newValue

        // Proportionally adjust others to keep total at 100
        let allPaths: [WritableKeyPath<BudgetAllocation, Double>] = [
            \.healthcare, \.education, \.socialBenefits, \.military,
            \.dataCenters, \.infrastructure, \.propagandaBureau, \.spaceProgram
        ]
        let otherPaths = allPaths.filter { $0 != keyPath }
        let otherTotal = otherPaths.reduce(0.0) { $0 + game.budget[keyPath: $1] }

        if otherTotal > 0 {
            let targetOtherTotal = 100.0 - newValue
            let scale = targetOtherTotal / otherTotal
            for path in otherPaths {
                game.budget[keyPath: path] = max(0, game.budget[keyPath: path] * scale)
            }
        }
    }
}
