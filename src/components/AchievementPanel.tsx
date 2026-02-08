import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { ACHIEVEMENTS } from '../data/achievements'
import { GlassCard } from './ui/GlassCard'

interface AchievementPanelProps {
  onClose: () => void
}

export function AchievementPanel({ onClose }: AchievementPanelProps) {
  const achievements = useGameStore(s => s.achievements)
  const phase = useGameStore(s => s.phase)

  const visible = ACHIEVEMENTS.filter(a => a.phase <= phase)
  const unlocked = visible.filter(a => achievements[a.id])

  return (
    <motion.div
      className="fixed inset-0 z-[80] flex items-center justify-center p-4"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Panel */}
      <motion.div
        className="relative w-full max-w-md max-h-[80vh] overflow-y-auto"
        initial={{ scale: 0.9, y: 20 }}
        animate={{ scale: 1, y: 0 }}
        exit={{ scale: 0.9, y: 20 }}
        transition={{ type: 'spring', stiffness: 400, damping: 25 }}
      >
        <GlassCard padding="lg">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-medium text-text-primary">Achievements</h2>
            <div className="flex items-center gap-3">
              <span className="text-xs font-numbers text-text-secondary">
                {unlocked.length}/{visible.length}
              </span>
              <button
                onClick={onClose}
                className="text-text-muted hover:text-text-primary transition-colors text-lg bg-transparent border-none cursor-pointer"
              >
                &times;
              </button>
            </div>
          </div>

          <div className="flex flex-col gap-2">
            {visible.map(a => {
              const isUnlocked = achievements[a.id]
              return (
                <div
                  key={a.id}
                  className={`flex items-center gap-3 p-3 rounded-lg transition-all ${
                    isUnlocked
                      ? 'bg-white/[0.04]'
                      : 'bg-white/[0.02] opacity-50'
                  }`}
                  style={isUnlocked ? {
                    border: '1px solid rgba(255, 215, 0, 0.15)',
                  } : {
                    border: '1px solid rgba(255, 255, 255, 0.04)',
                  }}
                >
                  <span className={`text-xl flex-shrink-0 ${isUnlocked ? '' : 'grayscale'}`}>
                    {isUnlocked ? a.icon : '🔒'}
                  </span>
                  <div className="flex-1 min-w-0">
                    <p className={`text-sm font-medium ${isUnlocked ? 'text-text-primary' : 'text-text-muted'}`}>
                      {isUnlocked ? a.name : '???'}
                    </p>
                    <p className="text-[0.65rem] text-text-muted line-clamp-1">
                      {isUnlocked ? a.description : 'Keep playing to unlock'}
                    </p>
                  </div>
                  {isUnlocked && (
                    <span className="text-[0.55rem] uppercase tracking-wider text-nobel-gold font-medium">
                      Done
                    </span>
                  )}
                </div>
              )
            })}
          </div>
        </GlassCard>
      </motion.div>
    </motion.div>
  )
}
