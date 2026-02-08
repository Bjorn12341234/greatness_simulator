import { useState } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { PRESTIGE_UPGRADES, calculatePrestigePoints } from '../data/prestige'

function formatNum(n: number): string {
  if (n >= 1e9) return (n / 1e9).toFixed(2) + 'B'
  if (n >= 1e6) return (n / 1e6).toFixed(2) + 'M'
  if (n >= 1e3) return (n / 1e3).toFixed(1) + 'K'
  return Math.floor(n).toLocaleString()
}

export function PrestigePanel({ onClose }: { onClose: () => void }) {
  const [confirmPrestige, setConfirmPrestige] = useState(false)
  const prestigeLevel = useGameStore(s => s.prestigeLevel)
  const prestigePoints = useGameStore(s => s.prestigePoints)
  const prestigeUpgrades = useGameStore(s => s.prestigeUpgrades)
  const greatnessUnits = useGameStore(s => s.greatnessUnits)
  const phase = useGameStore(s => s.phase)
  const prestige = useGameStore(s => s.prestige)
  const purchasePrestigeUpgrade = useGameStore(s => s.purchasePrestigeUpgrade)

  const ppToEarn = calculatePrestigePoints(greatnessUnits)
  const canPrestige = phase >= 2 // Can prestige from Phase 2 onward

  return (
    <motion.div
      className="fixed inset-0 z-[150] flex items-center justify-center p-4"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      style={{ background: 'rgba(0, 0, 0, 0.85)' }}
    >
      <motion.div
        className="w-full max-w-lg max-h-[85vh] overflow-y-auto glass-card rounded-2xl p-5"
        initial={{ scale: 0.9, y: 20 }}
        animate={{ scale: 1, y: 0 }}
        exit={{ scale: 0.9, y: 20 }}
      >
        {/* Header */}
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-display font-bold tracking-wider" style={{ color: '#FFD700' }}>
            NEW GAME+
          </h2>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full glass-card flex items-center justify-center text-sm cursor-pointer border-none hover:scale-110 transition-transform text-text-secondary"
          >
            X
          </button>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3 mb-5">
          <div className="glass-card rounded-xl p-3 text-center">
            <div className="text-xs text-text-muted uppercase tracking-wider mb-1">Prestige Level</div>
            <div className="text-2xl font-numbers font-bold" style={{ color: '#FFD700' }}>
              {prestigeLevel}
            </div>
          </div>
          <div className="glass-card rounded-xl p-3 text-center">
            <div className="text-xs text-text-muted uppercase tracking-wider mb-1">PP Available</div>
            <div className="text-2xl font-numbers font-bold" style={{ color: '#FFD700' }}>
              {formatNum(prestigePoints)}
            </div>
          </div>
          <div className="glass-card rounded-xl p-3 text-center">
            <div className="text-xs text-text-muted uppercase tracking-wider mb-1">PP on Reset</div>
            <div className="text-2xl font-numbers font-bold" style={{ color: ppToEarn > 0 ? '#33CC66' : '#666' }}>
              +{ppToEarn}
            </div>
          </div>
        </div>

        {/* Prestige Button */}
        {canPrestige && (
          <div className="mb-5">
            {!confirmPrestige ? (
              <button
                onClick={() => setConfirmPrestige(true)}
                className="w-full py-3 rounded-xl font-display font-bold tracking-wider text-sm cursor-pointer border-none transition-all"
                style={{
                  background: 'linear-gradient(135deg, #FFD700, #FF8C00)',
                  color: '#1a1a2e',
                  boxShadow: '0 0 20px rgba(255, 215, 0, 0.3)',
                }}
              >
                PRESTIGE (RESET + EARN {ppToEarn} PP)
              </button>
            ) : (
              <div className="glass-card rounded-xl p-4 text-center">
                <p className="text-sm text-text-secondary mb-3">
                  This will reset ALL progress. You keep achievements, prestige upgrades, and earn <span style={{ color: '#FFD700' }}>{ppToEarn} PP</span>.
                </p>
                <div className="flex gap-3">
                  <button
                    onClick={() => setConfirmPrestige(false)}
                    className="flex-1 py-2 rounded-lg glass-card text-sm cursor-pointer border-none text-text-secondary hover:text-text-primary transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    onClick={() => {
                      prestige()
                      onClose()
                    }}
                    className="flex-1 py-2 rounded-lg font-bold text-sm cursor-pointer border-none transition-all"
                    style={{
                      background: '#FF3333',
                      color: 'white',
                      boxShadow: '0 0 10px rgba(255, 51, 51, 0.3)',
                    }}
                  >
                    CONFIRM RESET
                  </button>
                </div>
              </div>
            )}
          </div>
        )}

        {/* Upgrade Tree */}
        <h3 className="text-sm font-display font-bold tracking-wider text-text-secondary uppercase mb-3">
          Permanent Upgrades
        </h3>

        <div className="space-y-2">
          {PRESTIGE_UPGRADES.map(upgrade => {
            const owned = prestigeUpgrades[upgrade.id] === true
            const canAfford = prestigePoints >= upgrade.cost
            const prereqsMet = !upgrade.prerequisites || upgrade.prerequisites.every(p => prestigeUpgrades[p])
            const canBuy = !owned && canAfford && prereqsMet

            return (
              <motion.div
                key={upgrade.id}
                className={`glass-card rounded-xl p-3 flex items-center gap-3 transition-all ${
                  owned ? 'opacity-60' : canBuy ? 'ring-1 ring-yellow-500/30' : ''
                }`}
                whileHover={canBuy ? { scale: 1.01 } : {}}
              >
                <div className="text-2xl flex-shrink-0">{upgrade.icon}</div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-medium text-text-primary">
                      {upgrade.name}
                    </span>
                    {owned && (
                      <span className="text-[0.6rem] font-bold px-1.5 py-0.5 rounded" style={{ background: '#33CC66', color: '#000' }}>
                        OWNED
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-text-muted mt-0.5 leading-relaxed">{upgrade.description}</p>
                  {!owned && upgrade.prerequisites && !prereqsMet && (
                    <p className="text-[0.6rem] text-red-400 mt-1">
                      Requires: {upgrade.prerequisites.map(p => {
                        const def = PRESTIGE_UPGRADES.find(u => u.id === p)
                        return def?.name ?? p
                      }).join(', ')}
                    </p>
                  )}
                </div>
                <div className="flex-shrink-0 text-right">
                  {!owned ? (
                    <button
                      onClick={() => canBuy && purchasePrestigeUpgrade(upgrade.id)}
                      disabled={!canBuy}
                      className={`px-3 py-1.5 rounded-lg text-xs font-bold cursor-pointer border-none transition-all ${
                        canBuy
                          ? 'hover:scale-105'
                          : 'opacity-40 cursor-not-allowed'
                      }`}
                      style={{
                        background: canBuy
                          ? 'linear-gradient(135deg, #FFD700, #FF8C00)'
                          : 'rgba(255, 255, 255, 0.05)',
                        color: canBuy ? '#1a1a2e' : '#666',
                      }}
                    >
                      {upgrade.cost} PP
                    </button>
                  ) : (
                    <span className="text-xs text-text-muted">---</span>
                  )}
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Info */}
        <div className="mt-4 text-center text-[0.65rem] text-text-muted leading-relaxed">
          Each prestige gives +10% base GpS multiplier. Current bonus: {((1 + 0.1 * prestigeLevel) * 100 - 100).toFixed(0)}%
        </div>
      </motion.div>
    </motion.div>
  )
}
