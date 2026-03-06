import SwiftUI

struct TariffPanelView: View {
    @Environment(GameState.self) private var game

    private var totalCashPerMin: Double {
        tariffDefs.reduce(0) { sum, def in
            let level = game.tariffs[def.id]?.level ?? 0
            return sum + def.cashPerMinute[level]
        }
    }

    private var totalLegitDrain: Double {
        tariffDefs.reduce(0) { sum, def in
            let level = game.tariffs[def.id]?.level ?? 0
            return sum + def.legitimacyDrain[level]
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Summary
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tariff Revenue")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("+\(Fmt.compact(totalCashPerMin))/min")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Legitimacy Drain")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(String(format: "%.3f", totalLegitDrain))/s")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(totalLegitDrain < 0 ? .red : .green)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.top, 8)

                ForEach(tariffDefs, id: \.id) { def in
                    TariffCard(def: def)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct TariffCard: View {
    @Environment(GameState.self) private var game
    let def: TariffDef

    private var currentLevel: Int {
        game.tariffs[def.id]?.level ?? 0
    }

    private let levelNames = ["Off", "Low", "Med", "High"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: def.icon)
                    .font(.title3)
                    .foregroundStyle(currentLevel > 0 ? .orange : .gray)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(def.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text(def.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            // Level selector
            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { level in
                    Button {
                        game.setTariffLevel(tariffId: def.id, level: level)
                        Haptics.light()
                    } label: {
                        Text(levelNames[level])
                            .font(.caption2)
                            .fontWeight(currentLevel == level ? .bold : .regular)
                            .foregroundStyle(currentLevel == level ? .white : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(currentLevel == level ? levelColor(level).opacity(0.3) : Color.white.opacity(0.05))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Effect preview
            if currentLevel > 0 {
                HStack(spacing: 12) {
                    Text("+\(Fmt.compact(def.cashPerMinute[currentLevel]))/min")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    if def.legitimacyDrain[currentLevel] < 0 {
                        Text("\(String(format: "%.3f", def.legitimacyDrain[currentLevel])) legit/s")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                    if def.productionPenalty[currentLevel] < 0 {
                        Text("\(Int(def.productionPenalty[currentLevel] * 100))% prod")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(currentLevel > 0 ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
    }

    private func levelColor(_ level: Int) -> Color {
        switch level {
        case 0: return .gray
        case 1: return .yellow
        case 2: return .orange
        case 3: return .red
        default: return .gray
        }
    }
}
