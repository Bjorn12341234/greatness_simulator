import Foundation

struct AchievementEngine {

    /// Check all achievements and return newly unlocked IDs.
    /// Called every ~1 second (every 10 game ticks).
    static func checkAchievements(state: GameState) -> [AchievementDef] {
        var newlyUnlocked: [AchievementDef] = []

        for achievement in allAchievements {
            // Skip if already unlocked
            if state.achievements[achievement.id] == true { continue }
            // Skip if phase not reached yet
            if achievement.phase > state.phase.rawValue { continue }

            if achievement.check(state) {
                newlyUnlocked.append(achievement)
            }
        }

        // Apply unlocks
        for a in newlyUnlocked {
            state.achievements[a.id] = true
        }

        return newlyUnlocked
    }
}
