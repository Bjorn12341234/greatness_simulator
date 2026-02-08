import { useCallback } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { LOYALTY_UPGRADES } from '../data/phase2/loyalty'
import { GlassCard } from './ui/GlassCard'
import { AnimatedNumber } from './ui/AnimatedNumber'
import { formatCompact } from '../engine/format'

export function LoyaltyPanel() {
  const loyalty = useGameStore(s => s.loyalty)
  const cash = useGameStore(s => s.cash)
  const loyaltyUpgrades = useGameStore(s => s.loyaltyUpgrades)

  const purchaseUpgrade = useCallback((id: string, loyaltyCost: number, cashCost: number) => {
    const state = useGameStore.getState()
    if (state.loyalty < loyaltyCost || state.cash < cashCost) return
    if (state.loyaltyUpgrades[id]) return

    useGameStore.setState({
      loyalty: state.loyalty - loyaltyCost,
      cash: state.cash - cashCost,
      loyaltyUpgrades: {
        ...state.loyaltyUpgrades,
        [id]: true,
      },
    })
  }, [])

  return (
    <div className="flex flex-col gap-4 max-w-lg mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">Loyalty Economy</h2>
        <div className="flex items-center gap-2">
          <span className="text-[0.6rem] text-text-muted uppercase tracking-wider">Loyalty:</span>
          <AnimatedNumber value={loyalty} className="text-sm font-numbers text-accent" />
        </div>
      </div>
      <p className="text-[0.65rem] text-text-muted -mt-2">
        Compliance is the foundation of efficiency.
      </p>

      {/* Upgrade cards */}
      <div className="flex flex-col gap-3">
        {LOYALTY_UPGRADES.map((def, i) => {
          const owned = loyaltyUpgrades[def.id] ?? false
          const canAfford = loyalty >= def.cost && cash >= def.cashCost

          return (
            <motion.div
              key={def.id}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
            >
              <GlassCard
                padding="sm"
                glow={owned ? 'green' : canAfford ? 'orange' : 'none'}
              >
                <div className="flex items-start gap-3">
                  <span className="text-xl flex-shrink-0">{def.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between mb-0.5">
                      <span className="text-xs font-medium text-text-primary">{def.name}</span>
                      {owned && <span className="text-[0.6rem] text-success font-medium">ACTIVE</span>}
                    </div>
                    <p className="text-[0.55rem] text-text-secondary mb-1">{def.description}</p>
                    <p className="text-[0.5rem] text-text-muted italic">"{def.flavorText}"</p>

                    {!owned && (
                      <div className="flex items-center justify-between mt-2">
                        <span className="text-[0.55rem] font-numbers text-text-secondary">
                          {def.cost} Loyalty + ${formatCompact(def.cashCost)}
                        </span>
                        <button
                          onClick={() => purchaseUpgrade(def.id, def.cost, def.cashCost)}
                          disabled={!canAfford}
                          className={`
                            px-3 py-1 rounded text-[0.6rem] font-medium transition-all cursor-pointer
                            ${canAfford
                              ? 'bg-accent/20 text-accent border border-accent/30 hover:bg-accent/30'
                              : 'bg-white/[0.03] text-text-muted border border-white/5 cursor-not-allowed'}
                          `}
                        >
                          Activate
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              </GlassCard>
            </motion.div>
          )
        })}
      </div>
    </div>
  )
}
