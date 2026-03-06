import SwiftUI

struct LoyaltyPanelView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Loyalty display
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.purple)
                    Text("Loyalty: \(Fmt.compact(game.loyalty))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.purple)
                }
                .padding(.top, 8)

                ForEach(loyaltyUpgradeDefs, id: \.id) { def in
                    LoyaltyCard(def: def)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct LoyaltyCard: View {
    @Environment(GameState.self) private var game
    let def: LoyaltyUpgradeDef

    private var isOwned: Bool {
        game.loyaltyUpgrades[def.id] == true
    }

    private var canAfford: Bool {
        game.loyalty >= def.costLoyalty && game.cash >= def.costCash
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: def.icon)
                .font(.title2)
                .foregroundStyle(isOwned ? .green : (canAfford ? .purple : .gray))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(def.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isOwned ? .green : .white)
                Text(def.description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(def.flavorText)
                    .font(.caption2)
                    .italic()
                    .foregroundStyle(.secondary.opacity(0.7))
                    .lineLimit(2)
            }

            Spacer()

            if isOwned {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Button {
                    game.purchaseLoyaltyUpgrade(id: def.id)
                    Haptics.medium()
                } label: {
                    VStack(spacing: 2) {
                        Text("\(Fmt.compact(def.costLoyalty)) loyalty")
                            .font(.caption2)
                            .foregroundStyle(game.loyalty >= def.costLoyalty ? .purple : .red)
                        Text("\(Fmt.compact(def.costCash)) $")
                            .font(.caption2)
                            .foregroundStyle(game.cash >= def.costCash ? .green : .red)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(canAfford ? 0.1 : 0.03))
                    )
                }
                .buttonStyle(.plain)
                .disabled(!canAfford)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(isOwned ? 0.03 : 0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(canAfford && !isOwned ? Color.purple.opacity(0.4) : Color.clear, lineWidth: 1)
                )
        )
    }
}
