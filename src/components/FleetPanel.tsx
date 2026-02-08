import { useState } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { SHIP_CLASSES, getShipyardCost } from '../data/phase3/fleet'
import { GlassCard } from './ui/GlassCard'
import { formatCompact, formatDuration } from '../engine/format'

export function FleetPanel() {
  const fleet = useGameStore(s => s.fleet)
  const cash = useGameStore(s => s.cash)
  const shipyardLevel = useGameStore(s => s.shipyardLevel)
  const shipyardQueue = useGameStore(s => s.shipyardQueue)
  const warOutput = useGameStore(s => s.warOutput)
  const fear = useGameStore(s => s.fear)
  const buildShip = useGameStore(s => s.buildShip)
  const upgradeShipyard = useGameStore(s => s.upgradeShipyard)
  const [buildAmounts, setBuildAmounts] = useState<Record<string, number>>({})

  const totalShips = Object.values(fleet).reduce((sum, count) => sum + count, 0)
  const shipyardUpgradeCost = getShipyardCost(shipyardLevel)

  return (
    <div className="flex flex-col gap-4 max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">Orange Class Fleet</h2>
        <span className="text-sm font-numbers text-text-secondary">
          {totalShips} ships
        </span>
      </div>

      {/* Fleet Summary */}
      <div className="grid grid-cols-3 gap-2">
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">War Output</p>
          <p className="text-sm font-numbers text-[#FF6600]">{formatCompact(warOutput)}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Global Fear</p>
          <p className="text-sm font-numbers text-[#FF3333]">{fear.toFixed(0)}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Shipyard Lv.</p>
          <p className="text-sm font-numbers text-[#33BBFF]">{shipyardLevel}</p>
        </GlassCard>
      </div>

      {/* Shipyard Upgrade */}
      <GlassCard padding="sm">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-text-primary">Shipyard Level {shipyardLevel}</p>
            <p className="text-[0.55rem] text-text-muted">
              Production: {shipyardLevel} ship{shipyardLevel !== 1 ? 's' : ''} per 10s cycle
            </p>
          </div>
          <button
            onClick={() => upgradeShipyard()}
            disabled={cash < shipyardUpgradeCost}
            className={`
              px-3 py-1.5 rounded-lg text-xs font-medium transition-all
              ${cash >= shipyardUpgradeCost
                ? 'bg-[#33BBFF]/20 text-[#33BBFF] hover:bg-[#33BBFF]/30 cursor-pointer'
                : 'bg-white/5 text-text-muted cursor-not-allowed'}
            `}
          >
            Upgrade ${formatCompact(shipyardUpgradeCost)}
          </button>
        </div>
      </GlassCard>

      {/* Build Queue */}
      {shipyardQueue && (
        <ShipyardQueueDisplay queue={shipyardQueue} shipyardLevel={shipyardLevel} />
      )}

      {/* Ship Classes */}
      <div className="flex flex-col gap-3">
        {SHIP_CLASSES.map((def, index) => {
          const count = fleet[def.id] ?? 0
          const isLocked = shipyardLevel < def.requiresShipyard
          const buildAmount = buildAmounts[def.id] ?? 1
          const totalCost = def.costCash * buildAmount
          const canBuild = !isLocked && !shipyardQueue && cash >= totalCost

          return (
            <motion.div
              key={def.id}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
            >
              <GlassCard
                padding="sm"
                style={{
                  opacity: isLocked ? 0.5 : 1,
                  borderColor: count > 0 ? 'rgba(255, 102, 0, 0.2)' : 'transparent',
                }}
              >
                {/* Ship Header */}
                <div className="flex items-center gap-2 mb-1.5">
                  <span className="text-lg">{def.icon}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-text-primary truncate">{def.name}</p>
                    <p className="text-[0.55rem] text-text-muted">{def.description}</p>
                  </div>
                  {count > 0 && (
                    <span className="text-sm font-numbers text-[#FF6600] font-medium">
                      x{count}
                    </span>
                  )}
                </div>

                {/* Flavor text */}
                <p className="text-[0.5rem] text-text-muted italic mb-2">"{def.flavorText}"</p>

                {/* Stats row */}
                <div className="flex gap-3 mb-2 text-[0.55rem]">
                  <span className="text-text-secondary font-numbers">
                    +{def.warOutput} War
                  </span>
                  <span className="font-numbers" style={{ color: def.fear > 50 ? '#FF3333' : '#FF8833' }}>
                    +{def.fear} Fear
                  </span>
                  <span className="font-numbers" style={{ color: def.nobelImpact >= 0 ? '#33CC66' : '#FF3333' }}>
                    {def.nobelImpact > 0 ? '+' : ''}{def.nobelImpact} Nobel
                  </span>
                </div>

                {/* Special */}
                {def.special && (
                  <p className="text-[0.5rem] text-[#FF8833] mb-2">{def.special}</p>
                )}

                {/* Build controls */}
                {isLocked ? (
                  <p className="text-[0.5rem] text-text-muted">
                    Requires Shipyard Lv. {def.requiresShipyard}
                  </p>
                ) : (
                  <div className="flex items-center gap-2">
                    {/* Amount selector */}
                    <div className="flex items-center gap-1">
                      {[1, 5, 10].map(amt => (
                        <button
                          key={amt}
                          onClick={() => setBuildAmounts(prev => ({ ...prev, [def.id]: amt }))}
                          className={`
                            px-2 py-0.5 rounded text-[0.6rem] font-numbers transition-all cursor-pointer
                            ${buildAmount === amt
                              ? 'bg-[#FF6600]/20 text-[#FF6600]'
                              : 'bg-white/5 text-text-muted hover:bg-white/10'}
                          `}
                        >
                          {amt}
                        </button>
                      ))}
                    </div>

                    {/* Build button */}
                    <button
                      onClick={() => buildShip(def.id, buildAmount)}
                      disabled={!canBuild}
                      className={`
                        flex-1 px-3 py-1.5 rounded-lg text-xs font-medium transition-all
                        ${canBuild
                          ? 'bg-[#FF6600]/20 text-[#FF6600] hover:bg-[#FF6600]/30 cursor-pointer'
                          : 'bg-white/5 text-text-muted cursor-not-allowed'}
                      `}
                    >
                      Build x{buildAmount} — ${formatCompact(totalCost)}
                    </button>
                  </div>
                )}
              </GlassCard>
            </motion.div>
          )
        })}
      </div>

      {/* Fear Warning */}
      {fear > 50 && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="p-3 rounded-lg bg-[#FF3333]/10 border border-[#FF3333]/20"
        >
          <p className="text-xs text-[#FF3333] font-medium">
            High Fear drains Legitimacy (-{(fear * 0.005).toFixed(2)}%/s)
          </p>
          <p className="text-[0.55rem] text-text-muted mt-1">
            Fleet size generates passive Fear. Balance military power against stability.
          </p>
        </motion.div>
      )}
    </div>
  )
}

// ── Shipyard Queue Display ──

function ShipyardQueueDisplay({ queue, shipyardLevel }: {
  queue: import('../store/types').ShipyardOrder
  shipyardLevel: number
}) {
  const buildInterval = 10 / shipyardLevel
  const elapsed = (Date.now() - queue.lastBuildAt) / 1000
  const currentProgress = Math.min(100, (elapsed / buildInterval) * 100)
  const remaining = queue.quantity - queue.builtSoFar
  const totalTimeLeft = remaining * buildInterval

  return (
    <GlassCard padding="sm" glow="orange">
      <div className="flex items-center justify-between mb-1.5">
        <span className="text-xs font-medium text-[#FF6600]">
          Building: {queue.shipId.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}
        </span>
        <span className="text-[0.55rem] font-numbers text-text-secondary">
          {queue.builtSoFar}/{queue.quantity}
        </span>
      </div>
      <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5 mb-1">
        <motion.div
          className="h-full rounded-full bg-[#FF6600]"
          initial={{ width: 0 }}
          animate={{ width: `${currentProgress}%` }}
          transition={{ duration: 0.3 }}
        />
      </div>
      <span className="text-[0.5rem] text-text-muted font-numbers">
        ~{formatDuration(totalTimeLeft)} remaining
      </span>
    </GlassCard>
  )
}
