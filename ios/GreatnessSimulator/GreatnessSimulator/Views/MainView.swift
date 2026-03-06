import SwiftUI

enum GameTab: String, CaseIterable {
    case click = "Click"
    case upgrades = "Upgrades"
    case control = "Control"
    case world = "World"
    case space = "Space"
    case cosmic = "Cosmic"
    case prestige = "Prestige"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .click: return "hand.tap.fill"
        case .upgrades: return "arrow.up.square.fill"
        case .control: return "building.columns.fill"
        case .world: return "globe.americas.fill"
        case .space: return "sparkles"
        case .cosmic: return "atom"
        case .prestige: return "sparkles"
        case .settings: return "gearshape.fill"
        }
    }

    var minPhase: Int {
        switch self {
        case .click, .upgrades: return 1
        case .control: return 2
        case .world: return 3
        case .space: return 4
        case .cosmic: return 5
        case .prestige, .settings: return 1
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
                    case .control:
                        ControlDashboardView()
                    case .world:
                        WorldDashboardView()
                    case .space:
                        SpaceView()
                    case .cosmic:
                        CosmicView()
                    case .prestige:
                        PrestigeView()
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

            // Ending sequence overlay
            if game.universe.endingTriggered && !game.universe.endingComplete {
                EndingView()
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
        VStack(spacing: 6) {
            HStack(spacing: 16) {
                resourcePill(icon: "star.fill", label: "Greatness", value: game.greatness, color: .yellow)
                resourcePill(icon: "dollarsign.circle.fill", label: "Cash", value: game.cash, color: .green)
                resourcePill(icon: "eye.fill", label: "Attention", value: game.attention, color: .cyan)
            }
            if game.phase.rawValue >= 2 {
                HStack(spacing: 16) {
                    resourcePill(icon: "heart.fill", label: "Loyalty", value: game.loyalty, color: .purple)
                    resourcePill(icon: "shield.fill", label: "Legitimacy", value: game.legitimacy, color: game.legitimacy > 50 ? .green : .red)
                    resourcePill(icon: "eye.trianglebadge.exclamationmark.fill", label: "Control", value: game.control, color: .orange)
                }
            }
            if game.phase.rawValue >= 3 {
                HStack(spacing: 16) {
                    resourcePill(icon: "bolt.shield.fill", label: "War", value: game.warOutput, color: .red)
                    resourcePill(icon: "exclamationmark.triangle.fill", label: "Fear", value: game.fear, color: .orange)
                    resourcePill(icon: "medal.fill", label: "Nobel", value: game.nobelScore, color: .yellow)
                }
            }
            if game.phase.rawValue >= 4 {
                HStack(spacing: 16) {
                    resourcePill(icon: "flame.fill", label: "Rocket", value: game.rocketMass, color: .orange)
                    resourcePill(icon: "gearshape.2.fill", label: "Orbital", value: game.orbitalIndustry, color: .cyan)
                    resourcePill(icon: "hammer.fill", label: "Mining", value: game.miningOutput, color: .yellow)
                }
            }
            if game.phase.rawValue >= 5 {
                HStack(spacing: 16) {
                    resourcePill(icon: "paperplane.fill", label: "Probes", value: game.probesLaunched, color: .cyan)
                    resourcePill(icon: "atom", label: "GU", value: game.greatnessUnits, color: Color(red: 0.6, green: 0.2, blue: 1.0))
                    resourcePill(icon: "waveform.path.ecg", label: "Drift", value: game.realityDrift, color: game.realityDrift > 60 ? .red : .yellow)
                }
            }
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

    private var visibleTabs: [GameTab] {
        GameTab.allCases.filter { $0.minPhase <= game.phase.rawValue }
    }

    private var tabBar: some View {
        HStack {
            ForEach(visibleTabs, id: \.self) { tab in
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
