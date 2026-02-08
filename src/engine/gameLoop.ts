import type { GameState } from '../store/types'
import { calculateGPS, calculateLegitimacyDecay } from './formulas'

// ── Core Tick Function ──
// Called every ~100ms. Returns a partial state update.

export interface TickResult {
  greatness: number
  greatnessPerSecond: number
  attention: number
  cash: number
  legitimacy: number
  totalPlayTime: number
  lastTickAt: number
}

export function tick(state: GameState, now: number): Partial<GameState> {
  const dt = (now - state.lastTickAt) / 1000 // delta in seconds
  if (dt <= 0 || dt > 60) {
    // Skip invalid or huge deltas (offline handled separately)
    return { lastTickAt: now }
  }

  const gps = calculateGPS(state)

  // Resource generation
  const newGreatness = state.greatness + gps * dt
  const newAttention = state.attention // attention only grows from clicks in Phase 1
  const newCash = state.cash // cash generation added in Phase 2

  // Legitimacy decay (Phase 2+)
  let newLegitimacy = state.legitimacy
  if (state.phase >= 2) {
    const decay = calculateLegitimacyDecay(state)
    newLegitimacy = Math.max(0, Math.min(100, state.legitimacy - decay * dt))
  }

  return {
    greatness: newGreatness,
    greatnessPerSecond: gps,
    attention: newAttention,
    cash: newCash,
    legitimacy: newLegitimacy,
    totalPlayTime: state.totalPlayTime + dt,
    lastTickAt: now,
  }
}
