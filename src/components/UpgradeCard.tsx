import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import type { UpgradeData, UpgradeState } from '../store/types'
import { calculateUpgradeCost } from '../engine/formulas'
import { formatNumber } from '../engine/format'
import { playPurchase } from '../engine/audio'
import { GlassCard } from './ui/GlassCard'

interface UpgradeCardProps {
  data: UpgradeData
  state: UpgradeState | undefined
  canAfford: boolean
  onPurchase: () => void
}

export function UpgradeCard({ data, state, canAfford, onPurchase }: UpgradeCardProps) {
  const [showFlash, setShowFlash] = useState(false)
  const count = state?.count ?? 0
  const purchased = count >= data.maxCount
  const cost = calculateUpgradeCost(data.baseCost, count)

  const handlePurchase = () => {
    if (!canAfford || purchased) return
    onPurchase()
    playPurchase()
    setShowFlash(true)
    setTimeout(() => setShowFlash(false), 400)
  }

  const glowColor = purchased ? 'green' : canAfford ? 'orange' : 'none'
  const opacity = !canAfford && !purchased ? 'opacity-60' : ''

  return (
    <GlassCard
      hover={canAfford && !purchased}
      glow={glowColor}
      padding="sm"
      className={`relative overflow-hidden cursor-pointer select-none ${opacity}`}
      onClick={handlePurchase}
      whileTap={canAfford && !purchased ? { scale: 0.97 } : undefined}
    >
      {/* Flash overlay on purchase */}
      <AnimatePresence>
        {showFlash && (
          <motion.div
            initial={{ opacity: 0.6 }}
            animate={{ opacity: 0 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.4 }}
            className="absolute inset-0 bg-accent/30 rounded-xl z-10"
          />
        )}
      </AnimatePresence>

      {/* Floating +1 */}
      <AnimatePresence>
        {showFlash && (
          <motion.span
            initial={{ opacity: 1, y: 0 }}
            animate={{ opacity: 0, y: -30 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.6 }}
            className="absolute top-1 right-3 text-accent font-bold text-lg z-20"
          >
            +1
          </motion.span>
        )}
      </AnimatePresence>

      <div className="flex items-start gap-3">
        {/* Icon */}
        <span className="text-2xl flex-shrink-0 mt-0.5">{data.icon}</span>

        <div className="flex-1 min-w-0">
          {/* Name + count */}
          <div className="flex items-center gap-2">
            <h3 className="text-sm font-medium text-text-primary truncate">
              {data.name}
            </h3>
            {data.maxCount > 1 && count > 0 && (
              <span className="text-[0.6rem] font-numbers text-text-muted px-1.5 py-0.5 bg-white/5 rounded-full">
                x{count}
              </span>
            )}
            {purchased && (
              <span className="w-2 h-2 rounded-full bg-success flex-shrink-0" />
            )}
          </div>

          {/* Description */}
          <p className="text-[0.65rem] text-text-muted mt-0.5 leading-relaxed line-clamp-2">
            {data.description}
          </p>

          {/* Cost + production */}
          <div className="flex items-center justify-between mt-1.5">
            {!purchased ? (
              <span className={`text-xs font-numbers ${canAfford ? 'text-accent' : 'text-text-muted'}`}>
                {formatNumber(cost)} {data.costResource}
              </span>
            ) : (
              <span className="text-xs text-success">Purchased</span>
            )}
            <span className="text-[0.6rem] text-text-secondary font-numbers">
              +{data.production}/s
            </span>
          </div>
        </div>
      </div>
    </GlassCard>
  )
}
