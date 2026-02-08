import { useCallback } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { DATA_CENTER_UPGRADES, type DataCenterUpgradeDef } from '../data/phase2/dataCenters'
import { GlassCard } from './ui/GlassCard'
import { formatCompact } from '../engine/format'

export function DataCenterPanel() {
  const dataCenterUpgrades = useGameStore(s => s.dataCenterUpgrades)
  const cash = useGameStore(s => s.cash)

  const purchaseUpgrade = useCallback((id: string, cost: number) => {
    const state = useGameStore.getState()
    if (state.cash < cost) return
    if (state.dataCenterUpgrades[id]) return

    useGameStore.setState({
      cash: state.cash - cost,
      dataCenterUpgrades: {
        ...state.dataCenterUpgrades,
        [id]: true,
      },
    })
  }, [])

  const purchasedCount = Object.values(dataCenterUpgrades).filter(Boolean).length

  return (
    <div className="flex flex-col gap-4 max-w-lg mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">Data Center Empire</h2>
        <span className="text-xs font-numbers text-text-secondary">
          {purchasedCount}/{DATA_CENTER_UPGRADES.length} deployed
        </span>
      </div>
      <p className="text-[0.65rem] text-text-muted -mt-2">
        AI-powered innovation for a more aligned future.
      </p>

      {/* Upgrade nodes */}
      <div className="flex flex-col gap-2">
        {DATA_CENTER_UPGRADES.map((def, i) => {
          const owned = dataCenterUpgrades[def.id] ?? false
          const prereqMet = !def.prerequisite || (dataCenterUpgrades[def.prerequisite] ?? false)
          const canAfford = cash >= def.cost
          const available = !owned && prereqMet

          return (
            <DataCenterNode
              key={def.id}
              def={def}
              index={i}
              owned={owned}
              available={available}
              canAfford={canAfford}
              onPurchase={() => purchaseUpgrade(def.id, def.cost)}
              showConnector={i > 0}
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Single Data Center Node ──

function DataCenterNode({ def, index, owned, available, canAfford, onPurchase, showConnector }: {
  def: DataCenterUpgradeDef
  index: number
  owned: boolean
  available: boolean
  canAfford: boolean
  onPurchase: () => void
  showConnector: boolean
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05 }}
      className="relative"
    >
      {/* Connector line */}
      {showConnector && (
        <div className="absolute -top-2 left-6 w-px h-4" style={{
          background: owned ? '#33CC66' : 'rgba(255,255,255,0.1)',
        }} />
      )}

      <GlassCard
        padding="sm"
        glow={owned ? 'green' : available && canAfford ? 'orange' : 'none'}
        className={!available && !owned ? 'opacity-40' : ''}
      >
        <div className="flex items-start gap-3">
          {/* Icon + status dot */}
          <div className="relative flex-shrink-0">
            <span className="text-xl">{def.icon}</span>
            {owned && (
              <div className="absolute -top-0.5 -right-0.5 w-2.5 h-2.5 rounded-full bg-success border border-bg-primary" />
            )}
          </div>

          {/* Content */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center justify-between mb-0.5">
              <span className="text-xs font-medium text-text-primary">{def.name}</span>
              {!owned && (
                <span className="text-[0.6rem] font-numbers text-text-secondary">
                  ${formatCompact(def.cost)}
                </span>
              )}
              {owned && (
                <span className="text-[0.6rem] text-success font-medium">DEPLOYED</span>
              )}
            </div>
            <p className="text-[0.55rem] text-text-secondary mb-1">{def.description}</p>
            <p className="text-[0.5rem] text-text-muted italic">"{def.flavorText}"</p>

            {/* Purchase button */}
            {available && !owned && (
              <button
                onClick={onPurchase}
                disabled={!canAfford}
                className={`
                  mt-2 w-full py-1.5 rounded-lg text-[0.65rem] font-medium uppercase tracking-wider transition-all cursor-pointer
                  ${canAfford
                    ? 'bg-accent/20 text-accent border border-accent/30 hover:bg-accent/30'
                    : 'bg-white/[0.03] text-text-muted border border-white/5 cursor-not-allowed'}
                `}
              >
                {canAfford ? 'Deploy' : 'Insufficient Funds'}
              </button>
            )}
          </div>
        </div>
      </GlassCard>
    </motion.div>
  )
}
