import SwiftUI

enum SpaceSubTab: String, CaseIterable {
    case overview = "Overview"
    case launch = "Launch"
    case moon = "Moon"
    case mars = "Mars"
    case asteroids = "Mining"
    case weapons = "Weapons"
}

struct SpaceView: View {
    @Environment(GameState.self) private var game
    @State private var selectedSubTab: SpaceSubTab = .overview

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(SpaceSubTab.allCases, id: \.self) { tab in
                        Button {
                            selectedSubTab = tab
                        } label: {
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(selectedSubTab == tab ? .bold : .regular)
                                .foregroundStyle(selectedSubTab == tab ? .orange : .secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedSubTab == tab ? Color.orange.opacity(0.15) : Color.clear)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
            }
            .padding(.vertical, 4)

            switch selectedSubTab {
            case .overview: overviewTab
            case .launch: launchTab
            case .moon: moonTab
            case .mars: marsTab
            case .asteroids: asteroidsTab
            case .weapons: weaponsTab
            }
        }
    }

    // MARK: - Overview

    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                spaceResourcesCard
                launchStatusCard
                terraformCard
                bridgeUpgradesCard
            }
            .padding()
        }
    }

    private var spaceResourcesCard: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.cyan)
                Text("SPACE RESOURCES")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }

            HStack(spacing: 20) {
                statColumn(label: "Rocket Mass", value: Fmt.compact(game.rocketMass), color: .orange)
                statColumn(label: "Orbital Ind.", value: Fmt.compact(game.orbitalIndustry), color: .cyan)
                statColumn(label: "Mining", value: Fmt.compact(game.miningOutput), color: .yellow)
                statColumn(label: "Colonists", value: Fmt.compact(game.colonists), color: .green)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var launchStatusCard: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "airplane.departure")
                    .foregroundStyle(.orange)
                Text("LAUNCH INFRASTRUCTURE")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text(launchTierName(game.space.launchTier))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
            }

            if game.space.launchTier != .none {
                if let def = launchTierRegistry[game.space.launchTier] {
                    HStack {
                        Text("Rocket Mass: +\(Fmt.compact(def.rocketMassPerSecond))/s")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }

            // Quick status of major systems
            HStack(spacing: 12) {
                statusDot("Moon", active: game.space.moonBase, color: .gray)
                statusDot(game.space.marsRenamed ? "Orange Planet" : "Mars", active: game.space.marsColony, color: .red)
                statusDot("Asteroids", active: game.space.asteroidProspectors > 0, color: .yellow)
                statusDot("Dyson", active: game.space.dysonSwarms > 0, color: .cyan)
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var terraformCard: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(game.space.marsRenamed ? .orange : .red)
                Text(game.space.marsRenamed ? "ORANGE PLANET TERRAFORMING" : "MARS TERRAFORMING")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(Int(game.terraformProgress))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(game.space.marsRenamed ? .orange : .red)
            }

            ProgressView(value: game.terraformProgress, total: 100)
                .tint(game.space.marsRenamed ? .orange : .red)
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var bridgeUpgradesCard: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.purple)
                Text("BRIDGE UPGRADES")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }

            ForEach(bridgeUpgradeDefs, id: \.id) { def in
                let owned = game.space.bridgeUpgrades[def.id] == true
                let prereqMet = def.prerequisite == nil || game.space.bridgeUpgrades[def.prerequisite!] == true
                let costMult = spaceCostMultiplier
                let cost = def.costCash * costMult
                let canAfford = game.cash >= cost && game.loyalty >= def.costLoyalty && prereqMet && !owned

                HStack {
                    Circle()
                        .fill(owned ? Color.green : (canAfford ? Color.orange : Color.gray.opacity(0.3)))
                        .frame(width: 8, height: 8)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(def.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(owned ? .green : .white)
                        Text(def.description)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    if !owned {
                        Button {
                            game.purchaseBridgeUpgrade(id: def.id)
                        } label: {
                            Text(Fmt.compact(cost))
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                                .cornerRadius(6)
                        }
                        .disabled(!canAfford)
                    }
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    // MARK: - Launch Tab

    private var launchTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Current tier
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("CURRENT TIER")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }

                    if game.space.launchTier == .none {
                        Text("No launch infrastructure. Build a launchpad to begin.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else if let def = launchTierRegistry[game.space.launchTier] {
                        HStack {
                            Text(def.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Spacer()
                            Text("+\(Fmt.compact(def.rocketMassPerSecond)) RM/s")
                                .font(.caption)
                                .foregroundStyle(.cyan)
                        }
                    }
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                // All tiers
                ForEach(launchTierDefs, id: \.id) { def in
                    launchTierCard(def)
                }
            }
            .padding()
        }
    }

    private func launchTierCard(_ def: LaunchTierDef) -> some View {
        let isOwned = hasLaunchTier(current: game.space.launchTier, required: def.id)
        let prereqMet = hasLaunchTier(current: game.space.launchTier, required: def.prerequisite)
        let isNext = !isOwned && prereqMet
        let costMult = spaceCostMultiplier
        let cost = def.costCash * costMult
        let canAfford = game.cash >= cost && isNext

        return VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(isOwned ? Color.green : (isNext ? Color.orange : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)
                Text(def.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isOwned ? .green : .white)
                Spacer()
                if isOwned {
                    Text("ACTIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }

            HStack {
                Text(def.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            HStack {
                Text("+\(Fmt.compact(def.rocketMassPerSecond)) RM/s")
                    .font(.caption)
                    .foregroundStyle(.cyan)
                Spacer()
                if isNext {
                    Button {
                        game.upgradeLaunchTier()
                    } label: {
                        Text("$\(Fmt.compact(cost))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(isOwned || isNext ? 1 : 0.4)
    }

    // MARK: - Moon Tab

    private var moonTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if game.space.launchTier == .none {
                    lockedCard("Build a launchpad first to access lunar operations.")
                } else {
                    ForEach(lunarBuildingDefs, id: \.id) { def in
                        lunarBuildingCard(def)
                    }
                }
            }
            .padding()
        }
    }

    private func lunarBuildingCard(_ def: LunarBuildingDef) -> some View {
        let key = def.id
        let isBuilt: Bool = {
            switch key {
            case "moon_base": return game.space.moonBase
            case "he3_mining": return game.space.helium3Mining
            case "lunar_shipyard": return game.space.lunarShipyard
            case "lunar_heritage": return game.space.lunarHeritage
            default: return false
            }
        }()
        let prereqMet: Bool = {
            guard let prereq = def.prerequisite else { return true }
            switch prereq {
            case "moon_base": return game.space.moonBase
            case "he3_mining": return game.space.helium3Mining
            default: return false
            }
        }()
        let costMult = spaceCostMultiplier
        let costCash = def.costCash * costMult
        let canAfford = game.cash >= costCash && game.rocketMass >= def.costRocketMass && prereqMet && !isBuilt

        return VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(isBuilt ? Color.green : (canAfford ? Color.orange : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)
                Text(def.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isBuilt ? .green : .white)
                Spacer()
                if isBuilt {
                    Text("BUILT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }

            Text(def.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                if def.orbitalIndustryPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.orbitalIndustryPerSecond)) OI/s", color: .cyan)
                }
                if def.miningOutputPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.miningOutputPerSecond)) Mining/s", color: .yellow)
                }
                if def.legitimacyPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.legitimacyPerSecond)) Legit/s", color: .green)
                }
                if def.shipCostReduction > 0 {
                    effectBadge("-\(Int(def.shipCostReduction * 100))% Ship Cost", color: .purple)
                }
                Spacer()
            }

            if !isBuilt {
                HStack {
                    Text("$\(Fmt.compact(costCash))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("\(Fmt.compact(def.costRocketMass)) RM")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Spacer()
                    Button {
                        game.buildLunarBuilding(id: def.id)
                    } label: {
                        Text("BUILD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(prereqMet || isBuilt ? 1 : 0.4)
    }

    // MARK: - Mars Tab

    private var marsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Terraform progress
                terraformCard

                if game.space.launchTier == .none {
                    lockedCard("Build a launchpad first to access Mars operations.")
                } else {
                    ForEach(marsUpgradeDefs, id: \.id) { def in
                        marsUpgradeCard(def)
                    }
                }

                // Propaganda Satellites
                satelliteCard

                // Dyson Swarm Prototype
                dysonPrototypeCard
            }
            .padding()
        }
    }

    private func marsUpgradeCard(_ def: MarsUpgradeDef) -> some View {
        let key = def.id
        let isBuilt: Bool = {
            switch key {
            case "mars_colony": return game.space.marsColony
            case "atmosphere_processing": return game.space.atmosphereProcessing
            case "water_extraction": return game.space.waterExtraction
            default: return false
            }
        }()
        let prereqMet: Bool = {
            guard let prereq = def.prerequisite else { return true }
            switch prereq {
            case "mars_colony": return game.space.marsColony
            case "atmosphere_processing": return game.space.atmosphereProcessing
            default: return false
            }
        }()
        let costMult = spaceCostMultiplier
        let costCash = def.costCash * costMult
        let canAfford = game.cash >= costCash && game.rocketMass >= def.costRocketMass && game.miningOutput >= def.costMiningOutput && prereqMet && !isBuilt
        let displayName = game.space.marsRenamed ? (def.renamedName ?? def.name) : def.name

        return VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(isBuilt ? Color.green : (canAfford ? Color.orange : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)
                Text(displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isBuilt ? .green : .white)
                Spacer()
                if isBuilt {
                    Text("BUILT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }

            Text(def.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                if def.colonistsPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.colonistsPerSecond)) Col/s", color: .green)
                }
                if def.terraformPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.terraformPerSecond))% TF/s", color: .red)
                }
                if def.greatnessPerSecond > 0 {
                    effectBadge("+\(Fmt.compact(def.greatnessPerSecond)) G/s", color: .yellow)
                }
                Spacer()
            }

            if !isBuilt {
                HStack {
                    Text("$\(Fmt.compact(costCash))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("\(Fmt.compact(def.costRocketMass)) RM")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    if def.costMiningOutput > 0 {
                        Text("\(Fmt.compact(def.costMiningOutput)) Mining")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                    }
                    Spacer()
                    Button {
                        game.buildMarsUpgrade(id: def.id)
                    } label: {
                        Text("BUILD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(prereqMet || isBuilt ? 1 : 0.4)
    }

    // MARK: - Asteroids Tab

    private var asteroidsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if game.space.launchTier == .none {
                    lockedCard("Build a launchpad first to access asteroid operations.")
                } else {
                    ForEach(asteroidTierDefs, id: \.id) { def in
                        asteroidTierCard(def)
                    }
                }
            }
            .padding()
        }
    }

    private func asteroidTierCard(_ def: AsteroidTierDef) -> some View {
        let count: Int = {
            switch def.id {
            case "prospector_drones": return game.space.asteroidProspectors
            case "mining_rigs": return game.space.asteroidRigs
            case "refineries": return game.space.asteroidRefineries
            default: return 0
            }
        }()
        let prereqMet: Bool = {
            guard let prereq = def.prerequisite else { return true }
            switch prereq {
            case "prospector_drones": return game.space.asteroidProspectors > 0
            case "mining_rigs": return game.space.asteroidRigs > 0
            default: return false
            }
        }()
        let costMult = spaceCostMultiplier
        let costCash = def.costCash * costMult
        let canAfford = game.cash >= costCash && game.rocketMass >= def.costRocketMass && prereqMet && count < def.maxCount

        return VStack(spacing: 8) {
            HStack {
                Text(def.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(count)/\(def.maxCount)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(count >= def.maxCount ? .green : .orange)
            }

            Text(def.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                effectBadge("+\(Fmt.compact(def.miningOutputPerUnit)) Mining/unit", color: .yellow)
                Spacer()
                if count < def.maxCount {
                    Text("$\(Fmt.compact(costCash))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("\(Fmt.compact(def.costRocketMass)) RM")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Button {
                        game.buildAsteroidUnit(tierId: def.id)
                    } label: {
                        Text("+1")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(prereqMet || count > 0 ? 1 : 0.4)
    }

    private var satelliteCard: some View {
        let count = game.space.propagandaSatellites
        let costMult = spaceCostMultiplier
        let costCash = propagandaSatelliteCostCash * costMult
        let canAfford = game.cash >= costCash && game.orbitalIndustry >= propagandaSatelliteCostOI && count < propagandaSatelliteMax

        return VStack(spacing: 8) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundStyle(.purple)
                Text("PROPAGANDA SATELLITES")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(count)/\(propagandaSatelliteMax)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(count >= propagandaSatelliteMax ? .green : .purple)
            }

            HStack {
                effectBadge("+\(Fmt.compact(propagandaSatelliteLegitimacyPerUnit)) Legit/s", color: .green)
                effectBadge("+\(Fmt.compact(propagandaSatelliteAttentionPerUnit)) Att/s", color: .cyan)
                effectBadge("+Drift", color: .red)
                Spacer()
            }

            if count < propagandaSatelliteMax {
                HStack {
                    Text("$\(Fmt.compact(costCash))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("\(Fmt.compact(propagandaSatelliteCostOI)) OI")
                        .font(.caption2)
                        .foregroundStyle(.cyan)
                    Spacer()
                    Button {
                        game.buildSatellite()
                    } label: {
                        Text("DEPLOY")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.purple : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    private var dysonPrototypeCard: some View {
        let isBuilt = game.space.dysonSwarms > 0
        let hasReqTier = hasLaunchTier(current: game.space.launchTier, required: dysonPrototypeRequiresLaunchTier)
        let hasReqOI = game.orbitalIndustry >= dysonPrototypeRequiresOI
        let costMult = spaceCostMultiplier
        let costCash = dysonPrototypeCostCash * costMult
        let canAfford = game.cash >= costCash && game.orbitalIndustry >= dysonPrototypeCostOI && hasReqTier && hasReqOI && !isBuilt

        return VStack(spacing: 8) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundStyle(.yellow)
                Text("DYSON SWARM PROTOTYPE")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                if isBuilt {
                    Text("DEPLOYED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }

            Text(dysonPrototypeDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !hasReqTier {
                Text("Requires: Mass Driver")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if !hasReqOI {
                Text("Requires: \(Int(dysonPrototypeRequiresOI)) Orbital Industry")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if !isBuilt {
                HStack {
                    Text("$\(Fmt.compact(costCash))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text("\(Fmt.compact(dysonPrototypeCostOI)) OI")
                        .font(.caption2)
                        .foregroundStyle(.cyan)
                    Spacer()
                    Button {
                        game.buildDysonPrototype()
                    } label: {
                        Text("CONSTRUCT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.yellow : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
    }

    // MARK: - Weapons Tab

    private var weaponsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(spaceWeaponDefs, id: \.id) { def in
                    weaponCard(def)
                }
            }
            .padding()
        }
    }

    private func weaponCard(_ def: SpaceWeaponDef) -> some View {
        let isOwned = game.space.spaceWeapons[def.id] == true
        let hasReqTier = hasLaunchTier(current: game.space.launchTier, required: def.requiresLaunchTier)
        let costMult = spaceCostMultiplier
        let cost = def.costCash * costMult
        let canAfford = game.cash >= cost && hasReqTier && !isOwned

        return VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(isOwned ? Color.red : (canAfford ? Color.orange : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)
                Text(def.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isOwned ? .red : .white)
                Spacer()
                if isOwned {
                    Text("DEPLOYED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }
            }

            Text(def.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                effectBadge("+\(Fmt.compact(def.warOutput)) War", color: .red)
                effectBadge("+\(Fmt.compact(def.fear)) Fear", color: .orange)
                effectBadge("\(Int(def.legitimacyImpact)) Legit", color: .red)
                Spacer()
            }

            if !hasReqTier {
                Text("Requires: \(launchTierName(def.requiresLaunchTier))")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if !isOwned {
                HStack {
                    Spacer()
                    Button {
                        game.purchaseSpaceWeapon(id: def.id)
                    } label: {
                        Text("$\(Fmt.compact(cost))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford ? Color.red : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(hasReqTier || isOwned ? 1 : 0.4)
    }

    // MARK: - Helpers

    private var spaceCostMultiplier: Double {
        game.space.bridgeUpgrades["reality_budgeting"] == true ? 0.7 : 1.0
    }

    private func launchTierName(_ tier: LaunchTier) -> String {
        launchTierRegistry[tier]?.name ?? (tier == .none ? "None" : tier.rawValue)
    }

    private func statColumn(label: String, value: String, color: Color) -> some View {
        VStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
    }

    private func statusDot(_ label: String, active: Bool, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(active ? color : Color.gray.opacity(0.3))
                .frame(width: 6, height: 6)
            Text(label)
                .font(.caption2)
                .foregroundStyle(active ? .white : .secondary)
        }
    }

    private func effectBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .cornerRadius(4)
    }

    private func lockedCard(_ message: String) -> some View {
        VStack {
            Image(systemName: "lock.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}
