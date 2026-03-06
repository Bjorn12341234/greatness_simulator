import SwiftUI

struct SettingsView: View {
    @Environment(GameState.self) private var game
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

                // Achievements button
                Button {
                    showAchievements = true
                } label: {
                    settingsRow(icon: "trophy.fill", iconColor: .yellow, title: "Achievements",
                                detail: "\(game.achievements.values.filter { $0 }.count)/\(allAchievements.count)")
                }
                .buttonStyle(.plain)

                // Contradictions button
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
                            .foregroundStyle(.cyan)
                            .frame(width: 24)
                        Text("Sound Effects")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(game.settings.sfxVolume * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $game.settings.sfxVolume, in: 0...1, step: 0.1)
                        .tint(.cyan)
                }
                .padding(12)
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundStyle(.cyan)
                            .frame(width: 24)
                        Text("Music")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(game.settings.musicVolume * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $game.settings.musicVolume, in: 0...1, step: 0.1)
                        .tint(.cyan)
                }
                .padding(12)
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // MARK: - Notifications
                sectionHeader("Notifications")

                Toggle(isOn: $game.settings.notificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(.orange)
                            .frame(width: 24)
                        Text("Notifications")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                }
                .tint(.orange)
                .padding(12)
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // MARK: - Theme
                sectionHeader("Theme")

                let themes = ["default", "gold", "warroom", "void", "terminal"]
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                    ForEach(themes, id: \.self) { theme in
                        Button {
                            game.settings.theme = theme
                        } label: {
                            Text(theme.capitalized)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(game.settings.theme == theme ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(game.settings.theme == theme ? Color.orange : Color(white: 0.12))
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
                    settingsRow(icon: "square.and.arrow.down", iconColor: .green, title: "Save Now", detail: nil)
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
        .background(Color.black)
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
                                .foregroundStyle(.orange)
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
                .foregroundStyle(.secondary)
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
                .foregroundStyle(.white)
            Spacer()
            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(white: 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func statsRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .padding(12)
        .background(Color(white: 0.08))
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
        // Copy all properties from fresh state
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
