import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { getLegitimacyStatus, getLegitimacyMultiplier, calculateNetLegitimacyChange } from '../engine/formulas'
import { GlassCard } from './ui/GlassCard'

export function LegitimacyMeter() {
  const legitimacy = useGameStore(s => s.legitimacy)
  const phase = useGameStore(s => s.phase)

  // Build a lightweight state snapshot for net change calc
  const netChange = useGameStore(s => {
    if (s.phase < 2) return 0
    return calculateNetLegitimacyChange(s)
  })

  if (phase < 2) return null

  const status = getLegitimacyStatus(legitimacy)
  const multiplier = getLegitimacyMultiplier(legitimacy)
  const changePerSec = netChange

  return (
    <GlassCard
      padding="sm"
      className="w-full"
      glow={status.critical ? 'red' : 'none'}
    >
      <div className="flex flex-col gap-2">
        {/* Header row */}
        <div className="flex items-center justify-between">
          <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">
            Legitimacy
          </span>
          <div className="flex items-center gap-2">
            <span
              className="text-[0.6rem] uppercase tracking-wider font-medium"
              style={{ color: status.color }}
            >
              {status.label}
            </span>
            <span className="text-text-muted text-[0.55rem]">
              {multiplier > 1 ? `+${((multiplier - 1) * 100).toFixed(0)}%` : multiplier < 1 ? `${((multiplier - 1) * 100).toFixed(0)}%` : ''} GpS
            </span>
          </div>
        </div>

        {/* Meter bar */}
        <div className="relative w-full h-3 rounded-full overflow-hidden bg-white/5">
          {/* Tick marks at 25%, 50%, 80% */}
          {[25, 50, 80].map(mark => (
            <div
              key={mark}
              className="absolute top-0 bottom-0 w-px bg-white/10"
              style={{ left: `${mark}%` }}
            />
          ))}

          {/* Fill bar */}
          <motion.div
            className="absolute top-0 left-0 h-full rounded-full"
            initial={false}
            animate={{
              width: `${Math.max(0, Math.min(100, legitimacy))}%`,
              backgroundColor: status.color,
              boxShadow: `0 0 8px ${status.glowColor}`,
            }}
            transition={{ duration: 0.5, ease: 'easeOut' }}
          />

          {/* Numeric overlay */}
          <div className="absolute inset-0 flex items-center justify-center">
            <span className="font-numbers text-[0.6rem] text-white/80 drop-shadow-sm">
              {legitimacy.toFixed(1)}%
            </span>
          </div>
        </div>

        {/* Rate indicator */}
        <div className="flex items-center justify-between">
          <span
            className="text-[0.55rem] font-numbers"
            style={{ color: changePerSec >= 0 ? '#33CC66' : '#FF3333' }}
          >
            {changePerSec >= 0 ? '+' : ''}{(changePerSec * 100).toFixed(2)}%/s
          </span>

          {/* Collapse warning */}
          {status.critical && (
            <motion.span
              className="text-[0.6rem] text-danger font-medium"
              animate={{ opacity: [1, 0.3, 1] }}
              transition={{ duration: 1, repeat: Infinity }}
            >
              COLLAPSE WARNING
            </motion.span>
          )}
        </div>
      </div>
    </GlassCard>
  )
}
