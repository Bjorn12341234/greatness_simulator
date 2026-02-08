import type { GameState, Phase } from '../store/types'

// ── Phase Transition Conditions ──
// Returns the next phase if transition condition is met, or null

export function checkPhaseTransition(state: GameState): Phase | null {
  switch (state.phase) {
    case 1:
      // Neural Backup purchased → Phase 2
      if (state.upgrades['sci_neural_backup']?.purchased) return 2
      break
    case 2:
      // All 13 institutions captured
      {
        const institutions = Object.values(state.institutions)
        if (institutions.length >= 13 && institutions.every(i => i.status === 'captured' || i.status === 'automated')) return 3
      }
      break
    case 3:
      // All 14 countries annexed or allied
      {
        const countries = Object.values(state.countries)
        if (countries.length >= 14 && countries.every(c => c.status === 'annexed' || c.status === 'allied')) return 4
      }
      break
    case 4:
      // Solar System = Greatness Industrial Zone
      if (state.space.dysonSwarms > 0 && state.space.asteroidRigs >= 5 && state.orbitalIndustry >= 100) return 5
      break
    // Phase 5 has no automatic transition — it's the endgame loop
    // The ending is triggered when universe conversion reaches 100%
    // (handled in tickCosmic)
  }
  return null
}

// ── Transition Text Sequences ──

export interface TransitionLine {
  text: string
  delay: number  // ms before showing this line
  style?: 'normal' | 'bold' | 'accent' | 'dim'
}

export const TRANSITION_SCRIPTS: Partial<Record<`${Phase}_${Phase}`, TransitionLine[]>> = {
  '1_2': [
    { text: 'NEURAL BACKUP COMPLETE', delay: 0, style: 'bold' },
    { text: 'Consciousness digitized.', delay: 2000 },
    { text: 'The brand is now immortal.', delay: 4000 },
    { text: 'But immortality requires...', delay: 6500, style: 'dim' },
    { text: 'INSTITUTIONAL INFRASTRUCTURE', delay: 9000, style: 'accent' },
    { text: 'Time to capture the system.', delay: 11500 },
    { text: 'Phase 2: Institutional Capture', delay: 14000, style: 'bold' },
  ],
  '2_3': [
    { text: 'ALL INSTITUTIONS CAPTURED', delay: 0, style: 'bold' },
    { text: 'The domestic apparatus is secured.', delay: 2000 },
    { text: 'But true greatness knows no borders.', delay: 4000 },
    { text: 'The world awaits optimization.', delay: 6500, style: 'dim' },
    { text: 'GLOBAL GREATENING PROTOCOL', delay: 9000, style: 'accent' },
    { text: 'Phase 3: World Greatening', delay: 12000, style: 'bold' },
  ],
  '3_4': [
    { text: 'ALL NATIONS UNDER ACCORD', delay: 0, style: 'bold' },
    { text: 'Earth has been optimized.', delay: 2000 },
    { text: 'But there is so much more... out there.', delay: 4000 },
    { text: 'The stars are merely unbranded resources.', delay: 6500, style: 'dim' },
    { text: 'SPACE GREATENING INITIATIVE', delay: 9000, style: 'accent' },
    { text: 'Phase 4: Space Greatening', delay: 12000, style: 'bold' },
  ],
  '4_5': [
    { text: 'SOLAR SYSTEM INDUSTRIALIZED', delay: 0, style: 'bold' },
    { text: 'One star is not enough.', delay: 2000 },
    { text: 'The universe itself must be converted.', delay: 4000 },
    { text: 'Reality is merely unprocessed Greatness.', delay: 6500, style: 'dim' },
    { text: 'GOD EMPEROR PROTOCOL', delay: 9000, style: 'accent' },
    { text: 'Phase 5: Cosmic Greatening', delay: 12000, style: 'bold' },
  ],
}

export function getTransitionScript(from: Phase, to: Phase): TransitionLine[] {
  return TRANSITION_SCRIPTS[`${from}_${to}`] ?? [
    { text: `Transitioning to Phase ${to}...`, delay: 0, style: 'bold' },
  ]
}
