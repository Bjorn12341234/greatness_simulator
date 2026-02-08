import { useCallback } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { TARIFFS } from '../data/phase2/tariffs'
import { GlassCard } from './ui/GlassCard'
import { formatCompact } from '../engine/format'

const LEVEL_LABELS = ['Off', 'Low', 'Medium', 'High']

export function TariffPanel() {
  const tariffs = useGameStore(s => s.tariffs)
  const setTariffLevel = useCallback((id: string, level: number) => {
    const state = useGameStore.getState()
    const current = state.tariffs[id] ?? { active: false, level: 0, cashGenerated: 0, sideEffectAccumulated: 0 }
    useGameStore.setState({
      tariffs: {
        ...state.tariffs,
        [id]: { ...current, level, active: level > 0 },
      },
    })
  }, [])

  const activeTariffs = Object.values(tariffs).filter(t => t.active).length
  const totalCashPerMin = TARIFFS.reduce((sum, def) => {
    const level = tariffs[def.id]?.level ?? 0
    return sum + def.cashPerMinute[level]
  }, 0)

  return (
    <div className="flex flex-col gap-4 max-w-lg mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">Tariff Controls</h2>
        <div className="flex flex-col items-end">
          <span className="text-xs font-numbers text-success">
            +${formatCompact(totalCashPerMin)}/min
          </span>
          <span className="text-[0.55rem] text-text-muted">
            {activeTariffs} active
          </span>
        </div>
      </div>

      {/* Tariff Cards */}
      <div className="flex flex-col gap-3">
        {TARIFFS.map((def, i) => {
          const state = tariffs[def.id]
          const level = state?.level ?? 0

          return (
            <motion.div
              key={def.id}
              initial={{ opacity: 0, x: -8 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.04 }}
            >
              <GlassCard
                padding="sm"
                style={level > 0 ? {
                  borderColor: 'rgba(255, 102, 0, 0.2)',
                  boxShadow: '0 0 12px rgba(255, 102, 0, 0.08)',
                } : undefined}
              >
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-lg">{def.icon}</span>
                  <div className="flex-1">
                    <p className="text-xs font-medium text-text-primary">{def.name}</p>
                    <p className="text-[0.55rem] text-text-muted">{def.description}</p>
                  </div>
                </div>

                {/* Level selector */}
                <div className="flex gap-1.5 mb-2">
                  {LEVEL_LABELS.map((label, lvl) => (
                    <button
                      key={lvl}
                      onClick={() => setTariffLevel(def.id, lvl)}
                      className={`
                        flex-1 py-1.5 rounded text-[0.6rem] font-medium transition-all cursor-pointer
                        ${level === lvl
                          ? lvl === 0
                            ? 'bg-white/10 text-text-primary border border-white/20'
                            : 'bg-accent/20 text-accent border border-accent/30'
                          : 'bg-white/[0.03] text-text-muted border border-transparent hover:bg-white/5'}
                      `}
                    >
                      {label}
                    </button>
                  ))}
                </div>

                {/* Effects preview */}
                {level > 0 && (
                  <div className="flex flex-wrap gap-x-4 gap-y-0.5 text-[0.55rem]">
                    <span className="text-success font-numbers">
                      +${formatCompact(def.cashPerMinute[level])}/min
                    </span>
                    {def.legitimacyDrain[level] < 0 && (
                      <span className="text-danger font-numbers">
                        {(def.legitimacyDrain[level] * 100).toFixed(1)}% legit/s
                      </span>
                    )}
                    {def.productionPenalty[level] < 0 && (
                      <span className="text-danger font-numbers">
                        {(def.productionPenalty[level] * 100).toFixed(0)}% production
                      </span>
                    )}
                  </div>
                )}
              </GlassCard>
            </motion.div>
          )
        })}
      </div>
    </div>
  )
}
