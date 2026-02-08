import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'
import { tick } from '../engine/gameLoop'

const TICK_INTERVAL = 100 // ms

export function useGameLoop() {
  const intervalRef = useRef<number | null>(null)

  useEffect(() => {
    intervalRef.current = window.setInterval(() => {
      const state = useGameStore.getState()
      const now = Date.now()
      const updates = tick(state, now)
      useGameStore.setState(updates)
    }, TICK_INTERVAL)

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current)
      }
    }
  }, [])
}
