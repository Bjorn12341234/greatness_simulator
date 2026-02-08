import type { GameState } from '../store/types'
import { PROPAGANDA_SATELLITE } from '../data/phase4/space'
import { PRESTIGE_UPGRADES } from '../data/prestige'

// ── Reality Drift System ──
// Drift accumulates in Phase 4+ from propaganda satellites, space weapons, and events.
// At higher levels it causes UI glitches, label swaps, and value offsets.

export interface DriftLevel {
  name: string
  threshold: number
  effects: string[]
}

export const DRIFT_LEVELS: DriftLevel[] = [
  { name: 'Stable', threshold: 0, effects: [] },
  { name: 'Minor Distortion', threshold: 20, effects: ['css_flicker'] },
  { name: 'Narrative Drift', threshold: 40, effects: ['css_flicker', 'label_swaps'] },
  { name: 'Reality Erosion', threshold: 60, effects: ['css_flicker', 'label_swaps', 'value_offsets'] },
  { name: 'Total Dissociation', threshold: 80, effects: ['css_flicker', 'label_swaps', 'value_offsets', 'unreliable_ui'] },
]

export function getDriftLevel(drift: number): DriftLevel {
  for (let i = DRIFT_LEVELS.length - 1; i >= 0; i--) {
    if (drift >= DRIFT_LEVELS[i].threshold) return DRIFT_LEVELS[i]
  }
  return DRIFT_LEVELS[0]
}

export function calculateDriftRate(state: GameState): number {
  if (state.phase < 4) return 0

  let rate = 0

  // Base drift from propaganda satellites
  rate += state.space.propagandaSatellites * PROPAGANDA_SATELLITE.driftPerUnit

  // Drift from space weapons
  const weaponCount = Object.values(state.space.spaceWeapons).filter(Boolean).length
  rate += weaponCount * 0.002

  // Drift from high fear
  if (state.fear > 50) rate += 0.001

  // Phase 5: cosmic sources of drift
  if (state.phase >= 5) {
    // Star conversions are a major drift source
    rate += state.starsConverted * 0.0005
    // Probes spread the narrative, accelerating drift
    rate += state.probesLaunched * 0.00002
    // GU production itself warps reality
    rate += Math.min(state.greatnessUnits * 0.000001, 0.01)
  }

  return rate
}

export function calculateDriftReduction(state: GameState): number {
  let reduction = 0

  // Education budget reduces drift
  reduction += state.budget.education * 0.0001

  // Science rebranding removes science legitimacy drain (not drift directly)
  // Patience campaign removes slow progress drain (not drift directly)

  return reduction
}

// Maximum drift (reduced by prestige upgrades)
export function getDriftCap(state: GameState): number {
  let cap = 100
  for (const upgrade of PRESTIGE_UPGRADES) {
    if (state.prestigeUpgrades[upgrade.id] && upgrade.effect.type === 'drift_cap') {
      cap -= upgrade.effect.value
    }
  }
  return Math.max(50, cap) // never below 50
}

// Perturb displayed values at high drift
export function applyDriftOffset(value: number, drift: number): number {
  if (drift < 60) return value
  const intensity = (drift - 60) / 40 // 0-1 range from 60-100%
  const maxOffset = value * 0.15 * intensity
  // Deterministic-ish jitter based on value
  const jitter = Math.sin(value * 13.37 + drift * 7.77) * maxOffset
  return value + jitter
}

// Label swap pairs for narrative drift
export const LABEL_SWAPS: [string, string][] = [
  ['Legitimacy', 'Compliance'],
  ['Freedom', 'Oversight'],
  ['Healthcare', 'Wellness Liability'],
  ['Education', 'Loyalty Training'],
  ['Democracy', 'Guided Consensus'],
  ['Protest', 'Unauthorized Gathering'],
  ['Journalist', 'Content Disruptor'],
  ['Rights', 'Provisional Privileges'],
  ['Opposition', 'Pre-Aligned Citizens'],
  ['Truth', 'Narrative Alignment'],
  // Phase 5 cosmic drift labels
  ['Stars', 'Branded Assets'],
  ['Universe', 'Franchise Territory'],
  ['Reality', 'Approved Simulation'],
  ['Meaning', 'Deprecated Concept'],
  ['Existence', 'License Agreement'],
]

export function maybeSwapLabel(label: string, drift: number): string {
  if (drift < 40) return label
  const swapChance = (drift - 40) / 60 // 0-1 range from 40-100%

  for (const [original, replacement] of LABEL_SWAPS) {
    if (label === original && Math.random() < swapChance * 0.3) {
      return replacement
    }
    if (label === replacement && Math.random() < swapChance * 0.3) {
      return original
    }
  }
  return label
}
