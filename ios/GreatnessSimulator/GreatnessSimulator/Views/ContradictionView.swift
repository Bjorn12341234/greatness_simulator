import SwiftUI

struct ContradictionView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if game.doublethinkTokens > 0 {
                    HStack {
                        Image(systemName: "puzzlepiece.fill")
                            .foregroundStyle(.purple)
                        Text("Doublethink Tokens: \(Int(game.doublethinkTokens))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                ForEach(activeContradictions, id: \.id) { info in
                    contradictionCard(info)
                }

                if activeContradictions.isEmpty {
                    Text("No contradictions active yet.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                }
            }
            .padding()
        }
        .background(Color.black)
    }

    // MARK: - Active Contradictions

    private struct ContradictionInfo: Identifiable {
        let id: String
        let labelA: String
        let labelB: String
        let state: ContradictionState
    }

    private var activeContradictions: [ContradictionInfo] {
        var results: [ContradictionInfo] = []

        let defs: [(String, String, String, Int)] = [
            ("attention_credibility", "Attention", "Credibility", 1),
            ("control_legitimacy", "Control", "Legitimacy", 2),
            ("war_nobel", "War", "Nobel", 3),
            ("expansion_stability", "Expansion", "Stability", 3),
            ("longterm_shortterm", "Long-Term", "Short-Term", 4),
            ("greatness_meaning", "Greatness", "Meaning", 5),
        ]

        for (id, labelA, labelB, minPhase) in defs {
            guard game.phase.rawValue >= minPhase else { continue }
            guard let state = game.contradictions[id], state.active else { continue }
            results.append(ContradictionInfo(id: id, labelA: labelA, labelB: labelB, state: state))
        }

        return results
    }

    // MARK: - Card

    private func contradictionCard(_ info: ContradictionInfo) -> some View {
        let isBalanced = info.state.sideA >= ContradictionEngine.balanceThreshold &&
                         info.state.sideB >= ContradictionEngine.balanceThreshold

        return VStack(spacing: 10) {
            // Title
            HStack {
                Text("\(info.labelA) vs \(info.labelB)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Spacer()

                if isBalanced {
                    Text("BALANCED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.yellow.opacity(0.2))
                        .clipShape(Capsule())
                }
            }

            // Seesaw bar
            seesawBar(sideA: info.state.sideA, sideB: info.state.sideB, isBalanced: isBalanced)

            // Labels
            HStack {
                Text("\(info.labelA): \(Int(info.state.sideA))%")
                    .font(.caption)
                    .foregroundStyle(.orange)
                Spacer()
                Text("\(info.labelB): \(Int(info.state.sideB))%")
                    .font(.caption)
                    .foregroundStyle(.green)
            }

            // Status
            if isBalanced {
                Text("Earning Doublethink Tokens")
                    .font(.caption2)
                    .foregroundStyle(.yellow.opacity(0.8))
            } else if info.id == "attention_credibility" && info.state.sideB < 30 {
                Text("LOW CREDIBILITY — Cash generation reduced")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isBalanced ? Color.yellow.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }

    // MARK: - Seesaw Bar

    private func seesawBar(sideA: Double, sideB: Double, isBalanced: Bool) -> some View {
        GeometryReader { geo in
            let width = geo.size.width
            let threshold = width * ContradictionEngine.balanceThreshold / 100

            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(white: 0.15))

                // Side A (left, orange)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.orange.opacity(0.6))
                    .frame(width: width * sideA / 100)

                // Side B (right, green)
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green.opacity(0.6))
                        .frame(width: width * sideB / 100)
                }

                // Balance zone markers
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1, height: 12)
                    .offset(x: threshold)

                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1, height: 12)
                    .offset(x: width - threshold)

                // Glow when balanced
                if isBalanced {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.yellow.opacity(0.1))
                }
            }
        }
        .frame(height: 16)
    }
}
