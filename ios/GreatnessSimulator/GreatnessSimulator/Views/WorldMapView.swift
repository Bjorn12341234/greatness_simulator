import SwiftUI

struct WorldMapView: View {
    @Environment(GameState.self) private var game
    @State private var expandedCountry: String? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Azure State special card
                countryCard(def: azureStateDef)

                // Regular countries grouped by region
                ForEach(countryDefs, id: \.id) { def in
                    countryCard(def: def)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Country Card

    @ViewBuilder
    private func countryCard(def: CountryDef) -> some View {
        let state = game.countries[def.id] ?? CountryState()
        let isExpanded = expandedCountry == def.id

        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandedCountry = isExpanded ? nil : def.id
                }
            } label: {
                HStack(spacing: 10) {
                    // Status dot
                    Circle()
                        .fill(statusColor(state.status))
                        .frame(width: 10, height: 10)

                    Image(systemName: def.icon)
                        .foregroundStyle(statusColor(state.status))
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(def.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)

                            if def.id == "azure_state" {
                                Text("SPECIAL")
                                    .font(.system(size: 8, weight: .bold))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(.blue.opacity(0.3))
                                    .foregroundStyle(.blue)
                                    .cornerRadius(3)
                            }
                        }
                        Text(def.region)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    // Status badge
                    Text(statusLabel(state.status))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(statusColor(state.status).opacity(0.2))
                        .foregroundStyle(statusColor(state.status))
                        .cornerRadius(4)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(12)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 10) {
                    // Description
                    Text(def.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Special mechanic
                    if let special = def.specialDescription {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text(special)
                                .font(.caption2)
                                .foregroundStyle(.yellow.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Stats bars
                    HStack(spacing: 16) {
                        statBar(label: "Resistance", value: state.resistance, color: .red)
                        statBar(label: "Stability", value: state.stability, color: .blue)
                    }

                    // Special mechanic indicators
                    specialMechanicIndicators(def: def, state: state)

                    // GpS potential
                    HStack {
                        Text("Greatness Potential:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("+\(Fmt.compact(def.greatnessPotential)) GpS")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.yellow)
                        Spacer()
                        Text("Nobel Optics: \(def.nobelOptics > 0 ? "+" : "")\(Int(def.nobelOptics))")
                            .font(.caption2)
                            .foregroundStyle(def.nobelOptics >= 0 ? .green : .red)
                    }

                    // Active operations
                    if !state.activeOperations.isEmpty {
                        VStack(spacing: 4) {
                            Text("ACTIVE OPERATIONS")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.cyan)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(Array(state.activeOperations.enumerated()), id: \.offset) { _, op in
                                if let tacticDef = tacticRegistry[op.tacticType] {
                                    HStack {
                                        Text(tacticDef.name)
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                        Spacer()
                                        let now = Date().timeIntervalSince1970
                                        let elapsed = now - op.startedAt
                                        let progress = min(1.0, elapsed / op.duration)
                                        let remaining = max(0, op.duration - elapsed)
                                        ProgressView(value: progress)
                                            .tint(.orange)
                                            .frame(width: 60)
                                        Text(Fmt.duration(remaining))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 40, alignment: .trailing)
                                    }
                                }
                            }
                        }
                    }

                    // Available tactics (only if not annexed)
                    if state.status != .annexed && state.status != .allied {
                        tacticButtons(countryId: def.id, state: state)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            state.status == .annexed ? Color.green.opacity(0.4) :
                            state.status == .occupied ? Color.orange.opacity(0.4) :
                            Color(white: 0.2),
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - Stat Bar

    private func statBar(label: String, value: Double, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
            }
            ProgressView(value: value, total: 100)
                .tint(color)
        }
    }

    // MARK: - Special Mechanic Indicators

    @ViewBuilder
    private func specialMechanicIndicators(def: CountryDef, state: CountryState) -> some View {
        if def.specialMechanic == "encirclement" {
            HStack {
                Image(systemName: "target")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Text("Encirclement: \(Int(state.encirclement))%")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                Spacer()
                ProgressView(value: state.encirclement, total: 100)
                    .tint(.orange)
                    .frame(width: 80)
            }
        }
        if def.specialMechanic == "trade_dependency" {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.caption2)
                    .foregroundStyle(.green)
                Text("Trade Dependency: \(Int(state.tradeDependency))%")
                    .font(.caption2)
                    .foregroundStyle(.green)
                Spacer()
                ProgressView(value: state.tradeDependency, total: 100)
                    .tint(.green)
                    .frame(width: 80)
            }
        }
        if def.specialMechanic == "purchase_offer" {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
                Text("Purchase Offers: \(state.purchaseOffers)/5")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
                Spacer()
                ProgressView(value: Double(state.purchaseOffers), total: 5)
                    .tint(.yellow)
                    .frame(width: 80)
            }
        }
        if def.id == "azure_state" {
            HStack {
                Image(systemName: "lock.shield")
                    .font(.caption2)
                    .foregroundStyle(.purple)
                Text("Kompromat Level: \(Int(state.kompromatLevel))%")
                    .font(.caption2)
                    .foregroundStyle(.purple)
                Spacer()
                ProgressView(value: state.kompromatLevel, total: 100)
                    .tint(.purple)
                    .frame(width: 80)
            }
        }
    }

    // MARK: - Tactic Buttons

    private func tacticButtons(countryId: String, state: CountryState) -> some View {
        let tactics = tacticsForCountry(countryId)

        return VStack(spacing: 6) {
            Text("TACTICS")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.orange)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(tactics, id: \.type) { tactic in
                let canAfford = game.cash >= tactic.costCash &&
                                game.loyalty >= tactic.costLoyalty &&
                                (tactic.costWarOutput == 0 || game.warOutput >= tactic.costWarOutput)
                let opsAtMax = state.activeOperations.count >= 2
                let isAnnex = tactic.type == "annexation"
                let canAnnex = isAnnex ? state.resistance <= 0 : true

                Button {
                    game.startCountryTactic(countryId: countryId, tacticType: tactic.type)
                    Haptics.medium()
                } label: {
                    VStack(spacing: 4) {
                        HStack {
                            Text(tactic.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Spacer()

                            // Cost display
                            if tactic.costCash > 0 {
                                Text("$\(Fmt.compact(tactic.costCash))")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                            if tactic.costLoyalty > 0 {
                                Text("\(Int(tactic.costLoyalty))L")
                                    .font(.caption2)
                                    .foregroundStyle(.purple)
                            }
                        }
                        HStack {
                            Text(tactic.description)
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            Spacer()
                            Text("\(Int(tactic.duration))s")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(canAfford && !opsAtMax && canAnnex
                                  ? Color.orange.opacity(0.15)
                                  : Color(white: 0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                canAfford && !opsAtMax && canAnnex
                                    ? Color.orange.opacity(0.3)
                                    : Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
                .disabled(!canAfford || opsAtMax || !canAnnex)
                .opacity(canAfford && !opsAtMax && canAnnex ? 1 : 0.5)
            }
        }
    }

    // MARK: - Helpers

    private func statusColor(_ status: CountryStatus) -> Color {
        switch status {
        case .independent: return .gray
        case .sanctioned: return .yellow
        case .infiltrated: return .cyan
        case .coupTarget: return .orange
        case .occupied: return .red
        case .annexed: return .green
        case .allied: return .blue
        }
    }

    private func statusLabel(_ status: CountryStatus) -> String {
        switch status {
        case .independent: return "Independent"
        case .sanctioned: return "Sanctioned"
        case .infiltrated: return "Infiltrated"
        case .coupTarget: return "Coup Target"
        case .occupied: return "Occupied"
        case .annexed: return "Annexed"
        case .allied: return "Allied"
        }
    }
}
