import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { InstitutionBoard } from './InstitutionBoard'
import { BudgetPanel } from './BudgetPanel'
import { TariffPanel } from './TariffPanel'
import { DataCenterPanel } from './DataCenterPanel'
import { LoyaltyPanel } from './LoyaltyPanel'

type ControlView = 'institutions' | 'budget' | 'tariffs' | 'datacenters' | 'loyalty'

const TABS: { key: ControlView; label: string }[] = [
  { key: 'institutions', label: '🏛️ Institutions' },
  { key: 'budget', label: '💰 Budget' },
  { key: 'tariffs', label: '📊 Tariffs' },
  { key: 'datacenters', label: '🖥️ Data Centers' },
  { key: 'loyalty', label: '⭐ Loyalty' },
]

export function ControlDashboard() {
  const [view, setView] = useState<ControlView>('institutions')

  return (
    <div className="flex flex-col gap-4">
      {/* Sub-navigation */}
      <div className="flex gap-1.5 flex-wrap">
        {TABS.map(tab => (
          <button
            key={tab.key}
            onClick={() => setView(tab.key)}
            className={`
              px-3 py-1.5 rounded-lg text-[0.65rem] font-medium uppercase tracking-wider transition-all cursor-pointer
              ${view === tab.key
                ? 'bg-accent/20 text-accent border border-accent/30'
                : 'bg-white/5 text-text-secondary border border-transparent hover:bg-white/10'}
            `}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <AnimatePresence mode="wait">
        <motion.div
          key={view}
          initial={{ opacity: 0, y: 6 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -6 }}
          transition={{ duration: 0.15 }}
        >
          {view === 'institutions' && <InstitutionBoard />}
          {view === 'budget' && <BudgetPanel />}
          {view === 'tariffs' && <TariffPanel />}
          {view === 'datacenters' && <DataCenterPanel />}
          {view === 'loyalty' && <LoyaltyPanel />}
        </motion.div>
      </AnimatePresence>
    </div>
  )
}
