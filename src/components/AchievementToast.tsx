import { useState, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { type AchievementDef } from '../data/achievements'

// ── Toast Manager (mount once in App) ──

interface ToastItem {
  achievement: AchievementDef
  id: number
}

let toastCounter = 0

export function useAchievementToasts() {
  const [toasts, setToasts] = useState<ToastItem[]>([])

  const showToast = useCallback((achievement: AchievementDef) => {
    const id = ++toastCounter
    setToasts(prev => [...prev, { achievement, id }])

    // Auto-dismiss after 4 seconds
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id))
    }, 4000)
  }, [])

  const dismissToast = useCallback((id: number) => {
    setToasts(prev => prev.filter(t => t.id !== id))
  }, [])

  return { toasts, showToast, dismissToast }
}

interface AchievementToastManagerProps {
  toasts: ToastItem[]
  onDismiss: (id: number) => void
}

export function AchievementToastManager({ toasts, onDismiss }: AchievementToastManagerProps) {
  return (
    <div className="fixed top-4 left-1/2 -translate-x-1/2 z-[90] flex flex-col gap-2 pointer-events-none max-w-sm w-full px-4">
      <AnimatePresence>
        {toasts.map(({ achievement, id }) => (
          <motion.div
            key={id}
            initial={{ opacity: 0, y: -40, scale: 0.9 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -20, scale: 0.95 }}
            transition={{ type: 'spring', stiffness: 400, damping: 25 }}
            className="pointer-events-auto"
            onClick={() => onDismiss(id)}
          >
            <div
              className="glass-card p-3 flex items-center gap-3 cursor-pointer"
              style={{
                borderColor: 'rgba(255, 215, 0, 0.3)',
                boxShadow: '0 0 20px rgba(255, 215, 0, 0.15), 0 4px 24px rgba(0, 0, 0, 0.4)',
              }}
            >
              <span className="text-2xl flex-shrink-0">{achievement.icon}</span>
              <div className="flex-1 min-w-0">
                <p className="text-[0.6rem] uppercase tracking-wider text-nobel-gold font-medium">
                  Achievement Unlocked
                </p>
                <p className="text-sm font-medium text-text-primary truncate">
                  {achievement.name}
                </p>
                <p className="text-[0.65rem] text-text-muted truncate">
                  {achievement.description}
                </p>
              </div>
            </div>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  )
}
