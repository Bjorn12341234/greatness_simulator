import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { GlassCard } from './ui/GlassCard'

export function NobelMeter() {
  const nobelScore = useGameStore(s => s.nobelScore)
  const nobelThreshold = useGameStore(s => s.nobelThreshold)
  const nobelPrizesWon = useGameStore(s => s.nobelPrizesWon)
  const fear = useGameStore(s => s.fear)

  const progress = Math.min(100, (nobelScore / nobelThreshold) * 100)
  const isClose = progress >= 75
  const isActive = nobelScore > 0

  // Active wars count
  const activeWars = useGameStore(s =>
    Object.values(s.countries).filter(c => c.status === 'occupied' || c.status === 'coup_target').length
  )

  return (
    <GlassCard
      padding="sm"
      glow={isClose ? 'gold' : 'none'}
      style={{
        borderColor: isClose ? 'rgba(255, 215, 0, 0.3)' : 'transparent',
      }}
    >
      {/* Header */}
      <div className="flex items-center justify-between mb-2">
        <div className="flex items-center gap-2">
          <span className="text-lg">🏅</span>
          <div>
            <p className="text-sm font-medium text-text-primary">Nobel Peace Prize</p>
            <p className="text-[0.55rem] text-text-muted">
              {nobelPrizesWon > 0
                ? `Won ${nobelPrizesWon} time${nobelPrizesWon > 1 ? 's' : ''}`
                : 'Build peace optics to win'}
            </p>
          </div>
        </div>
        <span className="text-sm font-numbers" style={{ color: '#FFD700' }}>
          {nobelScore.toFixed(0)} / {nobelThreshold}
        </span>
      </div>

      {/* Progress bar */}
      <div className="w-full h-2.5 rounded-full overflow-hidden bg-white/5 mb-2">
        <motion.div
          className="h-full rounded-full"
          initial={false}
          animate={{ width: `${progress}%` }}
          style={{
            background: isClose
              ? 'linear-gradient(90deg, #FFD700, #FFA500)'
              : 'linear-gradient(90deg, #FFD700, #CC8800)',
          }}
          transition={{ duration: 0.5, ease: 'easeOut' }}
        />
      </div>

      {/* Close notification */}
      {isClose && isActive && (
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: [0.5, 1, 0.5] }}
          transition={{ repeat: Infinity, duration: 2 }}
          className="text-[0.55rem] font-medium mb-2"
          style={{ color: '#FFD700' }}
        >
          Nobel Committee is watching...
        </motion.p>
      )}

      {/* Irony indicators */}
      <div className="flex gap-3 text-[0.5rem]">
        {activeWars > 0 && (
          <span className="text-[#FF3333]">
            {activeWars} active war{activeWars > 1 ? 's' : ''}
          </span>
        )}
        {fear > 30 && (
          <span className="text-[#FF8833]">
            Global Fear: {fear.toFixed(0)}
          </span>
        )}
        {activeWars > 0 && nobelScore > nobelThreshold * 0.5 && (
          <span className="text-[#FFD700] italic">
            "Peace through strength"
          </span>
        )}
      </div>

      {/* Prizes won */}
      {nobelPrizesWon > 0 && (
        <div className="mt-2 pt-2 border-t border-white/5 flex items-center gap-1">
          {Array.from({ length: nobelPrizesWon }).map((_, i) => (
            <span key={i} className="text-sm">🏅</span>
          ))}
          <span className="text-[0.5rem] text-text-muted ml-1">
            Threshold: {nobelThreshold} (+{Math.round(nobelThreshold * 0.5)} per prize)
          </span>
        </div>
      )}
    </GlassCard>
  )
}
