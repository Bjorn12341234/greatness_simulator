import type { GameState } from '../store/types'
import { calculateGPS, calculateOfflineRate } from './formulas'

export interface OfflineResult {
  elapsedSeconds: number
  greatnessGained: number
  offlineRate: number
}

export function calculateOfflineProgress(state: GameState): OfflineResult {
  const now = Date.now()
  const elapsed = (now - state.lastTickAt) / 1000 // seconds since last tick

  // Only calculate if away for more than 60 seconds
  if (elapsed < 60) {
    return { elapsedSeconds: 0, greatnessGained: 0, offlineRate: 0 }
  }

  const gps = calculateGPS(state)
  const offlineRate = calculateOfflineRate(state)
  const greatnessGained = gps * elapsed * offlineRate

  return {
    elapsedSeconds: elapsed,
    greatnessGained,
    offlineRate,
  }
}

export function applyOfflineProgress(state: GameState): Partial<GameState> {
  const result = calculateOfflineProgress(state)

  if (result.elapsedSeconds < 60) {
    return { lastTickAt: Date.now() }
  }

  return {
    greatness: state.greatness + result.greatnessGained,
    lastTickAt: Date.now(),
  }
}
