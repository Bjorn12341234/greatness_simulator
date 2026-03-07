import SwiftUI

struct SettingsView: View {
    @Environment(GameState.self) private var game
    @Environment(\.theme) private var theme
    @State private var showAchievements = false
    @State private var showContradictions = false
    @State private var showResetConfirmation = false
    @State private var showExportAlert = false

    var body: some View {
        @Bindable var game = game

        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Meta Systems
                sectionHeader("Meta Systems")

                Button {
                    showAchievements = true
                } label: {
                    settingsRow(icon: "trophy.fill", iconColor: theme.greatnessColor, title: "Achievements",
                                detail: "\(game.achievements.values.filter { $0 }.count)/\(allAchievements.count)")
                }
                .buttonStyle(.plain)

                Button {
                    showContradictions = true
                } label: {
                    settingsRow(icon: "scale.3d", iconColor: .purple, title: "Contradictions",
                                detail: "\(game.contradictions.values.filter { $0.active }.count) active")
                }
                .buttonStyle(.plain)

                // MARK: - Audio
                sectionHeader("Audio")

                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(theme.attentionColor)
                            .frame(width: 24)
                        Text("Sound Effects")
                            .font(.subheadline)
                            .foregroundStyle(theme.text)
                        Spacer()
                        Text("\(Int(game.settings.sfxVolume * 100))%")
                            .font(.caption)
                            .foregroundStyle(theme.textSecondary)
                    }
                    Slider(value: $game.settings.sfxVolume, in: 0...1, step: 0.1)
                        .tint(theme.accent)
                }
                .padding(12)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundStyle(theme.attentionColor)
                            .frame(width: 24)
                        Text("Music")
                            .font(.subheadline)
                            .foregroundStyle(theme.text)
                        Spacer()
                        Text("\(Int(game.settings.musicVolume * 100))%")
                            .font(.caption)
                            .foregroundStyle(theme.textSecondary)
                    }
                    Slider(value: $game.settings.musicVolume, in: 0...1, step: 0.1)
                        .tint(theme.accent)
                }
                .padding(12)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // MARK: - Notifications
                sectionHeader("Notifications")

                Toggle(isOn: $game.settings.notificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(theme.accent)
                            .frame(width: 24)
                        Text("Notifications")
                            .font(.subheadline)
                            .foregroundStyle(theme.text)
                    }
                }
                .tint(theme.accent)
                .padding(12)
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // MARK: - Theme
                sectionHeader("Theme")

                let themeNames = ["default", "gold", "warroom", "void", "terminal"]
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                    ForEach(themeNames, id: \.self) { themeName in
                        let t = resolveTheme(name: themeName)
                        let isSelected = game.settings.theme == themeName
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                game.settings.theme = themeName
                            }
                        } label: {
                            VStack(spacing: 6) {
                                // Color preview swatch
                                HStack(spacing: 3) {
                                    Circle().fill(t.accent).frame(width: 10, height: 10)
                                    Circle().fill(t.greatnessColor).frame(width: 10, height: 10)
                                    Circle().fill(t.cashColor).frame(width: 10, height: 10)
                                    Circle().fill(t.attentionColor).frame(width: 10, height: 10)
                                }
                                Text(themeName.capitalized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(isSelected ? t.background : t.text)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isSelected ? t.accent : t.surface)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(isSelected ? t.accent : t.surfaceHighlight, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                // MARK: - Stats
                sectionHeader("Stats")

                statsRow("Total Play Time", value: formatDuration(game.totalPlayTime))
                statsRow("Prestige Level", value: "\(game.prestigeLevel)")
                statsRow("Total Clicks", value: Fmt.compact(Double(game.clickCount)))
                statsRow("Events Resolved", value: "\(game.eventHistory.count)")

                // MARK: - Data
                sectionHeader("Data")

                Button {
                    _ = SaveEngine.save(state: game)
                    showExportAlert = true
                } label: {
                    settingsRow(icon: "square.and.arrow.down", iconColor: theme.cashColor, title: "Save Now", detail: nil)
                }
                .buttonStyle(.plain)

                Button {
                    showResetConfirmation = true
                } label: {
                    settingsRow(icon: "trash", iconColor: .red, title: "Reset All Progress", detail: nil)
                }
                .buttonStyle(.plain)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(theme.background)
        .sheet(isPresented: $showAchievements) {
            AchievementPanelView()
                .environment(game)
        }
        .sheet(isPresented: $showContradictions) {
            NavigationStack {
                ContradictionView()
                    .environment(game)
                    .navigationTitle("Contradictions")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showContradictions = false }
                                .foregroundStyle(theme.accent)
                        }
                    }
            }
        }
        .alert("Save Complete", isPresented: $showExportAlert) {
            Button("OK") {}
        }
        .alert("Reset Progress", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetGame()
            }
        } message: {
            Text("This will erase ALL progress including achievements and prestige. This cannot be undone.")
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.5)
                .foregroundStyle(theme.textSecondary)
            Spacer()
        }
    }

    private func settingsRow(icon: String, iconColor: Color, title: String, detail: String?) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(theme.text)
            Spacer()
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)
            }
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(theme.textSecondary)
        }
        .padding(12)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func statsRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(theme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(theme.text)
        }
        .padding(12)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func formatDuration(_ seconds: Double) -> String {
        let h = Int(seconds) / 3600
        let m = (Int(seconds) % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }

    private func resetGame() {
        let fresh = GameState()
        game.phase = fresh.phase
        game.greatness = 0
        game.greatnessPerSecond = 0
        game.cash = 0
        game.attention = 0
        game.influence = 0
        game.clickCount = 0
        game.attentionPerClick = 1
        game.upgrades = [:]
        game.institutions = [:]
        game.countries = [:]
        game.fleet = [:]
        game.shipyardLevel = 0
        game.shipyardQueue = nil
        game.space = SpaceState()
        game.universe = UniverseState()
        game.contradictions = [:]
        game.eventQueue = []
        game.eventHistory = []
        game.activeEvent = nil
        game.nextEventAt = 0
        game.achievements = [:]
        game.prestigeUpgrades = [:]
        game.prestigeLevel = 0
        game.prestigePoints = 0
        game.loyalty = 50
        game.control = 0
        game.legitimacy = 100
        game.surveillance = 0
        game.budget = BudgetAllocation()
        game.tariffs = [:]
        game.dataCenterUpgrades = [:]
        game.loyaltyUpgrades = [:]
        game.doublethinkTokens = 0
        game.totalPlayTime = 0
        game.settings = GameSettings()
        _ = SaveEngine.save(state: game)
    }
}
