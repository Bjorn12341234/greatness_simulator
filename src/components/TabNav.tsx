import { motion } from 'framer-motion'

export type Tab = 'dashboard' | 'research' | 'control' | 'world' | 'space' | 'universe'

interface TabDef {
  id: Tab
  label: string
  icon: string
  phase: number
}

const TABS: TabDef[] = [
  { id: 'dashboard', label: 'Dashboard', icon: '📊', phase: 1 },
  { id: 'research', label: 'Research', icon: '🧬', phase: 1 },
  { id: 'control', label: 'Control', icon: '🏛️', phase: 2 },
  { id: 'world', label: 'World', icon: '🌍', phase: 3 },
  { id: 'space', label: 'Space', icon: '🚀', phase: 4 },
  { id: 'universe', label: 'Universe', icon: '🌌', phase: 5 },
]

interface TabNavProps {
  activeTab: Tab
  currentPhase: number
  onTabChange: (tab: Tab) => void
}

export function TabNav({ activeTab, currentPhase, onTabChange }: TabNavProps) {
  // Show unlocked tabs + one "teaser" locked tab
  const maxVisiblePhase = currentPhase + 1
  const visibleTabs = TABS.filter(t => t.phase <= maxVisiblePhase)

  return (
    <nav
      className="fixed bottom-0 left-0 right-0 z-50 glass-card rounded-none border-t border-x-0 border-b-0 border-white/[0.08]"
      style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}
    >
      <div className="flex justify-around items-center h-16 max-w-lg mx-auto">
        {visibleTabs.map(tab => {
          const isActive = activeTab === tab.id
          const isLocked = tab.phase > currentPhase

          return (
            <button
              key={tab.id}
              onClick={() => !isLocked && onTabChange(tab.id)}
              disabled={isLocked}
              className={`relative flex flex-col items-center gap-0.5 px-3 py-2 transition-all duration-200 bg-transparent border-none
                ${isLocked ? 'opacity-30 cursor-not-allowed' : 'cursor-pointer'}`}
            >
              <span className={`text-xl ${isLocked ? 'grayscale' : ''}`}>
                {tab.icon}
              </span>
              <span className={`text-[0.65rem] font-medium tracking-wide uppercase ${
                isActive ? 'text-accent' : isLocked ? 'text-text-muted' : 'text-text-secondary'
              }`}>
                {isLocked ? '???' : tab.label}
              </span>

              {/* Active indicator */}
              {isActive && (
                <motion.div
                  layoutId="tab-indicator"
                  className="absolute -top-px left-2 right-2 h-0.5 bg-accent rounded-full"
                  style={{ boxShadow: '0 0 8px rgba(255, 102, 0, 0.5)' }}
                  transition={{ type: 'spring', stiffness: 500, damping: 30 }}
                />
              )}

              {/* Lock icon for locked tabs */}
              {isLocked && (
                <span className="absolute -top-1 -right-1 text-[0.5rem]">🔒</span>
              )}
            </button>
          )
        })}
      </div>
    </nav>
  )
}
