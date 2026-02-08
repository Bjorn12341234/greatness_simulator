import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'

const AUTO_SAVE_INTERVAL = 30_000 // 30 seconds

export function useAutoSave() {
  const save = useGameStore(state => state.save)
  const intervalRef = useRef<number | null>(null)

  useEffect(() => {
    // Auto-save on interval
    intervalRef.current = window.setInterval(() => {
      save()
    }, AUTO_SAVE_INTERVAL)

    // Save when tab becomes hidden
    const handleVisibility = () => {
      if (document.hidden) {
        save()
      }
    }
    document.addEventListener('visibilitychange', handleVisibility)

    // Save on beforeunload
    const handleUnload = () => {
      save()
    }
    window.addEventListener('beforeunload', handleUnload)

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current)
      }
      document.removeEventListener('visibilitychange', handleVisibility)
      window.removeEventListener('beforeunload', handleUnload)
    }
  }, [save])
}
