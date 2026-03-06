import Foundation

struct ContradictionEngine {

    static let balanceThreshold: Double = 40
    static let tokenInterval: Double = 10 // seconds of balanced time per token

    /// Update all active contradictions. Called every tick.
    static func update(state: GameState, dt: Double, prevAttention: Double) {

        // Phase 1: Attention vs Credibility
        if var ac = state.contradictions["attention_credibility"], ac.active {
            let attentionDelta = state.attention - prevAttention

            let attentionPressure = min(attentionDelta * 0.5, 10)
            let attentionDecay = 2 * dt
            let newA = clamp(ac.sideA + attentionPressure - attentionDecay, 0, 100)

            let credibilityPressure = attentionPressure > 0 ? -attentionPressure * 0.7 : 0
            let credibilityRecovery = 1.5 * dt
            let newB = clamp(ac.sideB + credibilityPressure + credibilityRecovery, 0, 100)

            let isBalanced = newA >= balanceThreshold && newB >= balanceThreshold
            let newBalancedTime = isBalanced ? ac.balancedTime + dt : 0

            awardTokens(state: state, oldTime: ac.balancedTime, newTime: newBalancedTime)

            ac.sideA = newA
            ac.sideB = newB
            ac.balancedTime = newBalancedTime
            state.contradictions["attention_credibility"] = ac
        }

        // Phase 2: Control vs Legitimacy
        if var cl = state.contradictions["control_legitimacy"], cl.active, state.phase.rawValue >= 2 {
            let capturedCount = state.institutions.values.filter { $0.status == .captured || $0.status == .automated }.count
            let controlLevel = clamp(Double(capturedCount) / 13.0 * 100.0, 0, 100)
            let legitimacyLevel = clamp(state.legitimacy, 0, 100)

            let isBalanced = controlLevel >= balanceThreshold && legitimacyLevel >= balanceThreshold
            let newBalancedTime = isBalanced ? cl.balancedTime + dt : 0

            awardTokens(state: state, oldTime: cl.balancedTime, newTime: newBalancedTime)

            cl.sideA = controlLevel
            cl.sideB = legitimacyLevel
            cl.balancedTime = newBalancedTime
            state.contradictions["control_legitimacy"] = cl
        }

        // Phase 3: War vs Nobel
        if var wn = state.contradictions["war_nobel"], wn.active, state.phase.rawValue >= 3 {
            let activeWars = state.countries.values.filter { $0.status == .occupied || $0.status == .coupTarget }.count
            let warLevel = clamp(state.fear + Double(activeWars) * 10, 0, 100)
            let nobelLevel = clamp(state.nobelScore, 0, 100)

            let isBalanced = warLevel >= balanceThreshold && nobelLevel >= balanceThreshold
            let newBalancedTime = isBalanced ? wn.balancedTime + dt : 0

            awardTokens(state: state, oldTime: wn.balancedTime, newTime: newBalancedTime)

            wn.sideA = warLevel
            wn.sideB = nobelLevel
            wn.balancedTime = newBalancedTime
            state.contradictions["war_nobel"] = wn
        }

        // Phase 3: Expansion vs Stability
        if var es = state.contradictions["expansion_stability"], es.active, state.phase.rawValue >= 3 {
            let annexedCount = state.countries.values.filter { $0.status == .annexed || $0.status == .allied }.count
            let expansionLevel = clamp(Double(annexedCount) / 15.0 * 100.0, 0, 100)

            let independents = state.countries.values.filter { $0.status != .annexed && $0.status != .allied }
            let avgStability = independents.isEmpty ? 100.0 : independents.reduce(0.0) { $0 + $1.stability } / Double(independents.count)
            let stabilityLevel = clamp(avgStability, 0, 100)

            let isBalanced = expansionLevel >= balanceThreshold && stabilityLevel >= balanceThreshold
            let newBalancedTime = isBalanced ? es.balancedTime + dt : 0

            awardTokens(state: state, oldTime: es.balancedTime, newTime: newBalancedTime)

            es.sideA = expansionLevel
            es.sideB = stabilityLevel
            es.balancedTime = newBalancedTime
            state.contradictions["expansion_stability"] = es
        }

        // Phase 4: Long-Term vs Short-Term
        if var ls = state.contradictions["longterm_shortterm"], ls.active, state.phase.rawValue >= 4 {
            let longTermLevel = clamp(state.terraformProgress + state.orbitalIndustry * 0.5, 0, 100)
            let shortTermLevel = clamp(min(100, state.attention / 1000 + state.fear * 0.5 + state.warOutput / 100), 0, 100)

            let isBalanced = longTermLevel >= balanceThreshold && shortTermLevel >= balanceThreshold
            let newBalancedTime = isBalanced ? ls.balancedTime + dt : 0

            awardTokens(state: state, oldTime: ls.balancedTime, newTime: newBalancedTime)

            ls.sideA = longTermLevel
            ls.sideB = shortTermLevel
            ls.balancedTime = newBalancedTime
            state.contradictions["longterm_shortterm"] = ls
        }

        // Phase 5: Greatness vs Meaning
        if var gm = state.contradictions["greatness_meaning"], gm.active, state.phase.rawValue >= 5 {
            let greatnessLevel = clamp(min(100, state.greatnessUnits * 0.001 + state.starsConverted * 0.1), 0, 100)
            let meaningLevel = clamp(100 - state.realityDrift, 0, 100)

            let isBalanced = greatnessLevel >= balanceThreshold && meaningLevel >= balanceThreshold
            let newBalancedTime = isBalanced ? gm.balancedTime + dt : 0

            awardTokens(state: state, oldTime: gm.balancedTime, newTime: newBalancedTime)

            gm.sideA = greatnessLevel
            gm.sideB = meaningLevel
            gm.balancedTime = newBalancedTime
            state.contradictions["greatness_meaning"] = gm
        }
    }

    /// Award doublethink tokens based on balance time crossing token thresholds.
    private static func awardTokens(state: GameState, oldTime: Double, newTime: Double) {
        let prevThreshold = Int(oldTime / tokenInterval)
        let newThreshold = Int(newTime / tokenInterval)
        if newThreshold > prevThreshold {
            state.doublethinkTokens += Double(newThreshold - prevThreshold)
        }
    }

    /// Get the credibility multiplier for cash generation (from Phase 1 contradiction).
    static func credibilityEffect(state: GameState) -> Double {
        guard let ac = state.contradictions["attention_credibility"] else { return 1.0 }
        if ac.sideB < 30 { return 0.3 }
        if ac.sideB < 50 { return 0.7 }
        return 1.0
    }

    private static func clamp(_ value: Double, _ lo: Double, _ hi: Double) -> Double {
        max(lo, min(hi, value))
    }
}
