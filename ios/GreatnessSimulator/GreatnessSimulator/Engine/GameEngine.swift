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

        // Event scheduling — seed first event if needed
        if state.nextEventAt == 0 {
            state.nextEventAt = EventEngine.scheduleNext(phase: state.phase.rawValue, now: now)
        }

        // Event trigger
        if EventEngine.shouldTrigger(state: state, now: now) {
            if let event = EventEngine.selectEvent(state: state, pool: allEvents(for: state.phase)) {
                state.activeEvent = event
            } else {
                // No eligible events — reschedule
                state.nextEventAt = EventEngine.scheduleNext(phase: state.phase.rawValue, now: now)
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
        default: return phase1Events
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

        // Recovery from budget
        let healthRecovery = budget.healthcare * 0.003
        let socialRecovery = budget.socialBenefits * 0.002
        let propRecovery = budget.propagandaBureau * 0.004
        let recovery = (healthRecovery + socialRecovery + propRecovery) / 100.0 // normalize from percentage

        let netChange = (recovery - decay) * dt
        state.legitimacy = max(0, min(100, state.legitimacy + netChange))
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

        let phaseMultiplier = Self.phaseMultiplier(for: state.phase)
        let legitimacyMultiplier = state.phase.rawValue >= 2 ? max(0.1, state.legitimacy / 100.0) : 1.0
        return baseGPS * gpsMultiplier * phaseMultiplier * legitimacyMultiplier
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

    static func upgradeCost(data: UpgradeData, currentCount: Int) -> Double {
        data.baseCost * pow(1.15, Double(currentCount))
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
        return total
    }
}
