import SwiftUI

struct FleetPanelView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Shipyard section
                shipyardSection

                // Build queue
                if let queue = game.shipyardQueue {
                    buildQueueSection(queue: queue)
                }

                // Ship classes
                ForEach(shipClassDefs, id: \.id) { def in
                    shipClassCard(def: def)
                }
            }
            .padding()
        }
    }

    // MARK: - Shipyard

    private var shipyardSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundStyle(.cyan)
                Text("SHIPYARD")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("Level \(game.shipyardLevel)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.cyan)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Production: \(game.shipyardLevel) ship\(game.shipyardLevel == 1 ? "" : "s") per 10s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                let cost = shipyardUpgradeCost(currentLevel: game.shipyardLevel)
                Button {
                    game.upgradeShipyard()
                    Haptics.medium()
                } label: {
                    Text("Upgrade $\(Fmt.compact(cost))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            game.cash >= cost
                                ? Color.cyan.opacity(0.2)
                                : Color(white: 0.15)
                        )
                        .foregroundStyle(game.cash >= cost ? .cyan : .secondary)
                        .cornerRadius(8)
                }
                .disabled(game.cash < cost)
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    // MARK: - Build Queue

    private func buildQueueSection(queue: ShipyardOrder) -> some View {
        let def = shipClassRegistry[queue.shipId]
        let now = Date().timeIntervalSince1970
        let buildInterval = 10.0 / Double(game.shipyardLevel)
        let elapsed = now - queue.lastBuildAt
        let currentShipProgress = min(1.0, elapsed / buildInterval)

        return VStack(spacing: 8) {
            HStack {
                Image(systemName: "hammer.fill")
                    .foregroundStyle(.orange)
                Text("BUILDING")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(queue.builtSoFar)/\(queue.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            }

            if let def {
                Text(def.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ProgressView(value: Double(queue.builtSoFar), total: Double(queue.quantity))
                .tint(.orange)

            // Current ship progress
            HStack {
                Text("Current ship:")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                ProgressView(value: currentShipProgress)
                    .tint(.yellow)
                    .frame(width: 100)
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    // MARK: - Ship Class Card

    private func shipClassCard(def: ShipClassDef) -> some View {
        let count = game.fleet[def.id, default: 0]
        let canBuild = game.shipyardLevel >= def.requiresShipyard && game.shipyardQueue == nil
        let canAfford1 = game.cash >= def.costCash
        let canAfford5 = game.cash >= def.costCash * 5
        let canAfford10 = game.cash >= def.costCash * 10

        return VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: def.icon)
                    .font(.title2)
                    .foregroundStyle(game.shipyardLevel >= def.requiresShipyard ? .orange : .secondary)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(def.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        if count > 0 {
                            Text("x\(count)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }
                    }
                    Text(def.description)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()
            }

            // Stats
            HStack(spacing: 16) {
                statLabel(icon: "bolt.shield.fill", label: "War", value: "\(Int(def.warOutput))", color: .red)
                statLabel(icon: "exclamationmark.triangle.fill", label: "Fear", value: "+\(Int(def.fear))", color: .orange)
                statLabel(icon: "medal.fill", label: "Nobel", value: "\(Int(def.nobelImpact))", color: def.nobelImpact >= 0 ? .yellow : .red)
                statLabel(icon: "dollarsign.circle", label: "Cost", value: "$\(Fmt.compact(def.costCash))", color: .green)
            }

            // Special text
            if let special = def.special {
                Text(special)
                    .font(.system(size: 9))
                    .italic()
                    .foregroundStyle(.yellow.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Build buttons
            if game.shipyardLevel >= def.requiresShipyard {
                HStack(spacing: 8) {
                    buildButton(shipId: def.id, quantity: 1, enabled: canBuild && canAfford1)
                    buildButton(shipId: def.id, quantity: 5, enabled: canBuild && canAfford5)
                    buildButton(shipId: def.id, quantity: 10, enabled: canBuild && canAfford10)
                    Spacer()
                }
            } else {
                Text("Requires Shipyard Level \(def.requiresShipyard)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            count > 0 ? Color.orange.opacity(0.3) : Color(white: 0.2),
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - Helpers

    private func statLabel(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 1) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(color)
        }
    }

    private func buildButton(shipId: String, quantity: Int, enabled: Bool) -> some View {
        Button {
            game.buildShip(shipId: shipId, quantity: quantity)
            Haptics.medium()
        } label: {
            Text("Build \(quantity)")
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(enabled ? Color.orange.opacity(0.2) : Color(white: 0.08))
                .foregroundStyle(enabled ? .orange : .secondary)
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
