import { useGameStore, type GameStore } from './gameStore'

// ── Derived Values ──
// These compute values from game state. Use as: const gps = useGPS()

// Phase multipliers: 1, 10, 100, 10_000, 1_000_000
const PHASE_MULTIPLIERS = [0, 1, 10, 100, 10_000, 1_000_000] as const

function computeGPS(state: GameStore): number {
  const baseProduction = state.greatnessPerSecond
  const legitimacyMult = getLegitimacyMultiplier(state.legitimacy)
  const phaseMult = PHASE_MULTIPLIERS[state.phase] ?? 1
  const prestigeBonus = 1 + 0.1 * state.prestigeLevel

  return baseProduction * legitimacyMult * phaseMult * prestigeBonus
}

function getLegitimacyMultiplier(legitimacy: number): number {
  if (legitimacy > 80) return 1.2
  if (legitimacy >= 50) return 1.0
  if (legitimacy >= 25) return 0.7
  return 0.4
}

// ── Selector hooks ──

export function useGPS(): number {
  return useGameStore(state => computeGPS(state))
}

export function usePhase() {
  return useGameStore(state => state.phase)
}

export function useGreatness() {
  return useGameStore(state => state.greatness)
}

export function useCash() {
  return useGameStore(state => state.cash)
}

export function useAttention() {
  return useGameStore(state => state.attention)
}

export function useLegitimacy() {
  return useGameStore(state => state.legitimacy)
}

export function useLegitimacyMultiplier() {
  return useGameStore(state => getLegitimacyMultiplier(state.legitimacy))
}

export function useNobelScore() {
  return useGameStore(state => state.nobelScore)
}

export function useSettings() {
  return useGameStore(state => state.settings)
}

export function useActiveEvent() {
  return useGameStore(state => state.activeEvent)
}

export function useUpgrade(id: string) {
  return useGameStore(state => state.upgrades[id])
}

// Count of captured institutions
export function useCapturedInstitutions() {
  return useGameStore(state =>
    Object.values(state.institutions).filter(i => i.status === 'captured' || i.status === 'automated').length
  )
}

// Count of annexed countries
export function useAnnexedCountries() {
  return useGameStore(state =>
    Object.values(state.countries).filter(c => c.status === 'annexed' || c.status === 'allied').length
  )
}

// Phase 4: Space selectors
export function useSpaceState() {
  return useGameStore(state => state.space)
}

export function useRocketMass() {
  return useGameStore(state => state.rocketMass)
}

export function useTerraformProgress() {
  return useGameStore(state => state.terraformProgress)
}

export function useRealityDriftLevel() {
  return useGameStore(state => state.realityDrift)
}
