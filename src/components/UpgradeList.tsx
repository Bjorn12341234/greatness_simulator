import { useMemo } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { getUpgradesByPhase } from '../data/upgradeRegistry'
import type { UpgradeData } from '../store/types'
import { UpgradeCard } from './UpgradeCard'

export function UpgradeList() {
  const phase = useGameStore(s => s.phase)
  const upgrades = useGameStore(s => s.upgrades)
  const attention = useGameStore(s => s.attention)
  const cash = useGameStore(s => s.cash)
  const greatness = useGameStore(s => s.greatness)
  const clickCount = useGameStore(s => s.clickCount)
  const purchaseUpgrade = useGameStore(s => s.purchaseUpgrade)

  const resourceMap = useMemo(() => ({
    attention,
    cash,
    greatness,
    clickCount,
  }), [attention, cash, greatness, clickCount])

  const visibleUpgrades = useMemo(() => {
    const allUpgrades = getUpgradesByPhase(phase)
    return allUpgrades.filter(data => isVisible(data, upgrades, resourceMap))
  }, [phase, upgrades, resourceMap])

  // Group by tree
  const grouped = useMemo(() => {
    const groups: Record<string, UpgradeData[]> = {}
    for (const u of visibleUpgrades) {
      if (!groups[u.tree]) groups[u.tree] = []
      groups[u.tree].push(u)
    }
    return groups
  }, [visibleUpgrades])

  const canAfford = (data: UpgradeData): boolean => {
    const count = upgrades[data.id]?.count ?? 0
    if (count >= data.maxCount) return false
    const cost = data.baseCost * Math.pow(1.15, count)
    const resource = resourceMap[data.costResource as keyof typeof resourceMap] ?? 0
    return resource >= cost
  }

  return (
    <div className="flex flex-col gap-4 w-full max-w-lg mx-auto">
      {Object.entries(grouped).map(([tree, treeUpgrades]) => (
        <div key={tree}>
          <h2 className="text-xs font-medium text-text-secondary uppercase tracking-wider mb-2 px-1">
            {tree}
          </h2>
          <div className="flex flex-col gap-2">
            <AnimatePresence initial={false}>
              {treeUpgrades.map((data, i) => (
                <motion.div
                  key={data.id}
                  initial={{ opacity: 0, y: 16 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05, duration: 0.3 }}
                  layout
                >
                  <UpgradeCard
                    data={data}
                    state={upgrades[data.id]}
                    canAfford={canAfford(data)}
                    onPurchase={() => purchaseUpgrade(data.id)}
                  />
                </motion.div>
              ))}
            </AnimatePresence>
          </div>
        </div>
      ))}

      {visibleUpgrades.length === 0 && (
        <div className="text-center text-text-muted text-sm py-8">
          Keep clicking to discover upgrades...
        </div>
      )}
    </div>
  )
}

function isVisible(
  data: UpgradeData,
  upgrades: Record<string, { purchased: boolean; count: number; unlocked: boolean }>,
  resources: { attention: number; cash: number; greatness: number; clickCount: number }
): boolean {
  // Already purchased max? Still show it
  const state = upgrades[data.id]
  if (state?.purchased) return true

  // Check prerequisites
  if (data.prerequisites) {
    for (const prereqId of data.prerequisites) {
      const prereq = upgrades[prereqId]
      if (!prereq?.purchased) return false
    }
  }

  // Check unlock conditions
  if (data.unlockAt) {
    const current = resources[data.unlockAt.resource as keyof typeof resources] ?? 0
    if (current < data.unlockAt.threshold) return false
  }

  // First upgrade in each tree is always visible if no prerequisites
  if (!data.prerequisites && !data.unlockAt) return true

  return true
}
