import Foundation

// MARK: - Achievement Types

enum AchievementCategory: String, Codable, CaseIterable {
    case milestone
    case strategy
    case irony
    case meta
}

struct AchievementDef: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let phase: Int
    let category: AchievementCategory
    let check: (GameState) -> Bool
}

// MARK: - All Achievements (73 total)

let allAchievements: [AchievementDef] = [

    // MARK: Phase 1 (9)

    AchievementDef(
        id: "first_click", name: "The Beginning",
        description: "Generate your first attention.",
        icon: "hand.tap", phase: 1, category: .milestone,
        check: { $0.clickCount >= 1 }
    ),
    AchievementDef(
        id: "hundred_clicks", name: "Compulsive Clicker",
        description: "Click 100 times. Your dedication is noted.",
        icon: "computermouse", phase: 1, category: .milestone,
        check: { $0.clickCount >= 100 }
    ),
    AchievementDef(
        id: "thousand_clicks", name: "Repetitive Strain",
        description: "Click 1,000 times. Consider a trackball.",
        icon: "hand.raised.fingers.spread", phase: 1, category: .milestone,
        check: { $0.clickCount >= 1000 }
    ),
    AchievementDef(
        id: "first_upgrade", name: "Self-Improvement",
        description: "Purchase your first upgrade.",
        icon: "arrow.up.square", phase: 1, category: .milestone,
        check: { $0.upgrades.values.contains(where: { $0.purchased }) }
    ),
    AchievementDef(
        id: "all_trees", name: "Diversified Portfolio",
        description: "Purchase at least one upgrade from every tree.",
        icon: "tree", phase: 1, category: .strategy,
        check: { state in
            let treeRoots: [String: String] = [
                "media_social_account": "Media Presence",
                "merch_red_hat": "Merchandise Empire",
                "algo_bots": "Algorithm Manipulation",
                "sci_research_div": "Early Science",
                "ent_bible": "Entrepreneurship",
            ]
            var trees = Set<String>()
            for (id, upgrade) in state.upgrades {
                if upgrade.purchased, let tree = treeRoots[id] {
                    trees.insert(tree)
                }
            }
            return trees.count >= 5
        }
    ),
    AchievementDef(
        id: "neural_backup", name: "Digital Immortality",
        description: "Complete the Neural Backup. Consciousness is just data.",
        icon: "brain", phase: 1, category: .milestone,
        check: { $0.upgrades["sci_neural_backup"]?.purchased == true }
    ),
    AchievementDef(
        id: "first_cash", name: "Cash Money",
        description: "Earn your first dollar. Capitalism begins.",
        icon: "dollarsign.circle", phase: 1, category: .milestone,
        check: { $0.cash >= 1 }
    ),
    AchievementDef(
        id: "attention_hog", name: "Attention Hog",
        description: "Accumulate 10,000 attention. The algorithm loves you.",
        icon: "tv", phase: 1, category: .milestone,
        check: { $0.attention >= 10_000 }
    ),
    AchievementDef(
        id: "first_event", name: "Breaking News",
        description: "Resolve your first event.",
        icon: "newspaper", phase: 1, category: .milestone,
        check: { $0.eventHistory.count >= 1 }
    ),

    // MARK: Phase 2 (9)

    AchievementDef(
        id: "first_institution", name: "Institutional Alignment",
        description: "Capture your first institution.",
        icon: "building.columns", phase: 2, category: .milestone,
        check: { $0.institutions.values.contains(where: { $0.status == .captured || $0.status == .automated }) }
    ),
    AchievementDef(
        id: "hostile_takeover", name: "Hostile Takeover",
        description: "Capture an institution via Purge. Efficiency above all.",
        icon: "bolt.fill", phase: 2, category: .strategy,
        check: { state in
            state.eventHistory.count > 0 &&
            state.institutions.values.contains(where: { $0.status == .captured || $0.status == .automated })
        }
    ),
    AchievementDef(
        id: "legitimacy_crisis", name: "Legitimacy Crisis",
        description: "Drop below 10% Legitimacy and survive.",
        icon: "exclamationmark.triangle", phase: 2, category: .irony,
        check: { $0.legitimacy < 10 && $0.phase.rawValue >= 2 }
    ),
    AchievementDef(
        id: "deep_state", name: "The Deep State",
        description: "Automate all 13 institutions. The machine runs itself.",
        icon: "gearshape.2", phase: 2, category: .strategy,
        check: { state in
            let insts = state.institutions.values
            return insts.count >= 13 && insts.allSatisfy({ $0.status == .automated })
        }
    ),
    AchievementDef(
        id: "tariff_man", name: "Tariff Man",
        description: "Activate all tariff categories simultaneously.",
        icon: "chart.bar", phase: 2, category: .strategy,
        check: { state in
            let tariffs = state.tariffs.values
            return tariffs.count >= 6 && tariffs.allSatisfy({ $0.active })
        }
    ),
    AchievementDef(
        id: "austerity_king", name: "Austerity King",
        description: "Set all social programs below 10%. People are expendable.",
        icon: "chart.line.downtrend.xyaxis", phase: 2, category: .irony,
        check: { $0.budget.healthcare < 10 && $0.budget.education < 10 && $0.budget.socialBenefits < 10 && $0.phase.rawValue >= 2 }
    ),
    AchievementDef(
        id: "data_center_online", name: "Surveillance State",
        description: "Deploy your first data center upgrade.",
        icon: "server.rack", phase: 2, category: .milestone,
        check: { $0.dataCenterUpgrades.values.contains(where: { $0 }) }
    ),
    AchievementDef(
        id: "loyalty_complete", name: "Loyalty Economy",
        description: "Purchase all loyalty upgrades. Everyone is watching everyone.",
        icon: "medal", phase: 2, category: .strategy,
        check: { state in
            let ups = state.loyaltyUpgrades.values
            return ups.count >= 4 && ups.allSatisfy({ $0 })
        }
    ),
    AchievementDef(
        id: "doublethink_master", name: "Doublethink Master",
        description: "Earn 10 Doublethink Tokens. Two truths at once, effortlessly.",
        icon: "puzzlepiece", phase: 2, category: .irony,
        check: { $0.doublethinkTokens >= 10 }
    ),

    // MARK: Phase 3 (10)

    AchievementDef(
        id: "first_annexation", name: "Manifest Destiny",
        description: "Annex your first country into the Greatness Accord.",
        icon: "map", phase: 3, category: .milestone,
        check: { $0.countries.values.contains(where: { $0.status == .annexed }) }
    ),
    AchievementDef(
        id: "peacemonger", name: "Peacemonger",
        description: "Win a Nobel Peace Prize while running active military operations.",
        icon: "medal.fill", phase: 3, category: .irony,
        check: { state in
            let atWar = state.countries.values.filter { $0.status == .occupied || $0.status == .coupTarget }.count
            return state.nobelPrizesWon >= 1 && atWar >= 1
        }
    ),
    AchievementDef(
        id: "golden_fleet", name: "Golden Fleet",
        description: "Build a Golden Dreadnought. Peak military excess.",
        icon: "crown", phase: 3, category: .milestone,
        check: { ($0.fleet["golden_dreadnought"] ?? 0) >= 1 }
    ),
    AchievementDef(
        id: "extraordinary", name: "Extraordinary Measures",
        description: "Use Extraordinary Rendition. Someone is missing and it's your fault.",
        icon: "eye.slash", phase: 3, category: .strategy,
        check: { $0.eventHistory.contains("p3_rendition_fallout") }
    ),
    AchievementDef(
        id: "world_accord", name: "The Greatness Accord",
        description: "All 14 countries under the Accord. Earth is optimized.",
        icon: "globe.americas", phase: 3, category: .milestone,
        check: { state in
            let countries = state.countries.filter { $0.key != "azure_state" }
            return countries.count >= 14 && countries.values.allSatisfy({ $0.status == .annexed || $0.status == .allied })
        }
    ),
    AchievementDef(
        id: "gunboat_diplomacy", name: "Gunboat Diplomacy",
        description: "Win Nobel Prize with 50+ warships active.",
        icon: "anchor", phase: 3, category: .irony,
        check: { state in
            let totalShips = state.fleet.values.reduce(0, +)
            return state.nobelPrizesWon >= 1 && totalShips >= 50
        }
    ),
    AchievementDef(
        id: "armada", name: "The Armada",
        description: "Build 100 ships. The ocean is an orange parking lot.",
        icon: "ferry", phase: 3, category: .milestone,
        check: { state in
            let totalShips = state.fleet.values.reduce(0, +)
            return totalShips >= 100
        }
    ),
    AchievementDef(
        id: "triple_nobel", name: "Peace Industrial Complex",
        description: "Win 3 Nobel Peace Prizes. The committee has questions.",
        icon: "trophy", phase: 3, category: .irony,
        check: { $0.nobelPrizesWon >= 3 }
    ),
    AchievementDef(
        id: "fear_factor", name: "Fear Factor",
        description: "Reach 500 Fear. The world trembles.",
        icon: "exclamationmark.triangle.fill", phase: 3, category: .milestone,
        check: { $0.fear >= 500 }
    ),
    AchievementDef(
        id: "refugee_crisis", name: "Collateral Greatness",
        description: "Trigger refugee waves in 3 countries. Freedom has side effects.",
        icon: "figure.wave", phase: 3, category: .irony,
        check: { state in
            let waves = state.countries.values.filter { $0.refugeeWavesSent > 0 }.count
            return waves >= 3
        }
    ),

    // MARK: Phase 4 (8)

    AchievementDef(
        id: "one_small_step", name: "One Small Step",
        description: "Build a Moon Base. It has a gift shop.",
        icon: "moon.fill", phase: 4, category: .milestone,
        check: { $0.space.moonBase }
    ),
    AchievementDef(
        id: "the_orange_planet", name: "The Orange Planet",
        description: "Mars has been rebranded. Scientists are crying.",
        icon: "circle.fill", phase: 4, category: .milestone,
        check: { $0.space.marsRenamed }
    ),
    AchievementDef(
        id: "space_landlord", name: "Space Landlord",
        description: "Claim Moon, Mars, and Asteroids. The solar system has a new owner.",
        icon: "house.fill", phase: 4, category: .strategy,
        check: { $0.space.moonBase && $0.space.marsColony && $0.space.asteroidProspectors > 0 }
    ),
    AchievementDef(
        id: "diplomatic_railgun_achievement", name: "Diplomatic Railgun",
        description: "Deploy the Diplomatic Railgun. Diplomacy at Mach 20.",
        icon: "bolt.horizontal.fill", phase: 4, category: .milestone,
        check: { $0.space.spaceWeapons["diplomatic_railgun"] == true }
    ),
    AchievementDef(
        id: "freedom_canyon", name: "Freedom Canyon",
        description: "Rename Mars, establish colony, and reach 50% terraform.",
        icon: "mountain.2.fill", phase: 4, category: .strategy,
        check: { $0.space.marsRenamed && $0.space.marsColony && $0.terraformProgress >= 50 }
    ),
    AchievementDef(
        id: "satellite_network", name: "Propaganda Network",
        description: "Deploy 10 orbital propaganda satellites. Truth from above.",
        icon: "antenna.radiowaves.left.and.right", phase: 4, category: .milestone,
        check: { $0.space.propagandaSatellites >= 10 }
    ),
    AchievementDef(
        id: "solar_shade_deployed", name: "Climate Control",
        description: "Deploy the Solar Shade Array. Weather is now a policy decision.",
        icon: "sun.max.fill", phase: 4, category: .strategy,
        check: { $0.space.spaceWeapons["solar_shade"] == true }
    ),
    AchievementDef(
        id: "dyson_prototype", name: "Dyson Pioneer",
        description: "Build the Dyson Swarm Prototype. Baby steps toward stellar domination.",
        icon: "sun.and.horizon.fill", phase: 4, category: .milestone,
        check: { $0.space.dysonSwarms > 0 }
    ),

    // MARK: Phase 5 (9)

    AchievementDef(
        id: "first_replicator", name: "Self-Replicating",
        description: "Launch your first MAGA Replicator. Make All Galaxies American.",
        icon: "paperplane.fill", phase: 5, category: .milestone,
        check: { $0.probesLaunched >= 1 }
    ),
    AchievementDef(
        id: "dyson_sphere", name: "Solar Greatness",
        description: "Build a Solar Greatness Harvester. The sun works for you now.",
        icon: "sun.max.fill", phase: 5, category: .milestone,
        check: { $0.universe.dysonUpgrades.values.contains(where: { $0 }) }
    ),
    AchievementDef(
        id: "star_brander", name: "Star Brander",
        description: "Convert 50 stars. Each one gets a name and a logo.",
        icon: "star.fill", phase: 5, category: .milestone,
        check: { $0.starsConverted >= 50 }
    ),
    AchievementDef(
        id: "post_reality", name: "Post-Reality",
        description: "Reach 80% Reality Drift. Truth is whatever the spreadsheet says.",
        icon: "waveform.path.ecg", phase: 5, category: .irony,
        check: { $0.realityDrift >= 80 }
    ),
    AchievementDef(
        id: "universe_great", name: "The Universe Is Great",
        description: "Convert 100% of the reachable universe. Now what?",
        icon: "sparkles", phase: 5, category: .milestone,
        check: { $0.universe.universeConverted >= 100 }
    ),
    AchievementDef(
        id: "infinite_loop", name: "Infinite Loop",
        description: "Prestige for the first time. It starts again. It always starts again.",
        icon: "infinity", phase: 5, category: .milestone,
        check: { $0.prestigeLevel >= 1 }
    ),
    AchievementDef(
        id: "ontological_supremacy", name: "Ontological Supremacy",
        description: "Complete the Narrative Architecture. Reality is your product.",
        icon: "eye", phase: 5, category: .strategy,
        check: { $0.universe.narrativeResearch["ontological_supremacy"] == true }
    ),
    AchievementDef(
        id: "black_hole_accountant", name: "Black Hole Accountant",
        description: "Create your first black hole. Debt disappears into the singularity.",
        icon: "circle.dashed", phase: 5, category: .milestone,
        check: { $0.universe.blackHoleUpgrades.values.contains(where: { $0 }) }
    ),
    AchievementDef(
        id: "star_empire", name: "Star Empire",
        description: "Convert 500 stars. The galaxy has a new franchise owner.",
        icon: "star.circle.fill", phase: 5, category: .milestone,
        check: { $0.starsConverted >= 500 }
    ),

    // MARK: Meta (8)

    AchievementDef(
        id: "meta_phase1", name: "True Believer",
        description: "Unlock all Phase 1 achievements.",
        icon: "trophy.fill", phase: 1, category: .meta,
        check: { state in
            allAchievements.filter { $0.phase == 1 && $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_phase2", name: "The Establishment",
        description: "Unlock all Phase 2 achievements.",
        icon: "trophy.fill", phase: 2, category: .meta,
        check: { state in
            allAchievements.filter { $0.phase == 2 && $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_phase3", name: "World Leader",
        description: "Unlock all Phase 3 achievements.",
        icon: "trophy.fill", phase: 3, category: .meta,
        check: { state in
            allAchievements.filter { $0.phase == 3 && $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_phase4", name: "Cosmic Authority",
        description: "Unlock all Phase 4 achievements.",
        icon: "trophy.fill", phase: 4, category: .meta,
        check: { state in
            allAchievements.filter { $0.phase == 4 && $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_phase5", name: "God Emperor",
        description: "Unlock all Phase 5 achievements.",
        icon: "trophy.fill", phase: 5, category: .meta,
        check: { state in
            allAchievements.filter { $0.phase == 5 && $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_completionist", name: "Completionist",
        description: "Unlock every non-meta achievement. You have a problem.",
        icon: "diamond.fill", phase: 5, category: .meta,
        check: { state in
            allAchievements.filter { $0.category != .meta }.allSatisfy { state.achievements[$0.id] == true }
        }
    ),
    AchievementDef(
        id: "meta_prestige_veteran", name: "Prestige Veteran",
        description: "Reach prestige level 3. The cycle continues.",
        icon: "arrow.triangle.2.circlepath", phase: 5, category: .meta,
        check: { $0.prestigeLevel >= 3 }
    ),
    AchievementDef(
        id: "meta_long_game", name: "The Long Game",
        description: "Accumulate 24 hours of total play time. Greatness takes commitment.",
        icon: "clock.fill", phase: 1, category: .meta,
        check: { $0.totalPlayTime >= 86400 }
    ),
]

// MARK: - Lookup Helpers

let achievementRegistry: [String: AchievementDef] = {
    var map: [String: AchievementDef] = [:]
    for a in allAchievements { map[a.id] = a }
    return map
}()
