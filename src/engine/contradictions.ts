import type { GameState, ContradictionState } from '../store/types'

const BALANCE_THRESHOLD = 40
const TOKEN_INTERVAL = 10 // seconds of balanced time to earn a token

interface ContradictionUpdate {
  contradictions: Record<string, ContradictionState>
  doublethinkTokens: number
}

export function updateContradictions(
  state: GameState,
  dt: number,
  prevAttention: number
): ContradictionUpdate {
  const updates = { ...state.contradictions }
  let tokens = state.doublethinkTokens

  // Phase 1: Attention vs Credibility
  const ac = updates.attention_credibility
  if (ac?.active) {
    const attentionDelta = state.attention - prevAttention

    // Attention side: rises with activity, decays over time
    const attentionPressure = Math.min(attentionDelta * 0.5, 10) // cap per tick
    const attentionDecay = 2 * dt // natural decay rate
    const newA = clamp(ac.sideA + attentionPressure - attentionDecay, 0, 100)

    // Credibility side: inversely pressured by attention, naturally recovers
    const credibilityPressure = attentionPressure > 0 ? -attentionPressure * 0.7 : 0
    const credibilityRecovery = 1.5 * dt
    const newB = clamp(ac.sideB + credibilityPressure + credibilityRecovery, 0, 100)

    // Balance tracking
    const isBalanced = newA >= BALANCE_THRESHOLD && newB >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? ac.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(ac.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.attention_credibility = {
      ...ac,
      sideA: newA,
      sideB: newB,
      balancedTime: newBalancedTime,
    }
  }

  // Phase 2: Control vs Legitimacy
  const cl = updates.control_legitimacy
  if (cl?.active && state.phase >= 2) {
    // Control side: rises with captured institutions
    const capturedCount = Object.values(state.institutions).filter(
      i => i.status === 'captured' || i.status === 'automated'
    ).length
    const controlLevel = clamp((capturedCount / 13) * 100, 0, 100)

    // Legitimacy side: mirrors actual legitimacy
    const legitimacyLevel = clamp(state.legitimacy, 0, 100)

    // Balance tracking
    const isBalanced = controlLevel >= BALANCE_THRESHOLD && legitimacyLevel >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? cl.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(cl.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.control_legitimacy = {
      ...cl,
      sideA: controlLevel,
      sideB: legitimacyLevel,
      balancedTime: newBalancedTime,
    }
  }

  // Phase 3: War vs Nobel
  const wn = updates.war_nobel
  if (wn?.active && state.phase >= 3) {
    // War side: rises with fear and active military operations
    const activeWars = Object.values(state.countries).filter(
      c => c.status === 'occupied' || c.status === 'coup_target'
    ).length
    const warLevel = clamp(state.fear + activeWars * 10, 0, 100)

    // Nobel side: rises with Nobel Score, decays with war
    const nobelLevel = clamp(state.nobelScore, 0, 100)

    // Balance tracking
    const isBalanced = warLevel >= BALANCE_THRESHOLD && nobelLevel >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? wn.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(wn.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.war_nobel = {
      ...wn,
      sideA: warLevel,
      sideB: nobelLevel,
      balancedTime: newBalancedTime,
    }
  }

  // Phase 3: Expansion vs Stability
  const es = updates.expansion_stability
  if (es?.active && state.phase >= 3) {
    // Expansion side: rises with annexed countries
    const annexedCount = Object.values(state.countries).filter(
      c => c.status === 'annexed' || c.status === 'allied'
    ).length
    const expansionLevel = clamp((annexedCount / 15) * 100, 0, 100)

    // Stability side: average stability of all non-annexed countries
    const independentCountries = Object.values(state.countries).filter(
      c => c.status !== 'annexed' && c.status !== 'allied'
    )
    const avgStability = independentCountries.length > 0
      ? independentCountries.reduce((sum, c) => sum + c.stability, 0) / independentCountries.length
      : 100
    const stabilityLevel = clamp(avgStability, 0, 100)

    // Balance tracking
    const isBalanced = expansionLevel >= BALANCE_THRESHOLD && stabilityLevel >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? es.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(es.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.expansion_stability = {
      ...es,
      sideA: expansionLevel,
      sideB: stabilityLevel,
      balancedTime: newBalancedTime,
    }
  }

  // Phase 4: Long-Term vs Short-Term
  const ls = updates.longterm_shortterm
  if (ls?.active && state.phase >= 4) {
    // Long-term side: driven by terraform progress + orbital industry
    const longTermLevel = clamp(
      state.terraformProgress + state.orbitalIndustry * 0.5,
      0, 100
    )

    // Short-term side: driven by attention + fear + war output
    const shortTermLevel = clamp(
      Math.min(100, state.attention / 1000 + state.fear * 0.5 + state.warOutput / 100),
      0, 100
    )

    // Balance tracking
    const isBalanced = longTermLevel >= BALANCE_THRESHOLD && shortTermLevel >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? ls.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(ls.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.longterm_shortterm = {
      ...ls,
      sideA: longTermLevel,
      sideB: shortTermLevel,
      balancedTime: newBalancedTime,
    }
  }

  // Phase 5: Greatness vs Meaning
  const gm = updates.greatness_meaning
  if (gm?.active && state.phase >= 5) {
    // Greatness side: driven by GU production rate and stars converted
    const greatnessLevel = clamp(
      Math.min(100, state.greatnessUnits * 0.001 + state.starsConverted * 0.1),
      0, 100
    )

    // Meaning side: inversely proportional to reality drift
    // When drift is high, meaning collapses
    const meaningLevel = clamp(100 - state.realityDrift, 0, 100)

    // Balance tracking
    const isBalanced = greatnessLevel >= BALANCE_THRESHOLD && meaningLevel >= BALANCE_THRESHOLD
    const newBalancedTime = isBalanced ? gm.balancedTime + dt : 0

    // Award Doublethink Tokens
    const prevTokenThreshold = Math.floor(gm.balancedTime / TOKEN_INTERVAL)
    const newTokenThreshold = Math.floor(newBalancedTime / TOKEN_INTERVAL)
    if (newTokenThreshold > prevTokenThreshold) {
      tokens += newTokenThreshold - prevTokenThreshold
    }

    updates.greatness_meaning = {
      ...gm,
      sideA: greatnessLevel,
      sideB: meaningLevel,
      balancedTime: newBalancedTime,
    }
  }

  return { contradictions: updates, doublethinkTokens: tokens }
}

export function getCredibilityEffect(state: GameState): number {
  const ac = state.contradictions.attention_credibility
  if (!ac) return 1.0

  // Below 30 credibility, cash generation is penalized
  if (ac.sideB < 30) return 0.3
  if (ac.sideB < 50) return 0.7
  return 1.0
}

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value))
}
