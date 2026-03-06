import SwiftUI

struct UpgradeListView: View {
    @Environment(GameState.self) private var game

    private var visibleUpgrades: [UpgradeData] {
        phase1Upgrades.filter { game.isUpgradeVisible($0) }
    }

    private var treeOrder: [String] {
        var seen: [String] = []
        for u in visibleUpgrades where !seen.contains(u.tree) {
            seen.append(u.tree)
        }
        return seen
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if visibleUpgrades.isEmpty {
                    Text("Keep generating attention to unlock upgrades...")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 60)
                } else {
                    ForEach(treeOrder, id: \.self) { tree in
                        treeSection(tree)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    private func treeSection(_ tree: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tree.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.5)
                .foregroundStyle(.orange.opacity(0.7))
                .padding(.leading, 4)

            ForEach(visibleUpgrades.filter { $0.tree == tree }) { upgrade in
                UpgradeCard(data: upgrade)
            }
        }
    }
}

// MARK: - Upgrade Card

struct UpgradeCard: View {
    @Environment(GameState.self) private var game
    let data: UpgradeData

    @State private var showPurchaseFlash = false

    private var state: UpgradeState {
        game.upgrades[data.id] ?? UpgradeState()
    }

    private var isMaxed: Bool {
        state.count >= data.maxCount
    }

    private var isAffordable: Bool {
        game.isUpgradeAffordable(data)
    }

    private var cost: Double {
        GameEngine.upgradeCost(data: data, currentCount: state.count)
    }

    private var costLabel: String {
        switch data.costResource {
        case .attention: return "attention"
        case .cash: return "cash"
        case .greatness: return "greatness"
        }
    }

    private var costColor: Color {
        switch data.costResource {
        case .attention: return .cyan
        case .cash: return .green
        case .greatness: return .yellow
        }
    }

    var body: some View {
        Button(action: handlePurchase) {
            cardContent
        }
        .buttonStyle(.plain)
        .disabled(isMaxed || !isAffordable)
        .opacity(isMaxed ? 0.6 : 1)
        .animation(.easeOut(duration: 0.15), value: isAffordable)
    }

    private var cardContent: some View {
        HStack(spacing: 12) {
            iconView
            infoView
            Spacer()
            costView
        }
        .padding(12)
        .background(cardBackground)
        .overlay(flashOverlay)
    }

    private var iconView: some View {
        let color: Color = isMaxed ? .green : (isAffordable ? .orange : .gray)
        return Image(systemName: data.icon)
            .font(.title2)
            .foregroundStyle(color)
            .frame(width: 40)
    }

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(data.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isMaxed ? Color.green : Color.white)

                if data.maxCount > 1 {
                    Text("\(state.count)/\(data.maxCount)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Text(data.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            effectsRow
        }
    }

    private var effectsRow: some View {
        HStack(spacing: 8) {
            if data.production > 0 {
                Text("+\(Fmt.compact(data.production)) GpS")
                    .font(.caption2)
                    .foregroundStyle(.yellow.opacity(0.8))
            }
            ForEach(Array(data.effects.enumerated()), id: \.offset) { _, effect in
                Text(effectLabel(effect))
                    .font(.caption2)
                    .foregroundStyle(.cyan.opacity(0.8))
            }
        }
    }

    @ViewBuilder
    private var costView: some View {
        if isMaxed {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        } else {
            VStack(alignment: .trailing, spacing: 2) {
                Text(Fmt.compact(cost))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(isAffordable ? costColor : Color.gray)
                Text(costLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var cardBackground: some View {
        let bgOpacity: Double = isMaxed ? 0.03 : 0.06
        let borderColor: Color = (isAffordable && !isMaxed) ? costColor.opacity(0.4) : .clear
        return RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(bgOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
    }

    private var flashOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.orange.opacity(showPurchaseFlash ? 0.3 : 0))
    }

    private func handlePurchase() {
        guard game.purchaseUpgrade(id: data.id) else { return }
        Haptics.medium()

        // Flash animation
        withAnimation(.easeIn(duration: 0.05)) {
            showPurchaseFlash = true
        }
        withAnimation(.easeOut(duration: 0.3).delay(0.05)) {
            showPurchaseFlash = false
        }
    }

    private func effectLabel(_ effect: UpgradeEffect) -> String {
        switch effect.type {
        case .attentionPerClick: return "+\(Fmt.compact(effect.value)) /tap"
        case .attentionPerSecond: return "+\(Fmt.compact(effect.value)) attn/s"
        case .cashPerSecond: return "+\(Fmt.compact(effect.value)) $/s"
        case .gpsMultiplier: return "x\(String(format: "%.2g", effect.value)) GpS"
        }
    }
}

#Preview {
    UpgradeListView()
        .background(.black)
        .environment(GameState())
}
