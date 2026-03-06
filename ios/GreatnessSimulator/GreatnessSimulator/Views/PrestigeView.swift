import SwiftUI

struct PrestigeView: View {
    @Environment(GameState.self) private var game

    @State private var showConfirmation = false

    private var pendingPoints: Int {
        calculatePrestigePoints(greatnessUnits: game.greatnessUnits)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                prestigeHeader
                if game.prestigeLevel > 0 || pendingPoints > 0 {
                    prestigeStats
                }
                prestigeButton
                upgradesList
            }
            .padding()
        }
        .background(Color.black)
        .alert("Prestige Reset", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Prestige", role: .destructive) {
                game.prestige()
                Haptics.heavy()
            }
        } message: {
            Text("Reset all progress and earn \(pendingPoints) Prestige Points. Your prestige upgrades and achievements are kept.")
        }
    }

    // MARK: - Header

    private var prestigeHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundStyle(.yellow)

            Text("PRESTIGE")
                .font(.title2)
                .fontWeight(.black)
                .tracking(4)
                .foregroundStyle(.yellow)

            Text("Sacrifice everything. Become greater.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Stats

    private var prestigeStats: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                statBox(label: "Level", value: "\(game.prestigeLevel)", color: .yellow)
                statBox(label: "Points", value: Fmt.compact(game.prestigePoints), color: .orange)
            }

            if game.prestigeLevel > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundStyle(.green)
                    Text("GpS Bonus: +\(game.prestigeLevel * 10)%")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }

    private func statBox(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Prestige Button

    private var prestigeButton: some View {
        VStack(spacing: 8) {
            Button {
                if pendingPoints > 0 {
                    showConfirmation = true
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                    Text("PRESTIGE FOR \(pendingPoints) PP")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(pendingPoints > 0 ? Color.yellow : Color.gray.opacity(0.3))
                .foregroundStyle(pendingPoints > 0 ? .black : .secondary)
                .cornerRadius(12)
            }
            .disabled(pendingPoints <= 0)

            if pendingPoints <= 0 {
                Text("Earn Greatness Units in Phase 5 to unlock prestige")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text("Based on \(Fmt.compact(game.greatnessUnits)) Greatness Units")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Upgrades List

    private var upgradesList: some View {
        VStack(spacing: 12) {
            Text("PRESTIGE UPGRADES")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(prestigeUpgradeDefs) { def in
                upgradeCard(def)
            }
        }
    }

    private func upgradeCard(_ def: PrestigeUpgradeData) -> some View {
        let owned = game.prestigeUpgrades[def.id] == true
        let canAfford = game.prestigePoints >= def.cost
        let prereqsMet = def.prerequisites.allSatisfy { game.prestigeUpgrades[$0] == true }
        let available = !owned && canAfford && prereqsMet

        return HStack(spacing: 12) {
            Image(systemName: def.icon)
                .font(.title2)
                .foregroundStyle(owned ? .yellow : (available ? .white : .secondary))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(def.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(owned ? .yellow : .white)

                    if owned {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }

                Text(def.description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                if !owned {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                        Text("\(Int(def.cost)) PP")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(canAfford ? .yellow : .red)
                }

                if !prereqsMet && !owned {
                    let missing = def.prerequisites.filter { game.prestigeUpgrades[$0] != true }
                    let names = missing.compactMap { prestigeUpgradeRegistry[$0]?.name }
                    Text("Requires: \(names.joined(separator: ", "))")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            if available {
                Button {
                    game.purchasePrestigeUpgrade(id: def.id)
                    Haptics.medium()
                } label: {
                    Text("BUY")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding(12)
        .background(Color(white: owned ? 0.12 : 0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(owned ? Color.yellow.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

#Preview {
    PrestigeView()
        .environment(GameState())
}
