import SwiftUI

enum CosmicSubTab: String, CaseIterable {
    case overview = "Overview"
    case probes = "Probes"
    case harvesters = "Harvesters"
    case branding = "Branding"
    case singularity = "Singularity"
    case narrative = "Narrative"
}

struct CosmicView: View {
    @Environment(GameState.self) private var game
    @State private var selectedSubTab: CosmicSubTab = .overview

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(CosmicSubTab.allCases, id: \.self) { tab in
                        Button {
                            selectedSubTab = tab
                        } label: {
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(selectedSubTab == tab ? .bold : .regular)
                                .foregroundStyle(selectedSubTab == tab ? cosmicAccent : .secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedSubTab == tab ? cosmicAccent.opacity(0.15) : Color.clear)
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
            case .probes: probesTab
            case .harvesters: harvestersTab
            case .branding: brandingTab
            case .singularity: singularityTab
            case .narrative: narrativeTab
            }
        }
    }

    private let cosmicAccent = Color(red: 0.6, green: 0.2, blue: 1.0) // #9933FF

    // MARK: - Overview

    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Universe Conversion Progress
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "globe.americas.fill")
                            .foregroundStyle(cosmicAccent)
                        Text("UNIVERSE CONVERSION")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(game.universe.universeConverted))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(cosmicAccent)
                            .contentTransition(.numericText())
                    }

                    ProgressView(value: game.universe.universeConverted, total: 100)
                        .tint(cosmicAccent)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                // Resource cards
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "atom")
                            .foregroundStyle(.cyan)
                        Text("COSMIC RESOURCES")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }

                    HStack(spacing: 20) {
                        statColumn(label: "Probes", value: Fmt.compact(game.probesLaunched), color: .cyan)
                        statColumn(label: "Stars", value: "\(Int(game.starsConverted))/\(TOTAL_REACHABLE_STARS)", color: .orange)
                        statColumn(label: "Exec. Proc.", value: Fmt.compact(game.computronium), color: .yellow)
                        statColumn(label: "GU", value: Fmt.compact(game.greatnessUnits), color: cosmicAccent)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                // Reality Drift
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                            .foregroundStyle(driftColor)
                        Text("REALITY DRIFT")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(Int(game.realityDrift))%")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(driftColor)
                    }

                    ProgressView(value: game.realityDrift, total: 100)
                        .tint(driftColor)

                    Text(driftLabel)
                        .font(.caption)
                        .foregroundStyle(driftColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                // Quick status
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                        Text("SYSTEMS STATUS")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }

                    HStack(spacing: 12) {
                        statusDot("Probes", active: !game.universe.probeUpgrades.isEmpty, color: .cyan)
                        statusDot("Dyson", active: !game.universe.dysonUpgrades.isEmpty, color: .yellow)
                        statusDot("Stars", active: !game.universe.starBrandingUpgrades.isEmpty, color: .orange)
                        statusDot("Black Hole", active: !game.universe.blackHoleUpgrades.isEmpty, color: .pink)
                        statusDot("Narrative", active: !game.universe.narrativeResearch.isEmpty, color: cosmicAccent)
                    }
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)
            }
            .padding()
        }
    }

    // MARK: - Probes

    private var probesTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.cyan)
                        Text("MAGA REPLICATORS")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Self-replicating branding units. Make All Galaxies American.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Active Probes: \(Fmt.compact(game.probesLaunched))")
                            .font(.caption)
                            .foregroundStyle(.cyan)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                ForEach(probeUpgradeDefs, id: \.id) { def in
                    upgradeCard(
                        name: def.name,
                        description: def.description,
                        isOwned: game.universe.probeUpgrades[def.id] == true,
                        prereqMet: def.prerequisite == nil || game.universe.probeUpgrades[def.prerequisite!] == true,
                        canAfford: game.cash >= def.costCash && game.computronium >= def.costComputronium,
                        costs: [("$", def.costCash, Color.green), ("Comp", def.costComputronium, Color.yellow)],
                        effects: probeEffects(def),
                        accentColor: .cyan
                    ) {
                        game.purchaseProbeUpgrade(id: def.id)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Harvesters

    private var harvestersTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundStyle(.yellow)
                        Text("SOLAR GREATNESS HARVESTERS")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Capture stellar energy and convert it to Greatness Units.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                ForEach(dysonSwarmDefs, id: \.id) { def in
                    upgradeCard(
                        name: def.name,
                        description: def.description,
                        isOwned: game.universe.dysonUpgrades[def.id] == true,
                        prereqMet: def.prerequisite == nil || game.universe.dysonUpgrades[def.prerequisite!] == true,
                        canAfford: game.cash >= def.costCash && game.orbitalIndustry >= def.costOrbitalIndustry && game.computronium >= def.costComputronium,
                        costs: [("$", def.costCash, Color.green), ("OI", def.costOrbitalIndustry, Color.cyan), ("Comp", def.costComputronium, Color.yellow)],
                        effects: ["+\(Fmt.compact(def.guPerSecond)) GU/s"],
                        accentColor: .yellow
                    ) {
                        game.purchaseDysonUpgrade(id: def.id)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Branding

    private var brandingTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(.orange)
                        Text("STAR BRANDING")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Convert stars into Executive Processing substrate. Each yields \(Int(COMPUTRONIUM_PER_STAR)) computronium.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Branded: \(Int(game.starsConverted))/\(TOTAL_REACHABLE_STARS)")
                            .font(.caption)
                            .foregroundStyle(.orange)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                ForEach(starBrandingDefs, id: \.id) { def in
                    upgradeCard(
                        name: def.name,
                        description: def.description,
                        isOwned: game.universe.starBrandingUpgrades[def.id] == true,
                        prereqMet: def.prerequisite == nil || game.universe.starBrandingUpgrades[def.prerequisite!] == true,
                        canAfford: game.cash >= def.costCash && game.computronium >= def.costComputronium,
                        costs: [("$", def.costCash, Color.green), ("Comp", def.costComputronium, Color.yellow)],
                        effects: starBrandingEffects(def),
                        accentColor: .orange
                    ) {
                        game.purchaseStarBranding(id: def.id)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Singularity

    private var singularityTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "circle.dashed.inset.filled")
                            .foregroundStyle(.pink)
                        Text("GOLDEN LEDGER SINGULARITY")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Black hole accounting. Where numbers go when they're too big to audit.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                ForEach(blackHoleDefs, id: \.id) { def in
                    upgradeCard(
                        name: def.name,
                        description: def.description,
                        isOwned: game.universe.blackHoleUpgrades[def.id] == true,
                        prereqMet: def.prerequisite == nil || game.universe.blackHoleUpgrades[def.prerequisite!] == true,
                        canAfford: game.cash >= def.costCash && game.computronium >= def.costComputronium,
                        costs: [("$", def.costCash, Color.green), ("Comp", def.costComputronium, Color.yellow)],
                        effects: blackHoleEffects(def),
                        accentColor: .pink
                    ) {
                        game.purchaseBlackHole(id: def.id)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Narrative

    private var narrativeTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "book.closed.fill")
                            .foregroundStyle(cosmicAccent)
                        Text("NARRATIVE ARCHITECTURE")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Rewrite the laws of physics. Costs Greatness Units instead of cash.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(white: 0.12))
                .cornerRadius(12)

                ForEach(narrativeResearchDefs, id: \.id) { def in
                    let isOwned = game.universe.narrativeResearch[def.id] == true
                    let prereqMet = def.prerequisite == nil || game.universe.narrativeResearch[def.prerequisite!] == true
                    let canAfford = game.greatnessUnits >= def.costGU

                    VStack(spacing: 8) {
                        HStack {
                            Circle()
                                .fill(isOwned ? Color.green : (canAfford && prereqMet ? cosmicAccent : Color.gray.opacity(0.3)))
                                .frame(width: 10, height: 10)
                            Text(def.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(isOwned ? .green : .white)
                            Spacer()
                            if isOwned {
                                Text("RESEARCHED")
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
                            if def.guMultiplier > 0 {
                                effectBadge("\(def.guMultiplier)x GU", color: cosmicAccent)
                            }
                            if def.productionBonus > 0 {
                                effectBadge("+\(Fmt.compact(def.productionBonus)) GU/s", color: cosmicAccent)
                            }
                            if def.driftReduction > 0 {
                                effectBadge("-Drift", color: .green)
                            }
                            if def.legitimacyFloor > 0 {
                                effectBadge("Legit floor \(Int(def.legitimacyFloor))%", color: .green)
                            }
                            Spacer()
                        }

                        if !isOwned {
                            HStack {
                                Text("\(Fmt.compact(def.costGU)) GU")
                                    .font(.caption2)
                                    .foregroundStyle(cosmicAccent)
                                Spacer()
                                Button {
                                    game.purchaseNarrativeResearch(id: def.id)
                                } label: {
                                    Text("RESEARCH")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(canAfford && prereqMet ? cosmicAccent : Color.gray.opacity(0.3))
                                        .cornerRadius(8)
                                }
                                .disabled(!canAfford || !prereqMet)
                            }
                        }
                    }
                    .padding()
                    .background(Color(white: 0.12))
                    .cornerRadius(12)
                    .opacity(prereqMet || isOwned ? 1 : 0.4)
                }
            }
            .padding()
        }
    }

    // MARK: - Reusable Upgrade Card

    private func upgradeCard(
        name: String,
        description: String,
        isOwned: Bool,
        prereqMet: Bool,
        canAfford: Bool,
        costs: [(label: String, value: Double, color: Color)],
        effects: [String],
        accentColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(isOwned ? Color.green : (canAfford && prereqMet ? accentColor : Color.gray.opacity(0.3)))
                    .frame(width: 10, height: 10)
                Text(name)
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

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                ForEach(effects, id: \.self) { eff in
                    effectBadge(eff, color: accentColor)
                }
                Spacer()
            }

            if !isOwned {
                HStack {
                    ForEach(costs.filter({ $0.value > 0 }), id: \.label) { cost in
                        Text("\(cost.label) \(Fmt.compact(cost.value))")
                            .font(.caption2)
                            .foregroundStyle(cost.color)
                    }
                    Spacer()
                    Button {
                        action()
                    } label: {
                        Text("BUILD")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(canAfford && prereqMet ? accentColor : Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!canAfford || !prereqMet)
                }
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(12)
        .opacity(prereqMet || isOwned ? 1 : 0.4)
    }

    // MARK: - Effect Helpers

    private func probeEffects(_ def: ProbeUpgradeDef) -> [String] {
        var effects: [String] = []
        if def.probeProductionPerSecond > 0 { effects.append("+\(def.probeProductionPerSecond) probes/s") }
        if def.replicationRate > 0 { effects.append("+\(def.replicationRate) replication") }
        if def.conversionEfficiency > 0 { effects.append("\(def.conversionEfficiency)x conversion") }
        return effects
    }

    private func starBrandingEffects(_ def: StarBrandingDef) -> [String] {
        var effects: [String] = []
        if def.conversionRatePerSecond > 0 { effects.append("+\(def.conversionRatePerSecond) stars/s") }
        if def.driftPerConversion > 0 { effects.append("+\(def.driftPerConversion) drift/star") }
        if def.conversionRatePerSecond == 0 { effects.append("Enables conversion") }
        return effects
    }

    private func blackHoleEffects(_ def: BlackHoleDef) -> [String] {
        var effects: [String] = []
        if def.guStorage > 0 { effects.append("+\(Fmt.compact(def.guStorage)) GU/s") }
        if def.legitimacyPerSecond > 0 { effects.append("+Legitimacy") }
        if def.driftReduction > 0 { effects.append("-Drift") }
        return effects
    }

    // MARK: - Visual Helpers

    private var driftColor: Color {
        if game.realityDrift < 20 { return .green }
        if game.realityDrift < 40 { return .green }
        if game.realityDrift < 60 { return .yellow }
        if game.realityDrift < 80 { return .orange }
        return .red
    }

    private var driftLabel: String {
        if game.realityDrift < 20 { return "Stable" }
        if game.realityDrift < 40 { return "Minor Distortion" }
        if game.realityDrift < 60 { return "Narrative Drift" }
        if game.realityDrift < 80 { return "Reality Erosion" }
        return "Total Dissociation"
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
}
