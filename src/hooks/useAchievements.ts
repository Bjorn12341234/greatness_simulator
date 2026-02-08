import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'
import { ACHIEVEMENTS, type AchievementDef } from '../data/achievements'
import { playAchievement } from '../engine/audio'

// Check achievements every 10 ticks (~1 second)
// Calls onUnlock for each newly unlocked achievement

export function useAchievements(onUnlock: (achievement: AchievementDef) => void) {
  const tickRef = useRef(0)
  const onUnlockRef = useRef(onUnlock)
  onUnlockRef.current = onUnlock

  useEffect(() => {
    const unsubscribe = useGameStore.subscribe((state) => {
      tickRef.current++
      if (tickRef.current % 10 !== 0) return // Every 10 ticks

      const phase = state.phase
      const currentAchievements = state.achievements

      const toUnlock: AchievementDef[] = []

      for (const achievement of ACHIEVEMENTS) {
        if (achievement.phase > phase) continue
        if (currentAchievements[achievement.id]) continue

        if (achievement.check(state)) {
          toUnlock.push(achievement)
        }
      }

      if (toUnlock.length > 0) {
        // Update store
        const newAchievements = { ...currentAchievements }
        for (const a of toUnlock) {
          newAchievements[a.id] = true
        }
        useGameStore.setState({ achievements: newAchievements })

        // Notify via callback and play sound
        playAchievement()
        for (const a of toUnlock) {
          onUnlockRef.current(a)
        }
      }
    })

    return unsubscribe
  }, [])
}
