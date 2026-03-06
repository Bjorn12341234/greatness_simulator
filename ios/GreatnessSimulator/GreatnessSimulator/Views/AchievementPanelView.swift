import SwiftUI

struct AchievementPanelView: View {
    @Environment(GameState.self) private var game
    @Environment(\.dismiss) private var dismiss
    @State private var filter: AchievementFilter = .all

    enum AchievementFilter: Hashable {
        case all
        case phase(Int)
        case meta
    }

    private var filtered: [AchievementDef] {
        switch filter {
        case .all:
            return allAchievements
        case .phase(let p):
            return allAchievements.filter { $0.phase == p && $0.category != .meta }
        case .meta:
            return allAchievements.filter { $0.category == .meta }
        }
    }

    private var unlockedCount: Int {
        allAchievements.filter { game.achievements[$0.id] == true }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter tabs
                filterBar

                // Achievement list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filtered) { achievement in
                            achievementCard(achievement)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black)
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(unlockedCount)/\(allAchievements.count)")
                        .font(.subheadline)
                        .foregroundStyle(.yellow)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    // MARK: - Filter Bar

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterButton("All", filter: .all)
                filterButton("P1", filter: .phase(1))
                filterButton("P2", filter: .phase(2))
                filterButton("P3", filter: .phase(3))
                filterButton("P4", filter: .phase(4))
                filterButton("P5", filter: .phase(5))
                filterButton("Meta", filter: .meta)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(white: 0.06))
    }

    private func filterButton(_ label: String, filter: AchievementFilter) -> some View {
        let isSelected = self.filter == filter
        let count: Int = {
            let items: [AchievementDef]
            switch filter {
            case .all: items = allAchievements
            case .phase(let p): items = allAchievements.filter { $0.phase == p && $0.category != .meta }
            case .meta: items = allAchievements.filter { $0.category == .meta }
            }
            return items.filter { game.achievements[$0.id] == true }.count
        }()
        let total: Int = {
            switch filter {
            case .all: return allAchievements.count
            case .phase(let p): return allAchievements.filter { $0.phase == p && $0.category != .meta }.count
            case .meta: return allAchievements.filter { $0.category == .meta }.count
            }
        }()

        return Button {
            self.filter = filter
        } label: {
            VStack(spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("\(count)/\(total)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.orange.opacity(0.3) : Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Achievement Card

    private func achievementCard(_ achievement: AchievementDef) -> some View {
        let unlocked = game.achievements[achievement.id] == true
        let visible = achievement.phase <= game.phase.rawValue || unlocked

        return HStack(spacing: 12) {
            // Icon
            Image(systemName: unlocked ? achievement.icon : "lock.fill")
                .font(.title2)
                .foregroundStyle(unlocked ? categoryColor(achievement.category) : .secondary)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(unlocked ? categoryColor(achievement.category).opacity(0.15) : Color(white: 0.1))
                )

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(visible ? achievement.name : "???")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(unlocked ? .white : .secondary)

                    Spacer()

                    categoryBadge(achievement.category)
                }

                Text(visible ? achievement.description : "Keep playing to unlock.")
                    .font(.caption)
                    .foregroundStyle(unlocked ? .white.opacity(0.7) : .secondary)
                    .lineLimit(2)
            }

            if unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: unlocked ? 0.1 : 0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            unlocked ? categoryColor(achievement.category).opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
    }

    // MARK: - Helpers

    private func categoryColor(_ category: AchievementCategory) -> Color {
        switch category {
        case .milestone: return .green
        case .strategy: return .blue
        case .irony: return .yellow
        case .meta: return .purple
        }
    }

    private func categoryBadge(_ category: AchievementCategory) -> some View {
        Text(category.rawValue.uppercased())
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(categoryColor(category).opacity(0.2))
            .foregroundStyle(categoryColor(category))
            .clipShape(Capsule())
    }
}
