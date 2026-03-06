import Foundation
import Observation

@Observable
final class GameState: Codable {
    // MARK: - Meta
    var phase: Phase = .personalBrand
    var startedAt: Double = Date().timeIntervalSince1970
    var lastTickAt: Double = Date().timeIntervalSince1970
    var lastSaveAt: Double = 0
    var totalPlayTime: Double = 0
    var prestigeLevel: Int = 0
    var prestigePoints: Double = 0

    // MARK: - Core Resources
    var greatness: Double = 0
    var greatnessPerSecond: Double = 0
    var cash: Double = 0
    var attention: Double = 0
    var influence: Double = 0

    // MARK: - Phase 2+
    var loyalty: Double = 50
    var control: Double = 0
    var legitimacy: Double = 100
    var surveillance: Double = 0

    // MARK: - Budget (Phase 2+)
    var budget: BudgetAllocation = BudgetAllocation()

    // MARK: - Tariffs (Phase 2+)
    var tariffs: [String: TariffState] = [:]

    // MARK: - Data Centers (Phase 2+)
    var dataCenterUpgrades: [String: Bool] = [:]

    // MARK: - Loyalty Upgrades (Phase 2+)
    var loyaltyUpgrades: [String: Bool] = [:]

    // MARK: - Phase 3+
    var treatyPower: Double = 0
    var sanctions: Double = 0
    var annexationPoints: Double = 0
    var warOutput: Double = 0
    var nobelScore: Double = 0
    var nobelPrizesWon: Int = 0
    var nobelThreshold: Double = 100
    var fear: Double = 0

    // MARK: - Phase 4+
    var rocketMass: Double = 0
    var orbitalIndustry: Double = 0
    var miningOutput: Double = 0
    var colonists: Double = 0
    var terraformProgress: Double = 0

    // MARK: - Phase 5+
    var computronium: Double = 0
    var greatnessUnits: Double = 0
    var realityDrift: Double = 0
    var starsConverted: Double = 0
    var probesLaunched: Double = 0

    // MARK: - Meta-currency
    var doublethinkTokens: Double = 0

    // MARK: - Tracking
    var clickCount: Int = 0
    var attentionPerClick: Double = 1

    // MARK: - Upgrades
    var upgrades: [String: UpgradeState] = [:]

    // MARK: - Institutions (Phase 2)
    var institutions: [String: InstitutionState] = [:]

    // MARK: - Countries (Phase 3)
    var countries: [String: CountryState] = [:]

    // MARK: - Fleet (Phase 3)
    var fleet: [String: Int] = [:]
    var shipyardLevel: Int = 0
    var shipyardQueue: ShipyardOrder? = nil

    // MARK: - Space (Phase 4)
    var space: SpaceState = SpaceState()

    // MARK: - Universe (Phase 5)
    var universe: UniverseState = UniverseState()

    // MARK: - Contradictions
    var contradictions: [String: ContradictionState] = [:]

    // MARK: - Events
    var eventQueue: [GameEvent] = []
    var eventHistory: [String] = []
    var activeEvent: GameEvent? = nil
    var nextEventAt: Double = 0

    // MARK: - Achievements
    var achievements: [String: Bool] = [:]

    // MARK: - Prestige Upgrades
    var prestigeUpgrades: [String: Bool] = [:]

    // MARK: - Phase Transition
    var pendingTransitionFrom: Phase? = nil
    var pendingTransitionTo: Phase? = nil

    // MARK: - Settings
    var settings: GameSettings = GameSettings()

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case phase, startedAt, lastTickAt, lastSaveAt, totalPlayTime, prestigeLevel, prestigePoints
        case greatness, greatnessPerSecond, cash, attention, influence
        case loyalty, control, legitimacy, surveillance
        case budget, tariffs, dataCenterUpgrades, loyaltyUpgrades
        case treatyPower, sanctions, annexationPoints, warOutput
        case nobelScore, nobelPrizesWon, nobelThreshold, fear
        case rocketMass, orbitalIndustry, miningOutput, colonists, terraformProgress
        case computronium, greatnessUnits, realityDrift, starsConverted, probesLaunched
        case doublethinkTokens
        case clickCount, attentionPerClick
        case upgrades, institutions, countries
        case fleet, shipyardLevel, shipyardQueue
        case space, universe, contradictions
        case eventHistory, nextEventAt
        case achievements, prestigeUpgrades
        case settings
    }

    init() {}

    // MARK: - Actions

    func click() {
        clickCount += 1
        attention += attentionPerClick
    }

    func purchaseUpgrade(id: String) -> Bool {
        guard let data = upgradeRegistry[id] else { return false }

        let state = upgrades[id] ?? UpgradeState()
        guard state.count < data.maxCount else { return false }

        let cost = GameEngine.upgradeCost(data: data, currentCount: state.count)

        // Check affordability
        switch data.costResource {
        case .attention:
            guard attention >= cost else { return false }
            attention -= cost
        case .cash:
            guard cash >= cost else { return false }
            cash -= cost
        case .greatness:
            guard greatness >= cost else { return false }
            greatness -= cost
        }

        // Update upgrade state
        var newState = state
        newState.count += 1
        newState.purchased = true
        newState.unlocked = true
        upgrades[id] = newState

        // Apply immediate effects (attentionPerClick)
        attentionPerClick = GameEngine.calculateAttentionPerClick(state: self)

        return true
    }

    /// Check which upgrades should be visible based on prerequisites and unlock conditions
    func isUpgradeVisible(_ data: UpgradeData) -> Bool {
        // Check prerequisite upgrades are purchased
        for prereq in data.prerequisites {
            guard let state = upgrades[prereq], state.purchased else { return false }
        }

        // Check unlock conditions
        if let condition = data.unlockAt {
            let value: Double
            switch condition.resource {
            case "attention": value = attention
            case "cash": value = cash
            case "greatness": value = greatness
            case "clickCount": value = Double(clickCount)
            default: value = 0
            }
            if value < condition.threshold { return false }
        }

        return true
    }

    // MARK: - Event Actions

    func resolveEvent(choice: EventChoice) {
        for effect in choice.effects {
            applyEffect(effect)
        }
        if let event = activeEvent {
            eventHistory.append(event.id)
        }
        activeEvent = nil
        // Schedule next event
        nextEventAt = EventEngine.scheduleNext(phase: phase.rawValue, now: Date().timeIntervalSince1970)
    }

    func dismissEvent() {
        if let event = activeEvent {
            eventHistory.append(event.id)
        }
        activeEvent = nil
        nextEventAt = EventEngine.scheduleNext(phase: phase.rawValue, now: Date().timeIntervalSince1970)
    }

    func applyEffect(_ effect: Effect) {
        let amount = effect.amount
        switch effect.resource {
        case "attention": attention += amount
        case "cash": cash += amount
        case "greatness": greatness += amount
        case "influence": influence += amount
        case "legitimacy": legitimacy = max(0, min(100, legitimacy + amount))
        case "fear": fear += amount
        case "nobelScore": nobelScore += amount
        case "loyalty": loyalty += amount
        case "control": control += amount
        case "surveillance": surveillance += amount
        default: break
        }
    }

    // MARK: - Institution Actions

    func startInstitutionAction(institutionId: String, actionType: String) {
        guard let actionDef = actionRegistry[actionType] else { return }
        guard cash >= actionDef.costCash, loyalty >= actionDef.costLoyalty else { return }

        cash -= actionDef.costCash
        loyalty -= actionDef.costLoyalty
        legitimacy = max(0, min(100, legitimacy + actionDef.legitimacyImpact))

        var inst = institutions[institutionId] ?? InstitutionState()

        // Map action type to status for in-progress tracking
        switch actionType {
        case "co-opt": inst.status = .coOpting
        case "replace": inst.status = .replacing
        case "purge": inst.status = .purging
        case "rebrand": inst.rebranded = true
        case "automate": inst.status = .automated
        case "privatize":
            cash += 50000 // privatize earns cash
            return
        case "loyalty_test":
            inst.resistance = max(0, inst.resistance - actionDef.resistanceReduction)
            if inst.resistance <= 0 { inst.status = .captured }
            institutions[institutionId] = inst
            return
        default: break
        }

        inst.actionStartedAt = Date().timeIntervalSince1970
        inst.progress = 0
        institutions[institutionId] = inst
    }

    // MARK: - Tariff Actions

    func setTariffLevel(tariffId: String, level: Int) {
        var state = tariffs[tariffId] ?? TariffState()
        state.level = max(0, min(3, level))
        state.active = level > 0
        tariffs[tariffId] = state
    }

    // MARK: - Data Center Actions

    func purchaseDataCenter(id: String) {
        guard let def = dataCenterRegistry[id] else { return }
        guard dataCenterUpgrades[id] != true else { return }
        if let prereq = def.prerequisite {
            guard dataCenterUpgrades[prereq] == true else { return }
        }
        guard cash >= def.cost else { return }
        cash -= def.cost
        dataCenterUpgrades[id] = true
    }

    // MARK: - Loyalty Upgrade Actions

    func purchaseLoyaltyUpgrade(id: String) {
        guard let def = loyaltyUpgradeRegistry[id] else { return }
        guard loyaltyUpgrades[id] != true else { return }
        guard loyalty >= def.costLoyalty, cash >= def.costCash else { return }
        loyalty -= def.costLoyalty
        cash -= def.costCash
        loyaltyUpgrades[id] = true
    }

    // MARK: - Phase Transition

    func checkPhaseTransition() -> Phase? {
        switch phase {
        case .personalBrand:
            if upgrades["sci_neural_backup"]?.purchased == true { return .institutionalCapture }
        case .institutionalCapture:
            let insts = institutions.values
            if insts.count >= 13 && insts.allSatisfy({ $0.status == .captured || $0.status == .automated }) {
                return .worldGreatening
            }
        case .worldGreatening:
            let ctrs = countries.values
            if ctrs.count >= 14 && ctrs.allSatisfy({ $0.status == .annexed || $0.status == .allied }) {
                return .spaceGreatening
            }
        case .spaceGreatening:
            if space.dysonSwarms > 0 && space.asteroidRigs >= 5 && orbitalIndustry >= 100 {
                return .cosmicGreatening
            }
        case .cosmicGreatening:
            break // Endgame, no auto-transition
        }
        return nil
    }

    func completePhaseTransition(to newPhase: Phase) {
        phase = newPhase
        pendingTransitionFrom = nil
        pendingTransitionTo = nil
        // Schedule first event for the new phase
        nextEventAt = EventEngine.scheduleNext(phase: newPhase.rawValue, now: Date().timeIntervalSince1970)

        // Phase-specific initialization
        if newPhase == .institutionalCapture {
            // Initialize all 13 institutions
            for def in institutionDefs {
                self.institutions[def.id] = InstitutionState(
                    status: .independent,
                    resistance: def.resistance
                )
            }
        }
    }

    // MARK: - Upgrade Helpers

    func isUpgradeAffordable(_ data: UpgradeData) -> Bool {
        let state = upgrades[data.id] ?? UpgradeState()
        guard state.count < data.maxCount else { return false }
        let cost = GameEngine.upgradeCost(data: data, currentCount: state.count)
        switch data.costResource {
        case .attention: return attention >= cost
        case .cash: return cash >= cost
        case .greatness: return greatness >= cost
        }
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        phase = try c.decode(Phase.self, forKey: .phase)
        startedAt = try c.decode(Double.self, forKey: .startedAt)
        lastTickAt = try c.decode(Double.self, forKey: .lastTickAt)
        lastSaveAt = try c.decode(Double.self, forKey: .lastSaveAt)
        totalPlayTime = try c.decode(Double.self, forKey: .totalPlayTime)
        prestigeLevel = try c.decode(Int.self, forKey: .prestigeLevel)
        prestigePoints = try c.decode(Double.self, forKey: .prestigePoints)
        greatness = try c.decode(Double.self, forKey: .greatness)
        greatnessPerSecond = try c.decode(Double.self, forKey: .greatnessPerSecond)
        cash = try c.decode(Double.self, forKey: .cash)
        attention = try c.decode(Double.self, forKey: .attention)
        influence = try c.decode(Double.self, forKey: .influence)
        loyalty = try c.decode(Double.self, forKey: .loyalty)
        control = try c.decode(Double.self, forKey: .control)
        legitimacy = try c.decode(Double.self, forKey: .legitimacy)
        surveillance = try c.decode(Double.self, forKey: .surveillance)
        budget = try c.decode(BudgetAllocation.self, forKey: .budget)
        tariffs = try c.decode([String: TariffState].self, forKey: .tariffs)
        dataCenterUpgrades = try c.decode([String: Bool].self, forKey: .dataCenterUpgrades)
        loyaltyUpgrades = try c.decode([String: Bool].self, forKey: .loyaltyUpgrades)
        treatyPower = try c.decode(Double.self, forKey: .treatyPower)
        sanctions = try c.decode(Double.self, forKey: .sanctions)
        annexationPoints = try c.decode(Double.self, forKey: .annexationPoints)
        warOutput = try c.decode(Double.self, forKey: .warOutput)
        nobelScore = try c.decode(Double.self, forKey: .nobelScore)
        nobelPrizesWon = try c.decode(Int.self, forKey: .nobelPrizesWon)
        nobelThreshold = try c.decode(Double.self, forKey: .nobelThreshold)
        fear = try c.decode(Double.self, forKey: .fear)
        rocketMass = try c.decode(Double.self, forKey: .rocketMass)
        orbitalIndustry = try c.decode(Double.self, forKey: .orbitalIndustry)
        miningOutput = try c.decode(Double.self, forKey: .miningOutput)
        colonists = try c.decode(Double.self, forKey: .colonists)
        terraformProgress = try c.decode(Double.self, forKey: .terraformProgress)
        computronium = try c.decode(Double.self, forKey: .computronium)
        greatnessUnits = try c.decode(Double.self, forKey: .greatnessUnits)
        realityDrift = try c.decode(Double.self, forKey: .realityDrift)
        starsConverted = try c.decode(Double.self, forKey: .starsConverted)
        probesLaunched = try c.decode(Double.self, forKey: .probesLaunched)
        doublethinkTokens = try c.decode(Double.self, forKey: .doublethinkTokens)
        clickCount = try c.decode(Int.self, forKey: .clickCount)
        attentionPerClick = try c.decode(Double.self, forKey: .attentionPerClick)
        upgrades = try c.decode([String: UpgradeState].self, forKey: .upgrades)
        institutions = try c.decode([String: InstitutionState].self, forKey: .institutions)
        countries = try c.decode([String: CountryState].self, forKey: .countries)
        fleet = try c.decode([String: Int].self, forKey: .fleet)
        shipyardLevel = try c.decode(Int.self, forKey: .shipyardLevel)
        shipyardQueue = try c.decodeIfPresent(ShipyardOrder.self, forKey: .shipyardQueue)
        space = try c.decode(SpaceState.self, forKey: .space)
        universe = try c.decode(UniverseState.self, forKey: .universe)
        contradictions = try c.decode([String: ContradictionState].self, forKey: .contradictions)
        eventHistory = try c.decode([String].self, forKey: .eventHistory)
        nextEventAt = try c.decode(Double.self, forKey: .nextEventAt)
        achievements = try c.decode([String: Bool].self, forKey: .achievements)
        prestigeUpgrades = try c.decode([String: Bool].self, forKey: .prestigeUpgrades)
        settings = try c.decode(GameSettings.self, forKey: .settings)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(phase, forKey: .phase)
        try c.encode(startedAt, forKey: .startedAt)
        try c.encode(lastTickAt, forKey: .lastTickAt)
        try c.encode(lastSaveAt, forKey: .lastSaveAt)
        try c.encode(totalPlayTime, forKey: .totalPlayTime)
        try c.encode(prestigeLevel, forKey: .prestigeLevel)
        try c.encode(prestigePoints, forKey: .prestigePoints)
        try c.encode(greatness, forKey: .greatness)
        try c.encode(greatnessPerSecond, forKey: .greatnessPerSecond)
        try c.encode(cash, forKey: .cash)
        try c.encode(attention, forKey: .attention)
        try c.encode(influence, forKey: .influence)
        try c.encode(loyalty, forKey: .loyalty)
        try c.encode(control, forKey: .control)
        try c.encode(legitimacy, forKey: .legitimacy)
        try c.encode(surveillance, forKey: .surveillance)
        try c.encode(budget, forKey: .budget)
        try c.encode(tariffs, forKey: .tariffs)
        try c.encode(dataCenterUpgrades, forKey: .dataCenterUpgrades)
        try c.encode(loyaltyUpgrades, forKey: .loyaltyUpgrades)
        try c.encode(treatyPower, forKey: .treatyPower)
        try c.encode(sanctions, forKey: .sanctions)
        try c.encode(annexationPoints, forKey: .annexationPoints)
        try c.encode(warOutput, forKey: .warOutput)
        try c.encode(nobelScore, forKey: .nobelScore)
        try c.encode(nobelPrizesWon, forKey: .nobelPrizesWon)
        try c.encode(nobelThreshold, forKey: .nobelThreshold)
        try c.encode(fear, forKey: .fear)
        try c.encode(rocketMass, forKey: .rocketMass)
        try c.encode(orbitalIndustry, forKey: .orbitalIndustry)
        try c.encode(miningOutput, forKey: .miningOutput)
        try c.encode(colonists, forKey: .colonists)
        try c.encode(terraformProgress, forKey: .terraformProgress)
        try c.encode(computronium, forKey: .computronium)
        try c.encode(greatnessUnits, forKey: .greatnessUnits)
        try c.encode(realityDrift, forKey: .realityDrift)
        try c.encode(starsConverted, forKey: .starsConverted)
        try c.encode(probesLaunched, forKey: .probesLaunched)
        try c.encode(doublethinkTokens, forKey: .doublethinkTokens)
        try c.encode(clickCount, forKey: .clickCount)
        try c.encode(attentionPerClick, forKey: .attentionPerClick)
        try c.encode(upgrades, forKey: .upgrades)
        try c.encode(institutions, forKey: .institutions)
        try c.encode(countries, forKey: .countries)
        try c.encode(fleet, forKey: .fleet)
        try c.encode(shipyardLevel, forKey: .shipyardLevel)
        try c.encode(shipyardQueue, forKey: .shipyardQueue)
        try c.encode(space, forKey: .space)
        try c.encode(universe, forKey: .universe)
        try c.encode(contradictions, forKey: .contradictions)
        try c.encode(eventHistory, forKey: .eventHistory)
        try c.encode(nextEventAt, forKey: .nextEventAt)
        try c.encode(achievements, forKey: .achievements)
        try c.encode(prestigeUpgrades, forKey: .prestigeUpgrades)
        try c.encode(settings, forKey: .settings)
    }
}
