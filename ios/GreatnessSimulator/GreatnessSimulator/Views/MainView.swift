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
    @State private var achievementToasts: [AchievementToast] = []
    @State private var phaseAnimating = false
    @State private var driftSeed: Int = 0

    private var theme: GameTheme {
        resolveTheme(name: game.settings.theme)
    }

    private var pColors: PhaseColors {
        phaseColors[game.phase.rawValue] ?? phaseColors[1]!
    }

    private func driftLabel(_ label: String) -> String {
        driftSwapLabel(label, drift: game.realityDrift, seed: driftSeed)
    }

    private func driftJitter(_ value: Double) -> Double {
        driftJitterValue(value, drift: game.realityDrift, seed: driftSeed)
    }

    var body: some View {
        VStack(spacing: 0) {
            phaseHeader
            resourceBar
            TickerView()
                .environment(\.theme, theme)

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
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .driftGlitch(drift: game.realityDrift, seed: driftSeed)

            tabBar
        }
        .background(theme.background.ignoresSafeArea())
        .overlay {
            ZStack {
                if let event = game.activeEvent {
                    EventModalView(event: event) {}
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }

                if let from = game.pendingTransitionFrom, let to = game.pendingTransitionTo {
                    PhaseTransitionView(fromPhase: from, toPhase: to) {
                        game.completePhaseTransition(to: to)
                    }
                }

                if game.universe.endingTriggered && !game.universe.endingComplete {
                    EndingView()
                }
            }
        }
        .overlay {
            if game.realityDrift >= 40 && driftSeed % 17 == 0 {
                Rectangle()
                    .fill(driftSeed % 2 == 0 ? Color.red : Color.cyan)
                    .opacity(0.03 * min(1, game.realityDrift / 100.0))
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.05), value: driftSeed)
            }
        }
        .environment(\.theme, theme)
        .onChange(of: game.pendingAchievementToasts) { _, newToasts in
            for toastId in newToasts {
                if let def = achievementRegistry[toastId] {
                    withAnimation(.spring(duration: 0.4, bounce: 0.3)) {
                        achievementToasts.append(AchievementToast(achievement: def))
                    }
                    AudioEngine.shared.playAchievement()
                }
            }
            game.pendingAchievementToasts.removeAll()
            for toast in achievementToasts {
                let toastId = toast.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        achievementToasts.removeAll { $0.id == toastId }
                    }
                }
            }
        }
        .onChange(of: game.activeEvent?.id) { oldId, newId in
            if oldId == nil && newId != nil {
                if let category = game.activeEvent?.category {
                    AudioEngine.shared.playEventByCategory(category)
                } else {
                    AudioEngine.shared.playEvent()
                }
            }
        }
        .onChange(of: game.settings.sfxVolume) { _, new in
            AudioEngine.shared.updateVolumes(sfx: new, music: game.settings.musicVolume)
        }
        .onChange(of: game.settings.musicVolume) { _, new in
            AudioEngine.shared.updateVolumes(sfx: game.settings.sfxVolume, music: new)
        }
        .onChange(of: game.phase) { _, _ in
            withAnimation(.easeInOut(duration: 0.6)) {
                phaseAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                phaseAnimating = false
            }
        }
        .overlay(alignment: .top) {
            AchievementToastOverlay(toasts: $achievementToasts)
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 300_000_000)
                if game.realityDrift >= 20 {
                    driftSeed &+= 1
                }
            }
        }
        .environment(\.driftSeed, driftSeed)
        .onAppear {
            AudioEngine.shared.updateVolumes(sfx: game.settings.sfxVolume, music: game.settings.musicVolume)
        }
    }

    // MARK: - Phase Header

    private var phaseHeader: some View {
        HStack {
            Text(driftLabel("GREATNESS"))
                .font(.system(size: 16, weight: .black))
                .tracking(2)
                .foregroundStyle(.orange)
                .animation(.easeInOut(duration: 0.15), value: driftSeed)
            Spacer()
            Text(game.realityDrift >= 80 && driftSeed % 15 == 0 ? "Error \(game.phase.rawValue)" : "Phase \(game.phase.rawValue)")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white.opacity(0.8))
                .animation(.easeInOut(duration: 0.15), value: driftSeed)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background {
            Color(white: 0.13).ignoresSafeArea(edges: .top)
        }
        .driftFlicker(drift: game.realityDrift, seed: driftSeed)
    }

    // MARK: - Resource Bar

    private var resourceBar: some View {
        VStack(spacing: 6) {
            HStack(spacing: 16) {
                resourcePill(icon: "star.fill", label: "Greatness", value: driftJitter(game.greatness), color: theme.greatnessColor)
                resourcePill(icon: "dollarsign.circle.fill", label: "Cash", value: driftJitter(game.cash), color: theme.cashColor)
                resourcePill(icon: "eye.fill", label: "Attention", value: driftJitter(game.attention), color: theme.attentionColor)
            }
            if game.phase.rawValue >= 2 {
                HStack(spacing: 16) {
                    resourcePill(icon: "heart.fill", label: "Loyalty", value: driftJitter(game.loyalty), color: .purple)
                    resourcePill(icon: "shield.fill", label: "Legitimacy", value: driftJitter(game.legitimacy), color: game.legitimacy > 50 ? .green : .red)
                    resourcePill(icon: "eye.trianglebadge.exclamationmark.fill", label: "Control", value: driftJitter(game.control), color: .orange)
                }
            }
            if game.phase.rawValue >= 3 {
                HStack(spacing: 16) {
                    resourcePill(icon: "bolt.shield.fill", label: "War", value: driftJitter(game.warOutput), color: .red)
                    resourcePill(icon: "exclamationmark.triangle.fill", label: "Fear", value: driftJitter(game.fear), color: .orange)
                    resourcePill(icon: "medal.fill", label: "Nobel", value: driftJitter(game.nobelScore), color: .yellow)
                }
            }
            if game.phase.rawValue >= 4 {
                HStack(spacing: 16) {
                    resourcePill(icon: "flame.fill", label: "Rocket", value: driftJitter(game.rocketMass), color: .orange)
                    resourcePill(icon: "gearshape.2.fill", label: "Orbital", value: driftJitter(game.orbitalIndustry), color: .cyan)
                    resourcePill(icon: "hammer.fill", label: "Mining", value: driftJitter(game.miningOutput), color: .yellow)
                }
            }
            if game.phase.rawValue >= 5 {
                HStack(spacing: 16) {
                    resourcePill(icon: "paperplane.fill", label: "Probes", value: driftJitter(game.probesLaunched), color: .cyan)
                    resourcePill(icon: "atom", label: "GU", value: driftJitter(game.greatnessUnits), color: Color(red: 0.6, green: 0.2, blue: 1.0))
                    resourcePill(icon: "waveform.path.ecg", label: "Drift", value: driftJitter(game.realityDrift), color: game.realityDrift > 60 ? .red : .yellow)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(theme.surface)
        .driftFlicker(drift: game.realityDrift, seed: driftSeed)
    }

    private func resourcePill(icon: String, label: String, value: Double, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundStyle(color)
            Text(Fmt.compact(value))
                .font(.caption)
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
                    withAnimation(.spring(duration: 0.25, bounce: 0.2)) {
                        selectedTab = tab
                    }
                    Haptics.light()
                } label: {
                    VStack(spacing: 1) {
                        Image(systemName: tab.icon)
                            .font(.callout)
                            .symbolEffect(.bounce, value: selectedTab == tab)
                        Text(driftLabel(tab.rawValue))
                            .font(.system(size: 9))
                            .animation(.easeInOut(duration: 0.15), value: driftSeed)
                    }
                    .foregroundStyle(selectedTab == tab ? theme.accent : theme.textSecondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 5)
        .background {
            theme.tabBarBg.ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    MainView()
        .environment(GameState())
}
