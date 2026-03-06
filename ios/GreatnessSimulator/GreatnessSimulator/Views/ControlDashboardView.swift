import SwiftUI

enum ControlTab: String, CaseIterable {
    case institutions = "Institutions"
    case budget = "Budget"
    case tariffs = "Tariffs"
    case dataCenters = "Data Centers"
    case loyalty = "Loyalty"
}

struct ControlDashboardView: View {
    @Environment(GameState.self) private var game
    @State private var selectedTab: ControlTab = .institutions

    var body: some View {
        VStack(spacing: 0) {
            // Legitimacy meter
            legitimacyMeter

            // Sub-tab bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ControlTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                            Haptics.light()
                        } label: {
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(selectedTab == tab ? .bold : .regular)
                                .foregroundStyle(selectedTab == tab ? .orange : .secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedTab == tab ? Color.orange.opacity(0.15) : Color.clear)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }

            // Content
            Group {
                switch selectedTab {
                case .institutions: InstitutionBoardView()
                case .budget: BudgetPanelView()
                case .tariffs: TariffPanelView()
                case .dataCenters: DataCenterPanelView()
                case .loyalty: LoyaltyPanelView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var legitimacyMeter: some View {
        let legit = game.legitimacy
        let color: Color = legit > 80 ? .green : legit > 50 ? .yellow : legit > 25 ? .orange : .red

        return VStack(spacing: 4) {
            HStack {
                Text("LEGITIMACY")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(1)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(legit))%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundStyle(color)
                Text(legit < 10 ? "COLLAPSE WARNING" : "")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * (legit / 100))
                        .animation(.easeOut(duration: 0.3), value: legit)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(white: 0.06))
    }
}
