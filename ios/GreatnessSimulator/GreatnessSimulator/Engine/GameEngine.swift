import Foundation

struct GameEngine {

    // MARK: - Tick (called every 100ms)

    static func tick(state: GameState, now: Double) {
        let dt = now - state.lastTickAt
        guard dt > 0, dt < 10 else {
            // Clamp: skip ticks > 10s (handle offline separately)
            state.lastTickAt = now
            return
        }

        state.totalPlayTime += dt
        state.lastTickAt = now

        // Recalculate derived rates
        let gps = calculateGPS(state: state)
        let attPerSec = calculateAttentionPerSecond(state: state)
        let cashPerSec = calculateCashPerSecond(state: state)

        state.greatnessPerSecond = gps

        // Apply production
        state.greatness += gps * dt
        state.attention += attPerSec * dt
        state.cash += cashPerSec * dt

        // Phase 2+ systems
        if state.phase.rawValue >= 2 {
            tickInstitutions(state: state, now: now)
            tickTariffs(state: state, dt: dt)
            tickLegitimacy(state: state, dt: dt)
            tickLoyaltyGeneration(state: state, dt: dt)
        }

        // Phase 3+ systems
        if state.phase.rawValue >= 3 {
            tickCountries(state: state, dt: dt, now: now)
            tickShipyard(state: state, now: now)
            tickFear(state: state, dt: dt)
            tickNobel(state: state, dt: dt)
        }

        // Phase 4+ systems
        if state.phase.rawValue >= 4 {
            tickSpace(state: state, dt: dt)
        }

        // Phase 5+ systems
        if state.phase.rawValue >= 5 {
            tickCosmic(state: state, dt: dt)
        }

        // Event scheduling — seed first event if needed
        if state.nextEventAt == 0 {
            state.nextEventAt = EventEngine.scheduleNext(phase: state.phase.rawValue, now: now, prestigeUpgrades: state.prestigeUpgrades)
        }

        // Event trigger
        if EventEngine.shouldTrigger(state: state, now: now) {
            if let event = EventEngine.selectEvent(state: state, pool: allEvents(for: state.phase)) {
                state.activeEvent = event
            } else {
                // No eligible events — reschedule
                state.nextEventAt = EventEngine.scheduleNext(phase: state.phase.rawValue, now: now, prestigeUpgrades: state.prestigeUpgrades)
            }
        }

        // Phase transition check (only when no pending transition and no active event)
        if state.pendingTransitionFrom == nil && state.activeEvent == nil {
            if let nextPhase = state.checkPhaseTransition() {
                state.pendingTransitionFrom = state.phase
                state.pendingTransitionTo = nextPhase
            }
        }
    }

    // MARK: - Event Pool

    static func allEvents(for phase: Phase) -> [GameEvent] {
        switch phase {
        case .personalBrand: return phase1Events
        case .institutionalCapture: return phase2Events
        case .worldGreatening: return phase3Events
        case .spaceGreatening: return phase4Events
        case .cosmicGreatening: return phase5Events
        }
    }

    // MARK: - Institution Tick

    static func tickInstitutions(state: GameState, now: Double) {
        for (id, var inst) in state.institutions {
            guard let actionStarted = inst.actionStartedAt else { continue }
            let actionType = inst.status.rawValue
            guard let actionDef = actionRegistry[actionType] else { continue }

            let elapsed = now - actionStarted
            inst.progress = min(1.0, elapsed / actionDef.duration)

            if elapsed >= actionDef.duration {
                // Action complete
                inst.resistance = max(0, inst.resistance - actionDef.resistanceReduction)
                inst.actionStartedAt = nil
                inst.progress = 0

                if inst.resistance <= 0 {
                    inst.status = .captured
                } else {
                    inst.status = .independent
                }
            }

            state.institutions[id] = inst
        }

        // GpS from captured institutions
        // (handled in calculateGPS)
    }

    // MARK: - Tariff Tick

    static func tickTariffs(state: GameState, dt: Double) {
        for def in tariffDefs {
            let level = state.tariffs[def.id]?.level ?? 0
            guard level > 0 else { continue }

            // Cash per minute -> per second
            state.cash += (def.cashPerMinute[level] / 60.0) * dt

            // Legitimacy drain per second
            state.legitimacy = max(0, min(100, state.legitimacy + def.legitimacyDrain[level] * dt))
        }
    }

    // MARK: - Legitimacy Tick

    static func tickLegitimacy(state: GameState, dt: Double) {
        let budget = state.budget

        // Base decay
        var decay: Double = 0.001

        // Decay from captured institutions
        let capturedCount = state.institutions.values.filter { $0.status == .captured || $0.status == .automated }.count
        decay += Double(capturedCount) * 0.0002

        // Prestige: reduce decay rate
        decay *= prestigeLegitimacyDecayMultiplier(upgrades: state.prestigeUpgrades)

        // Recovery from budget
        let healthRecovery = budget.healthcare * 0.003
        let socialRecovery = budget.socialBenefits * 0.002
        let propRecovery = budget.propagandaBureau * 0.004
        let recovery = (healthRecovery + socialRecovery + propRecovery) / 100.0 // normalize from percentage

        let netChange = (recovery - decay) * dt
        let floor = prestigeLegitimacyFloor(upgrades: state.prestigeUpgrades)
        state.legitimacy = max(floor, min(100, state.legitimacy + netChange))
    }

    // MARK: - Loyalty Generation Tick

    static func tickLoyaltyGeneration(state: GameState, dt: Double) {
        var loyaltyPerSec: Double = 0

        // Loyalty from captured institutions
        for (id, inst) in state.institutions {
            guard inst.status == .captured || inst.status == .automated else { continue }
            guard let def = institutionRegistry[id] else { continue }
            loyaltyPerSec += def.loyaltyGeneration
        }

        // Loyalty from loyalty upgrades
        if state.loyaltyUpgrades["loyalty_pledges"] == true { loyaltyPerSec += 0.5 }
        if state.loyaltyUpgrades["loyalty_rewards"] == true { loyaltyPerSec += 1.0 }
        if state.loyaltyUpgrades["loyalty_hiring"] == true { loyaltyPerSec += 2.0 }

        state.loyalty += loyaltyPerSec * dt
    }

    // MARK: - Country Tick

    static func tickCountries(state: GameState, dt: Double, now: Double) {
        for (id, var country) in state.countries {
            // Process active operations
            var completedOps: [ActiveOperation] = []
            var remaining: [ActiveOperation] = []

            for op in country.activeOperations {
                let elapsed = now - op.startedAt
                if elapsed >= op.duration {
                    completedOps.append(op)
                } else {
                    remaining.append(op)
                }
            }
            country.activeOperations = remaining

            for op in completedOps {
                guard let tacticDef = tacticRegistry[op.tacticType] else { continue }

                // Apply resistance reduction
                country.resistance = max(0, country.resistance - tacticDef.resistanceReduction)

                // Apply stability impact
                country.stability = max(0, min(100, country.stability + tacticDef.stabilityImpact))

                // Apply fear
                state.fear += tacticDef.fearGenerated

                // Apply Nobel impact
                state.nobelScore += tacticDef.nobelImpact

                // Special mechanic handling
                switch op.tacticType {
                case "joint_defense":
                    country.encirclement += 15
                case "trade_integration":
                    country.tradeDependency += 20
                case "purchase_offer":
                    country.purchaseOffers += 1
                case "annexation", "full_absorption", "absorption_referendum":
                    country.status = .annexed
                case "kompromat_resist":
                    country.kompromatLevel = max(0, country.kompromatLevel - 20)
                case "aid_reduction":
                    country.kompromatLevel = max(0, country.kompromatLevel - 10)
                case "leverage_reversal":
                    country.kompromatLevel = max(0, country.kompromatLevel - 40)
                default: break
                }

                // Refugee wave mechanic (Sand Republic / Copper States wars -> Eurovia/Nordland)
                if (id == "sand_republic" || id == "copper_states") &&
                   (op.tacticType == "freedom_operation" || op.tacticType == "coup_sponsorship") {
                    country.refugeeWavesSent += 1
                    // Destabilize Eurovia and Nordland
                    if var eurovia = state.countries["eurovia"] {
                        eurovia.stability = max(0, eurovia.stability - 5)
                        eurovia.resistance = max(0, eurovia.resistance - 3)
                        state.countries["eurovia"] = eurovia
                    }
                    if var nordland = state.countries["nordland"] {
                        nordland.stability = max(0, nordland.stability - 5)
                        nordland.resistance = max(0, nordland.resistance - 3)
                        state.countries["nordland"] = nordland
                    }
                }
            }

            // Country-specific special mechanics
            if id == "tundra_republic" && country.encirclement >= 100 {
                country.resistance = 0
            }
            if id == "maple_federation" && country.tradeDependency >= 100 {
                country.resistance = min(country.resistance, 10)
            }
            if id == "frostheim" && country.purchaseOffers >= 5 {
                country.resistance = 0
            }

            // Status transitions (only for non-annexed/non-allied)
            if country.status != .annexed && country.status != .allied {
                if country.resistance <= 0 {
                    country.status = .occupied
                } else if country.resistance < 30 && country.status == .independent {
                    country.status = .infiltrated
                } else if country.stability < 20 && country.status == .independent {
                    country.status = .coupTarget
                }
            }

            state.countries[id] = country
        }
    }

    // MARK: - Shipyard Tick

    static func tickShipyard(state: GameState, now: Double) {
        guard var queue = state.shipyardQueue else { return }
        guard state.shipyardLevel > 0 else { return }

        let buildInterval = 10.0 / Double(state.shipyardLevel)
        let elapsed = now - queue.lastBuildAt
        let shipsToBuild = Int(elapsed / buildInterval)

        if shipsToBuild > 0 {
            let remaining = queue.quantity - queue.builtSoFar
            let built = min(shipsToBuild, remaining)
            queue.builtSoFar += built
            queue.lastBuildAt = now

            state.fleet[queue.shipId, default: 0] += built

            // Recalculate war output and fear from fleet
            recalculateFleetStats(state: state)

            if queue.builtSoFar >= queue.quantity {
                state.shipyardQueue = nil
            } else {
                state.shipyardQueue = queue
            }
        }
    }

    // MARK: - Fleet Stats

    static func recalculateFleetStats(state: GameState) {
        var totalWarOutput: Double = 0
        var totalFear: Double = 0
        for (shipId, count) in state.fleet {
            guard let def = shipClassRegistry[shipId] else { continue }
            totalWarOutput += def.warOutput * Double(count)
            totalFear += def.fear * Double(count)
        }
        state.warOutput = totalWarOutput
        // Fear from fleet is added in tickFear
    }

    // MARK: - Fear Tick

    static func tickFear(state: GameState, dt: Double) {
        // Fear decays slowly
        state.fear = max(0, state.fear - 0.5 * dt)

        // Fear drains legitimacy
        if state.fear > 0 {
            let fearDrain = state.fear * 0.005 * dt
            state.legitimacy = max(0, state.legitimacy - fearDrain)
        }
    }

    // MARK: - Nobel Tick

    static func tickNobel(state: GameState, dt: Double) {
        // Nobel score slowly decays (need active effort)
        state.nobelScore = max(0, state.nobelScore - 0.1 * dt)

        // Award Nobel Prize when threshold reached
        if state.nobelScore >= state.nobelThreshold {
            state.nobelPrizesWon += 1
            state.nobelScore = 0
            state.legitimacy = min(100, state.legitimacy + 15)
            state.greatness += 10000 * GameEngine.phaseMultiplier(for: state.phase)
            // Increase threshold by 50% for next prize
            state.nobelThreshold *= 1.5
        }
    }

    // MARK: - Space Tick (Phase 4+)

    static func tickSpace(state: GameState, dt: Double) {
        let space = state.space

        // Speed multiplier from budget + bridge upgrades
        let spaceBonus = 1.0 + state.budget.spaceProgram / 100.0
        let researchSpeed: Double = space.bridgeUpgrades["long_term_thinking"] == true ? 1.5 : 1.0

        // Rocket Mass from launch tier
        if let tierDef = launchTierRegistry[space.launchTier] {
            state.rocketMass += tierDef.rocketMassPerSecond * spaceBonus * researchSpeed * dt
        }

        // Orbital Industry from lunar buildings
        var oiPerSec: Double = 0
        if space.moonBase { oiPerSec += 1 }
        if space.helium3Mining { oiPerSec += 0.5 }
        if space.lunarShipyard { oiPerSec += 2 }
        state.orbitalIndustry += oiPerSec * spaceBonus * dt

        // Mining Output from He-3 + asteroids
        var miningPerSec: Double = 0
        if space.helium3Mining { miningPerSec += 2 }
        miningPerSec += Double(space.asteroidProspectors) * 1
        miningPerSec += Double(space.asteroidRigs) * 3
        miningPerSec += Double(space.asteroidRefineries) * 8
        state.miningOutput += miningPerSec * spaceBonus * dt

        // Colonists from Mars upgrades
        var colonistsPerSec: Double = 0
        if space.marsColony { colonistsPerSec += 0.5 }
        if space.waterExtraction { colonistsPerSec += 1 }
        state.colonists += colonistsPerSec * dt

        // Terraform Progress from Mars upgrades
        var terraformPerSec: Double = 0
        if space.atmosphereProcessing { terraformPerSec += 0.01 }
        if space.waterExtraction { terraformPerSec += 0.02 }
        state.terraformProgress = min(100, state.terraformProgress + terraformPerSec * spaceBonus * researchSpeed * dt)

        // Mars renaming at 25% terraform
        if state.terraformProgress >= 25 && !space.marsRenamed {
            state.space.marsRenamed = true
        }

        // Greatness from Mars upgrades
        var extraGPS: Double = 0
        if space.marsColony { extraGPS += 5 }
        if space.atmosphereProcessing { extraGPS += 10 }
        if space.waterExtraction { extraGPS += 15 }
        state.greatness += extraGPS * phaseMultiplier(for: state.phase) * dt

        // Legitimacy from lunar heritage + satellites
        var legitPerSec: Double = 0
        if space.lunarHeritage { legitPerSec += 0.02 }
        legitPerSec += Double(space.propagandaSatellites) * propagandaSatelliteLegitimacyPerUnit
        state.legitimacy = min(100, state.legitimacy + legitPerSec * dt)

        // Attention from satellites
        state.attention += Double(space.propagandaSatellites) * propagandaSatelliteAttentionPerUnit * dt

        // Reality Drift from satellites
        let driftRate = Double(space.propagandaSatellites) * propagandaSatelliteDriftPerUnit
        // Drift from weapons
        let weaponDrift = Double(space.spaceWeapons.values.filter { $0 }.count) * 0.002
        // Drift reduction from education budget
        let driftReduction = state.budget.education * 0.0001
        let netDrift = (driftRate + weaponDrift - driftReduction) * dt
        let driftCap = 100.0 * prestigeDriftCapMultiplier(upgrades: state.prestigeUpgrades)
        state.realityDrift = max(0, min(driftCap, state.realityDrift + netDrift))
    }

    // MARK: - Cosmic Tick (Phase 5+)

    static func tickCosmic(state: GameState, dt: Double) {
        let universe = state.universe

        // 1. Probe Production
        var baseProbeRate: Double = 0
        var totalReplicationRate: Double = 0
        var conversionEfficiency: Double = 1.0

        for def in probeUpgradeDefs {
            guard universe.probeUpgrades[def.id] == true else { continue }
            baseProbeRate += def.probeProductionPerSecond
            totalReplicationRate += def.replicationRate
            if def.conversionEfficiency > 0 {
                conversionEfficiency *= def.conversionEfficiency
            }
        }

        let replication = state.probesLaunched * totalReplicationRate
        let newProbes = (baseProbeRate + replication) * dt
        state.probesLaunched += newProbes

        // 2. Star Conversion
        var conversionRate: Double = 0
        for def in starBrandingDefs {
            guard universe.starBrandingUpgrades[def.id] == true else { continue }
            conversionRate += def.conversionRatePerSecond
        }

        if conversionRate > 0 {
            let available = min(state.probesLaunched * 0.1, Double(TOTAL_REACHABLE_STARS) - state.starsConverted)
            let actual = min(available, conversionRate * conversionEfficiency * dt)
            if actual > 0 {
                state.starsConverted += actual
                state.computronium += actual * COMPUTRONIUM_PER_STAR
                // Drift from conversion
                state.realityDrift += actual * STAR_DRIFT_PER_CONVERSION
            }
        }

        // 3. Greatness Units Production
        let baseGU = state.computronium * GU_PER_COMPUTRONIUM * 0.01

        var dysonGU: Double = 0
        for def in dysonSwarmDefs {
            guard universe.dysonUpgrades[def.id] == true else { continue }
            dysonGU += def.guPerSecond
        }

        var blackHoleGU: Double = 0
        for def in blackHoleDefs {
            guard universe.blackHoleUpgrades[def.id] == true else { continue }
            blackHoleGU += def.guStorage
        }

        var narrativeMultiplier: Double = 1.0
        var narrativeBonus: Double = 0
        for def in narrativeResearchDefs {
            guard universe.narrativeResearch[def.id] == true else { continue }
            if def.guMultiplier > 0 { narrativeMultiplier *= def.guMultiplier }
            narrativeBonus += def.productionBonus
        }

        let totalGURate = baseGU + dysonGU + blackHoleGU + narrativeBonus
        // Depreciation: value decreases as GU grows
        let depreciation: Double = state.greatnessUnits > 1000
            ? 1.0 / (1.0 + log10(state.greatnessUnits / 1000.0))
            : 1.0
        let guProduced = totalGURate * narrativeMultiplier * depreciation * dt

        // Post-ending decay: 0.5% per second
        if universe.endingComplete {
            state.greatnessUnits = max(0, state.greatnessUnits - state.greatnessUnits * 0.005 * dt)
        }

        state.greatnessUnits += guProduced

        // 4. Reality Drift from Phase 5 sources
        let driftFromStars = state.starsConverted * 0.0005
        let driftFromProbes = state.probesLaunched * 0.00002
        let guDrift = state.greatnessUnits > 0 ? min(0.01, log10(max(1, state.greatnessUnits)) * 0.001) : 0

        var driftReduction: Double = 0
        for def in narrativeResearchDefs {
            guard universe.narrativeResearch[def.id] == true else { continue }
            driftReduction += def.driftReduction
        }
        for def in blackHoleDefs {
            guard universe.blackHoleUpgrades[def.id] == true else { continue }
            driftReduction += def.driftReduction
        }

        let netDrift = (driftFromStars + driftFromProbes + guDrift - driftReduction) * dt
        let cosmicDriftCap = 100.0 * prestigeDriftCapMultiplier(upgrades: state.prestigeUpgrades)
        state.realityDrift = max(0, min(cosmicDriftCap, state.realityDrift + netDrift))

        // 5. Legitimacy from black hole upgrades
        var legitPerSec: Double = 0
        for def in blackHoleDefs {
            guard universe.blackHoleUpgrades[def.id] == true else { continue }
            legitPerSec += def.legitimacyPerSecond
        }

        // Narrative legitimacy floor
        var legitFloor: Double = 0
        for def in narrativeResearchDefs {
            guard universe.narrativeResearch[def.id] == true else { continue }
            if def.legitimacyFloor > legitFloor { legitFloor = def.legitimacyFloor }
        }

        if legitPerSec > 0 {
            state.legitimacy = min(100, state.legitimacy + legitPerSec * dt)
        }
        if legitFloor > 0 {
            state.legitimacy = max(legitFloor, state.legitimacy)
        }

        // 6. Universe Conversion percentage
        state.universe.universeConverted = (state.starsConverted / Double(TOTAL_REACHABLE_STARS)) * 100.0

        // 7. Ending trigger
        if state.universe.universeConverted >= 100 && !universe.endingTriggered {
            state.universe.endingTriggered = true
        }
    }

    // MARK: - GpS Calculation

    static func calculateGPS(state: GameState) -> Double {
        var baseGPS: Double = 0
        var gpsMultiplier: Double = 1.0

        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }

            // Base production
            baseGPS += data.production * Double(upgradeState.count)

            // GPS multiplier effects
            for effect in data.effects where effect.type == .gpsMultiplier {
                gpsMultiplier *= effect.value
            }
        }

        // Institution GpS (Phase 2+)
        for (id, inst) in state.institutions {
            guard inst.status == .captured || inst.status == .automated else { continue }
            guard let def = institutionRegistry[id] else { continue }
            baseGPS += def.greatnessOutput
        }

        // Country GpS (Phase 3+) — annexed countries contribute greatness
        for (id, country) in state.countries {
            guard country.status == .annexed else { continue }
            guard let def = countryRegistry[id] else { continue }
            baseGPS += def.greatnessPotential
        }

        let phaseMultiplier = Self.phaseMultiplier(for: state.phase)
        let legitimacyMultiplier = state.phase.rawValue >= 2 ? max(0.1, state.legitimacy / 100.0) : 1.0
        let prestigeGPS = prestigeGPSMultiplier(upgrades: state.prestigeUpgrades)
        let prestigeLevelBonus = 1.0 + 0.1 * Double(state.prestigeLevel)
        return baseGPS * gpsMultiplier * phaseMultiplier * legitimacyMultiplier * prestigeGPS * prestigeLevelBonus
    }

    // MARK: - Attention Per Second

    static func calculateAttentionPerSecond(state: GameState) -> Double {
        var total: Double = 0
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .attentionPerSecond {
                total += effect.value * Double(upgradeState.count)
            }
        }
        return total
    }

    // MARK: - Cash Per Second

    static func calculateCashPerSecond(state: GameState) -> Double {
        var total: Double = 0
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .cashPerSecond {
                total += effect.value * Double(upgradeState.count)
            }
        }
        return total
    }

    // MARK: - Upgrade Cost

    static func upgradeCost(data: UpgradeData, currentCount: Int, prestigeUpgrades: [String: Bool] = [:]) -> Double {
        let base = data.baseCost * pow(1.15, Double(currentCount))
        return base * prestigeResearchDiscount(upgrades: prestigeUpgrades)
    }

    // MARK: - Phase Multiplier

    static func phaseMultiplier(for phase: Phase) -> Double {
        switch phase {
        case .personalBrand: return 1
        case .institutionalCapture: return 10
        case .worldGreatening: return 100
        case .spaceGreatening: return 10_000
        case .cosmicGreatening: return 1_000_000
        }
    }

    // MARK: - Attention Per Click (base + upgrade bonuses)

    static func calculateAttentionPerClick(state: GameState) -> Double {
        var total: Double = 1.0 // base
        for (id, upgradeState) in state.upgrades {
            guard upgradeState.count > 0, let data = upgradeRegistry[id] else { continue }
            for effect in data.effects where effect.type == .attentionPerClick {
                total += effect.value * Double(upgradeState.count)
            }
        }
        // Prestige click power multiplier
        total *= prestigeClickPowerMultiplier(upgrades: state.prestigeUpgrades)
        return total
    }
}
