import type { GameState, GameEvent, EventCondition } from '../store/types'
import { getNextEventDelay } from './formulas'

// Category weights for random selection
const CATEGORY_WEIGHTS: Record<string, number> = {
  opportunity: 3,
  scandal: 2,
  absurd: 2,
  contradiction: 1.5,
  crisis: 1,
  nobel: 0.5,
  reality_glitch: 0.5,
}

export function checkEventTrigger(state: GameState, now: number): boolean {
  if (state.activeEvent) return false
  return now >= state.nextEventAt
}

export function selectEvent(
  state: GameState,
  eventPool: GameEvent[]
): GameEvent | null {
  const eligible = eventPool.filter(e => isEligible(e, state))
  if (eligible.length === 0) return null

  // Weighted random selection
  const weights = eligible.map(e => CATEGORY_WEIGHTS[e.category] ?? 1)
  const totalWeight = weights.reduce((a, b) => a + b, 0)
  let roll = Math.random() * totalWeight

  for (let i = 0; i < eligible.length; i++) {
    roll -= weights[i]
    if (roll <= 0) return eligible[i]
  }

  return eligible[eligible.length - 1]
}

function isEligible(event: GameEvent, state: GameState): boolean {
  // Phase check
  if (event.phase > state.phase) return false

  // Unique events can only fire once
  if (event.unique && state.eventHistory.includes(event.id)) return false

  // Check conditions
  if (event.conditions) {
    for (const condition of event.conditions) {
      if (!checkCondition(condition, state)) return false
    }
  }

  return true
}

function checkCondition(condition: EventCondition, state: GameState): boolean {
  const value = state[condition.resource as keyof GameState]
  if (typeof value !== 'number') return false

  switch (condition.operator) {
    case '>': return value > condition.value
    case '<': return value < condition.value
    case '>=': return value >= condition.value
    case '<=': return value <= condition.value
    case '==': return value === condition.value
  }
}

export function scheduleNextEvent(phase: number, now: number, state?: GameState): number {
  return now + getNextEventDelay(phase, state)
}
