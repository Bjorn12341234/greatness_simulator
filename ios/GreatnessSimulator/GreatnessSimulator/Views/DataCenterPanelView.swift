import SwiftUI

struct DataCenterPanelView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("GPU/TPU EMPIRE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(2)
                    .foregroundStyle(.orange.opacity(0.7))
                    .padding(.top, 8)

                ForEach(Array(dataCenterDefs.enumerated()), id: \.element.id) { index, def in
                    DataCenterNode(def: def, index: index)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct DataCenterNode: View {
    @Environment(GameState.self) private var game
    let def: DataCenterDef
    let index: Int

    private var isOwned: Bool {
        game.dataCenterUpgrades[def.id] == true
    }

    private var isAvailable: Bool {
        if isOwned { return false }
        if let prereq = def.prerequisite {
            return game.dataCenterUpgrades[prereq] == true
        }
        return true
    }

    private var canAfford: Bool {
        game.cash >= def.cost
    }

    var body: some View {
        VStack(spacing: 0) {
            // Connector line
            if index > 0 {
                Rectangle()
                    .fill(isAvailable || isOwned ? Color.orange.opacity(0.4) : Color.white.opacity(0.1))
                    .frame(width: 2, height: 20)
            }

            // Node card
            HStack(spacing: 12) {
                // Status dot
                Circle()
                    .fill(isOwned ? Color.green : (isAvailable ? Color.orange : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)

                Image(systemName: def.icon)
                    .font(.title3)
                    .foregroundStyle(isOwned ? .green : (isAvailable ? .orange : .gray))
                    .frame(width: 30)

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
                        .lineLimit(1)
                }

                Spacer()

                if isOwned {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else if isAvailable {
                    Button {
                        game.purchaseDataCenter(id: def.id)
                        Haptics.medium()
                    } label: {
                        Text(Fmt.compact(def.cost))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(canAfford ? .green : .gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(canAfford ? 0.1 : 0.03))
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!canAfford)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(isOwned ? 0.03 : 0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isAvailable && canAfford ? Color.orange.opacity(0.4) : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
}
