import SwiftUI

enum GameTab: String, CaseIterable {
    case click = "Click"
    case upgrades = "Upgrades"
    case stats = "Stats"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .click: return "hand.tap.fill"
        case .upgrades: return "arrow.up.square.fill"
        case .stats: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct MainView: View {
    @Environment(GameState.self) private var game
    @State private var selectedTab: GameTab = .click

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Phase header
                phaseHeader

                // Resource bar
                resourceBar

                // Main content
                Group {
                    switch selectedTab {
                    case .click:
                        ClickerView()
                    case .upgrades:
                        UpgradeListView()
                    case .stats:
                        Text("Coming soon")
                            .foregroundStyle(.secondary)
                            .frame(maxHeight: .infinity)
                    case .settings:
                        Text("Coming soon")
                            .foregroundStyle(.secondary)
                            .frame(maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Tab bar
                tabBar
            }

            // Event modal overlay
            if let event = game.activeEvent {
                EventModalView(event: event) {
                    // onDismiss — event already resolved in resolveEvent
                }
            }

            // Phase transition overlay
            if let from = game.pendingTransitionFrom, let to = game.pendingTransitionTo {
                PhaseTransitionView(fromPhase: from, toPhase: to) {
                    game.completePhaseTransition(to: to)
                }
            }
        }
        .background(Color.black)
    }

    // MARK: - Phase Header

    private var phaseHeader: some View {
        VStack(spacing: 4) {
            Text("GREATNESS SIMULATOR")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(3)
                .foregroundStyle(.yellow.opacity(0.8))

            Text("Phase \(game.phase.rawValue): \(game.phase.title)")
                .font(.headline)
                .foregroundStyle(.white)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.black, Color(white: 0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Resource Bar

    private var resourceBar: some View {
        HStack(spacing: 16) {
            resourcePill(icon: "star.fill", label: "Greatness", value: game.greatness, color: .yellow)
            resourcePill(icon: "dollarsign.circle.fill", label: "Cash", value: game.cash, color: .green)
            resourcePill(icon: "eye.fill", label: "Attention", value: game.attention, color: .cyan)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(white: 0.08))
    }

    private func resourcePill(icon: String, label: String, value: Double, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(Fmt.compact(value))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.2), value: value)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack {
            ForEach(GameTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                    Haptics.light()
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.icon)
                            .font(.title3)
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(selectedTab == tab ? .orange : .secondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .background(Color(white: 0.08))
    }
}

#Preview {
    MainView()
        .environment(GameState())
}
