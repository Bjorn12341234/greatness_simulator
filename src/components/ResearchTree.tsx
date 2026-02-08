import { useMemo, useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { getUpgradesByTree } from '../data/upgradeRegistry'
import { calculateUpgradeCost } from '../engine/formulas'
import { formatNumber } from '../engine/format'
import type { UpgradeData, UpgradeState } from '../store/types'
import { playPurchase } from '../engine/audio'

type NodeStatus = 'locked' | 'available' | 'affordable' | 'purchased'

function getNodeStatus(
  data: UpgradeData,
  state: UpgradeState | undefined,
  upgrades: Record<string, UpgradeState>,
  resources: { attention: number; cash: number; greatness: number }
): NodeStatus {
  const count = state?.count ?? 0
  if (count >= data.maxCount) return 'purchased'

  // Check prerequisites
  if (data.prerequisites) {
    for (const prereqId of data.prerequisites) {
      if (!upgrades[prereqId]?.purchased) return 'locked'
    }
  }

  // Check unlock conditions
  if (data.unlockAt) {
    const current = resources[data.unlockAt.resource as keyof typeof resources] ?? 0
    if (current < data.unlockAt.threshold) return 'locked'
  }

  // Check affordability
  const cost = calculateUpgradeCost(data.baseCost, count)
  const resource = resources[data.costResource as keyof typeof resources] ?? 0
  return resource >= cost ? 'affordable' : 'available'
}

const STATUS_COLORS = {
  locked: { border: 'rgba(85, 85, 85, 0.3)', bg: 'rgba(42, 42, 42, 0.3)', text: 'text-text-muted' },
  available: { border: 'rgba(136, 136, 136, 0.4)', bg: 'rgba(42, 42, 42, 0.6)', text: 'text-text-secondary' },
  affordable: { border: 'rgba(255, 102, 0, 0.5)', bg: 'rgba(42, 42, 42, 0.6)', text: 'text-text-primary' },
  purchased: { border: 'rgba(51, 204, 102, 0.4)', bg: 'rgba(42, 42, 42, 0.5)', text: 'text-text-primary' },
}

const NODE_HEIGHT = 100
const NODE_GAP = 32
const CONNECTOR_HEIGHT = NODE_GAP

export function ResearchTree() {
  const upgrades = useGameStore(s => s.upgrades)
  const attention = useGameStore(s => s.attention)
  const cash = useGameStore(s => s.cash)
  const greatness = useGameStore(s => s.greatness)
  const purchaseUpgrade = useGameStore(s => s.purchaseUpgrade)

  const resources = useMemo(() => ({ attention, cash, greatness }), [attention, cash, greatness])

  // Get the Early Science tree upgrades in prerequisite order
  const scienceUpgrades = useMemo(() => {
    const raw = getUpgradesByTree('Early Science')
    // Sort by prerequisite chain: first has no prereqs, then each depends on previous
    const sorted: UpgradeData[] = []
    const remaining = [...raw]
    // Find root (no prerequisites or unlock condition only)
    const root = remaining.find(u => !u.prerequisites || u.prerequisites.length === 0)
    if (root) {
      sorted.push(root)
      remaining.splice(remaining.indexOf(root), 1)
    }
    // Chain the rest
    while (remaining.length > 0) {
      const lastId = sorted[sorted.length - 1]?.id
      const next = remaining.find(u => u.prerequisites?.includes(lastId))
      if (next) {
        sorted.push(next)
        remaining.splice(remaining.indexOf(next), 1)
      } else {
        // Append remaining in original order if chain breaks
        sorted.push(...remaining)
        break
      }
    }
    return sorted
  }, [])

  const totalHeight = scienceUpgrades.length * NODE_HEIGHT + (scienceUpgrades.length - 1) * CONNECTOR_HEIGHT

  return (
    <div className="flex flex-col items-center gap-6 pt-4 pb-4 max-w-lg mx-auto">
      <div className="w-full">
        <h1 className="text-lg font-medium text-text-primary mb-1 px-1">Research Lab</h1>
        <p className="text-xs text-text-muted px-1 mb-6">
          Advance your "scientific" agenda. Each breakthrough unlocks the next.
        </p>
      </div>

      {/* Tree Container */}
      <div className="relative w-full" style={{ minHeight: totalHeight }}>
        {/* SVG Connectors */}
        <svg
          className="absolute inset-0 w-full pointer-events-none"
          style={{ height: totalHeight }}
        >
          {scienceUpgrades.slice(0, -1).map((data, i) => {
            const startY = i * (NODE_HEIGHT + CONNECTOR_HEIGHT) + NODE_HEIGHT
            const endY = startY + CONNECTOR_HEIGHT
            const nextStatus = getNodeStatus(
              scienceUpgrades[i + 1],
              upgrades[scienceUpgrades[i + 1].id],
              upgrades,
              resources
            )
            const currentStatus = getNodeStatus(data, upgrades[data.id], upgrades, resources)
            const isActive = currentStatus === 'purchased'
            const color = isActive ? 'rgba(51, 204, 102, 0.6)' : 'rgba(85, 85, 85, 0.3)'

            return (
              <g key={`connector-${data.id}`}>
                <line
                  x1="50%"
                  y1={startY}
                  x2="50%"
                  y2={endY}
                  stroke={color}
                  strokeWidth={2}
                  strokeDasharray={isActive ? 'none' : '6 4'}
                />
                {/* Animated pulse dot on active connections */}
                {isActive && nextStatus !== 'locked' && (
                  <circle r={3} fill="rgba(51, 204, 102, 0.8)">
                    <animateMotion
                      dur="1.5s"
                      repeatCount="indefinite"
                      path={`M${0},${startY} L${0},${endY}`}
                    />
                  </circle>
                )}
              </g>
            )
          })}
        </svg>

        {/* Nodes */}
        {scienceUpgrades.map((data, i) => {
          const status = getNodeStatus(data, upgrades[data.id], upgrades, resources)
          const yOffset = i * (NODE_HEIGHT + CONNECTOR_HEIGHT)

          return (
            <ResearchNode
              key={data.id}
              data={data}
              state={upgrades[data.id]}
              status={status}
              yOffset={yOffset}
              index={i}
              isLast={i === scienceUpgrades.length - 1}
              onPurchase={() => purchaseUpgrade(data.id)}
            />
          )
        })}
      </div>
    </div>
  )
}

interface ResearchNodeProps {
  data: UpgradeData
  state: UpgradeState | undefined
  status: NodeStatus
  yOffset: number
  index: number
  isLast: boolean
  onPurchase: () => void
}

function ResearchNode({ data, state, status, yOffset, index, isLast, onPurchase }: ResearchNodeProps) {
  const [showFlash, setShowFlash] = useState(false)
  const count = state?.count ?? 0
  const cost = calculateUpgradeCost(data.baseCost, count)
  const colors = STATUS_COLORS[status]
  const isClickable = status === 'affordable'

  const handleClick = () => {
    if (!isClickable) return
    onPurchase()
    playPurchase()
    setShowFlash(true)
    setTimeout(() => setShowFlash(false), 500)
  }

  return (
    <motion.div
      className="absolute left-0 right-0 px-2"
      style={{ top: yOffset }}
      initial={{ opacity: 0, x: index % 2 === 0 ? -20 : 20 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: index * 0.1, duration: 0.4, ease: 'easeOut' }}
    >
      <motion.div
        className={`relative overflow-hidden rounded-xl ${isClickable ? 'cursor-pointer' : status === 'locked' ? 'cursor-not-allowed' : 'cursor-default'}`}
        style={{
          height: NODE_HEIGHT,
          background: colors.bg,
          backdropFilter: 'blur(12px)',
          WebkitBackdropFilter: 'blur(12px)',
          border: `1px solid ${colors.border}`,
          boxShadow: status === 'affordable'
            ? `0 0 20px rgba(255, 102, 0, 0.15), 0 4px 24px rgba(0, 0, 0, 0.3)`
            : status === 'purchased'
            ? `0 0 16px rgba(51, 204, 102, 0.1), 0 4px 24px rgba(0, 0, 0, 0.3)`
            : `0 4px 24px rgba(0, 0, 0, 0.3)`,
        }}
        onClick={handleClick}
        whileTap={isClickable ? { scale: 0.97 } : undefined}
        whileHover={isClickable ? { borderColor: 'rgba(255, 102, 0, 0.7)' } : undefined}
      >
        {/* Purchase flash */}
        <AnimatePresence>
          {showFlash && (
            <motion.div
              initial={{ opacity: 0.6 }}
              animate={{ opacity: 0 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.5 }}
              className="absolute inset-0 bg-accent/30 z-10"
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
              className="absolute top-2 right-4 text-accent font-bold text-lg z-20"
            >
              +1
            </motion.span>
          )}
        </AnimatePresence>

        <div className="flex items-center gap-4 h-full px-4">
          {/* Icon bubble */}
          <div
            className="flex-shrink-0 w-12 h-12 rounded-full flex items-center justify-center text-2xl"
            style={{
              background: status === 'purchased'
                ? 'rgba(51, 204, 102, 0.15)'
                : status === 'affordable'
                ? 'rgba(255, 102, 0, 0.15)'
                : 'rgba(255, 255, 255, 0.05)',
              border: `1px solid ${status === 'purchased'
                ? 'rgba(51, 204, 102, 0.3)'
                : status === 'affordable'
                ? 'rgba(255, 102, 0, 0.3)'
                : 'rgba(255, 255, 255, 0.08)'}`,
            }}
          >
            {status === 'locked' ? '🔒' : data.icon}
          </div>

          {/* Info */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2">
              <h3 className={`text-sm font-medium ${colors.text} truncate`}>
                {status === 'locked' ? '???' : data.name}
              </h3>
              {status === 'purchased' && (
                <span className="w-2 h-2 rounded-full bg-success flex-shrink-0" />
              )}
              {isLast && status !== 'purchased' && (
                <span className="text-[0.55rem] uppercase tracking-wider text-accent font-medium px-1.5 py-0.5 bg-accent/10 rounded-full border border-accent/20">
                  Phase 2
                </span>
              )}
            </div>

            <p className={`text-[0.65rem] ${status === 'locked' ? 'text-text-muted/50' : 'text-text-muted'} mt-0.5 leading-relaxed line-clamp-1`}>
              {status === 'locked' ? 'Complete previous research to unlock' : data.description}
            </p>

            <div className="flex items-center justify-between mt-1">
              {status === 'purchased' ? (
                <span className="text-xs text-success font-medium">Researched</span>
              ) : status === 'locked' ? (
                <span className="text-xs text-text-muted/50">Locked</span>
              ) : (
                <span className={`text-xs font-numbers ${status === 'affordable' ? 'text-accent' : 'text-text-muted'}`}>
                  {formatNumber(cost)} {data.costResource}
                </span>
              )}
              {status !== 'locked' && (
                <span className="text-[0.6rem] text-text-secondary font-numbers">
                  +{data.production}/s
                </span>
              )}
            </div>
          </div>
        </div>

        {/* Progress shimmer for affordable nodes */}
        {status === 'affordable' && (
          <div
            className="absolute bottom-0 left-0 right-0 h-0.5"
            style={{
              background: 'linear-gradient(90deg, transparent, rgba(255, 102, 0, 0.6), transparent)',
              backgroundSize: '200% 100%',
              animation: 'shimmer 2s linear infinite',
            }}
          />
        )}
      </motion.div>
    </motion.div>
  )
}
