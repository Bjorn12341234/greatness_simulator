import SwiftUI

enum WorldSubTab: String, CaseIterable {
    case overview = "Overview"
    case countries = "Countries"
    case fleet = "Fleet"
}

struct WorldDashboardView: View {
    @Environment(GameState.self) private var game
    @State private var selectedSubTab: WorldSubTab = .overview

    var body: some View {
        VStack(spacing: 0) {
            // Sub-tab picker
            Picker("", selection: $selectedSubTab) {
                ForEach(WorldSubTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            // Content
            switch selectedSubTab {
            case .overview:
                overviewTab
            case .countries:
                WorldMapView()
            case .fleet:
                FleetPanelView()
            }
        }
    }

    // MARK: - Overview

    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                NobelMeterView()

                // Greatness Accord progress
                accordProgress

                // War summary
                warSummary

                // Active operations count
                activeOperations
            }
            .padding()
        }
    }

    private var accordProgress: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "globe.americas.fill")
                    .foregroundStyle(.orange)
                Text("THE GREATNESS ACCORD")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }

            let annexed = game.countries.values.filter { $0.status == .annexed || $0.status == .allied }.count
            let total = countryDefs.count // 14

            ProgressView(value: Double(annexed), total: Double(total))
                .tint(.orange)

            HStack {
                Text("\(annexed)/\(total) countries under the Accord")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if annexed >= total {
                    Text("COMPLETE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var warSummary: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "bolt.shield.fill")
                    .foregroundStyle(.red)
                Text("WAR OUTPUT")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text(Fmt.compact(game.warOutput))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }

            HStack(spacing: 20) {
                VStack {
                    Text("Ships")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    let totalShips = game.fleet.values.reduce(0, +)
                    Text("\(totalShips)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                VStack {
                    Text("Fear")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(Fmt.compact(game.fear))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                }
                VStack {
                    Text("Shipyard Lv")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(game.shipyardLevel)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.cyan)
                }
                VStack {
                    Text("Nobel Prizes")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(game.nobelPrizesWon)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.yellow)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var activeOperations: some View {
        let ops = game.countries.values.flatMap { $0.activeOperations }

        return VStack(spacing: 8) {
            HStack {
                Image(systemName: "gear.badge")
                    .foregroundStyle(.cyan)
                Text("ACTIVE OPERATIONS")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(ops.count)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.cyan)
            }

            if ops.isEmpty {
                Text("No active operations. Use the Countries tab to begin.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(Array(ops.prefix(5).enumerated()), id: \.offset) { _, op in
                    if let tacticDef = tacticRegistry[op.tacticType] {
                        HStack {
                            Text(tacticDef.name)
                                .font(.caption)
                                .foregroundStyle(.white)
                            Spacer()
                            let now = Date().timeIntervalSince1970
                            let progress = min(1.0, (now - op.startedAt) / op.duration)
                            ProgressView(value: progress)
                                .tint(.orange)
                                .frame(width: 80)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }
}
