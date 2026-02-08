import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'

const TICK_INTERVAL = 100 // ms

export function useGameLoop() {
  const intervalRef = useRef<number | null>(null)

  useEffect(() => {
    intervalRef.current = window.setInterval(() => {
      useGameStore.getState().tick(Date.now())
    }, TICK_INTERVAL)

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current)
      }
    }
  }, [])
}
