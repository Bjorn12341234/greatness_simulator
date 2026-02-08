import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { WorldMap } from './WorldMap'
import { FleetPanel } from './FleetPanel'
import { NobelMeter } from './NobelMeter'
import { GlassCard } from './ui/GlassCard'
import { useGameStore } from '../store/gameStore'
import { formatCompact } from '../engine/format'

type WorldTab = 'countries' | 'fleet' | 'overview'

const TABS: { id: WorldTab; label: string; icon: string }[] = [
  { id: 'overview', label: 'Overview', icon: '🌍' },
  { id: 'countries', label: 'Countries', icon: '🗺️' },
  { id: 'fleet', label: 'Fleet', icon: '⚓' },
]

export function WorldDashboard() {
  const [activeTab, setActiveTab] = useState<WorldTab>('overview')

  return (
    <div className="flex flex-col gap-4 max-w-2xl mx-auto">
      {/* Sub-tab nav */}
      <div className="flex gap-1 p-1 rounded-xl bg-white/5">
        {TABS.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`
              flex-1 flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium transition-all cursor-pointer
              ${activeTab === tab.id
                ? 'bg-[#FF6600]/20 text-[#FF6600]'
                : 'text-text-secondary hover:text-text-primary hover:bg-white/5'}
            `}
          >
            <span>{tab.icon}</span>
            {tab.label}
          </button>
        ))}
      </div>

      {/* Tab content */}
      <AnimatePresence mode="wait">
        <motion.div
          key={activeTab}
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -8 }}
          transition={{ duration: 0.15 }}
        >
          {activeTab === 'overview' && <WorldOverview />}
          {activeTab === 'countries' && <WorldMap />}
          {activeTab === 'fleet' && <FleetPanel />}
        </motion.div>
      </AnimatePresence>
    </div>
  )
}

// ── World Overview — shows Nobel Meter + summary stats ──

function WorldOverview() {
  const countries = useGameStore(s => s.countries)
  const warOutput = useGameStore(s => s.warOutput)
  const fear = useGameStore(s => s.fear)
  const fleet = useGameStore(s => s.fleet)

  const annexed = Object.values(countries).filter(c => c.status === 'annexed' || c.status === 'allied').length
  const infiltrated = Object.values(countries).filter(c => c.status === 'infiltrated' || c.status === 'coup_target').length
  const atWar = Object.values(countries).filter(c => c.status === 'occupied').length
  const totalShips = Object.values(fleet).reduce((sum, n) => sum + n, 0)

  return (
    <div className="flex flex-col gap-4">
      {/* Nobel Meter */}
      <NobelMeter />

      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-2">
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Under Accord</p>
          <p className="text-lg font-numbers text-[#33CC66]">{annexed}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Infiltrated</p>
          <p className="text-lg font-numbers text-[#FF8833]">{infiltrated}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">At War</p>
          <p className="text-lg font-numbers text-[#FF3333]">{atWar}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Fleet Size</p>
          <p className="text-lg font-numbers text-[#33BBFF]">{totalShips}</p>
        </GlassCard>
      </div>

      {/* War/Fear summary */}
      <GlassCard padding="sm">
        <div className="flex justify-between">
          <div>
            <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">War Output</p>
            <p className="text-sm font-numbers text-[#FF6600]">{formatCompact(warOutput)}</p>
          </div>
          <div className="text-right">
            <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Global Fear</p>
            <p className="text-sm font-numbers" style={{ color: fear > 50 ? '#FF3333' : '#FF8833' }}>
              {fear.toFixed(0)}
            </p>
          </div>
        </div>
        {fear > 0 && (
          <div className="mt-2">
            <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5">
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{
                  width: `${Math.min(100, fear)}%`,
                  background: fear > 50
                    ? 'linear-gradient(90deg, #FF6600, #FF3333)'
                    : 'linear-gradient(90deg, #FF8833, #FF6600)',
                }}
              />
            </div>
            <p className="text-[0.5rem] text-text-muted mt-1">
              Fear reduces resistance in all countries but drains legitimacy
            </p>
          </div>
        )}
      </GlassCard>
    </div>
  )
}
