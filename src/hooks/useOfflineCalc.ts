import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'
import { calculateOfflineProgress, applyOfflineProgress } from '../engine/offline'

export interface OfflineReport {
  elapsedSeconds: number
  greatnessGained: number
}

export function useOfflineCalc(onReport?: (report: OfflineReport) => void) {
  const hasRun = useRef(false)

  useEffect(() => {
    if (hasRun.current) return
    hasRun.current = true

    const state = useGameStore.getState()
    const result = calculateOfflineProgress(state)

    if (result.elapsedSeconds >= 60) {
      const updates = applyOfflineProgress(state)
      useGameStore.setState(updates)

      onReport?.({
        elapsedSeconds: result.elapsedSeconds,
        greatnessGained: result.greatnessGained,
      })
    }
  }, [onReport])
}
