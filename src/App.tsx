import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from './store/gameStore'
import { useGameLoop } from './hooks/useGameLoop'
import { useAutoSave } from './hooks/useAutoSave'
import { useOfflineCalc } from './hooks/useOfflineCalc'
import { useAchievements } from './hooks/useAchievements'
import { useAudioSync } from './hooks/useAudioSync'
import { Dashboard } from './components/Dashboard'
import { ResearchTree } from './components/ResearchTree'
import { ControlDashboard } from './components/ControlDashboard'
import { PhaseTransition } from './components/PhaseTransition'
import { AchievementToastManager, useAchievementToasts } from './components/AchievementToast'
import { AchievementPanel } from './components/AchievementPanel'
import { Ticker } from './components/Ticker'
import { EventModal } from './components/EventModal'
import { WorldDashboard } from './components/WorldDashboard'
import { SpaceView } from './components/SpaceView'
import { UniverseView } from './components/UniverseView'
import { EndingSequence } from './components/EndingSequence'
import { PrestigePanel } from './components/PrestigePanel'
import { TabNav, type Tab } from './components/TabNav'
import { useRealityDrift } from './hooks/useRealityDrift'

function App() {
  const [activeTab, setActiveTab] = useState<Tab>('dashboard')
  const [showAchievements, setShowAchievements] = useState(false)
  const [showPrestige, setShowPrestige] = useState(false)
  const currentPhase = useGameStore(state => state.phase)
  const prestigeLevel = useGameStore(state => state.prestigeLevel)
  const pendingTransition = useGameStore(state => state.pendingTransition)
  const completePhaseTransition = useGameStore(state => state.completePhaseTransition)
  const load = useGameStore(state => state.load)

  // Achievement toasts
  const { toasts, showToast, dismissToast } = useAchievementToasts()
  useAchievements(showToast)

  // Load save on mount
  useEffect(() => {
    load()
  }, [load])

  // Start engine hooks
  useGameLoop()
  useAutoSave()
  useOfflineCalc()
  useAudioSync()
  useRealityDrift()

  return (
    <div className="flex flex-col min-h-dvh bg-bg-primary">
      {/* News Ticker */}
      <Ticker />

      {/* Achievement Toasts */}
      <AchievementToastManager toasts={toasts} onDismiss={dismissToast} />

      {/* Event Modal */}
      <EventModal />

      {/* Ending Sequence (Phase 5 endgame) */}
      <EndingSequence />

      {/* Phase Transition Overlay */}
      {pendingTransition && (
        <PhaseTransition
          from={pendingTransition.from}
          to={pendingTransition.to}
          onComplete={completePhaseTransition}
        />
      )}

      {/* Achievement Panel */}
      <AnimatePresence>
        {showAchievements && (
          <AchievementPanel onClose={() => setShowAchievements(false)} />
        )}
      </AnimatePresence>

      {/* Prestige Panel */}
      <AnimatePresence>
        {showPrestige && (
          <PrestigePanel onClose={() => setShowPrestige(false)} />
        )}
      </AnimatePresence>

      {/* Main Content Area */}
      <main className="flex-1 overflow-y-auto pb-20">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.2 }}
            className="p-4"
          >
            {activeTab === 'dashboard' && <Dashboard />}
            {activeTab === 'research' && <ResearchTree />}
            {activeTab === 'control' && <ControlDashboard />}
            {activeTab === 'world' && <WorldDashboard />}
            {activeTab === 'space' && <SpaceView />}
            {activeTab === 'universe' && <UniverseView />}
          </motion.div>
        </AnimatePresence>
      </main>

      {/* Top-right action buttons */}
      <div className="fixed top-12 right-3 z-40 flex flex-col gap-2">
        <button
          onClick={() => setShowAchievements(true)}
          className="w-9 h-9 rounded-full glass-card flex items-center justify-center text-base cursor-pointer border-none hover:scale-110 transition-transform"
          title="Achievements"
        >
          🏆
        </button>
        {(currentPhase >= 2 || prestigeLevel > 0) && (
          <button
            onClick={() => setShowPrestige(true)}
            className="w-9 h-9 rounded-full glass-card flex items-center justify-center text-base cursor-pointer border-none hover:scale-110 transition-transform"
            title="New Game+"
            style={prestigeLevel > 0 ? { boxShadow: '0 0 8px rgba(255, 215, 0, 0.3)' } : {}}
          >
            ♾️
          </button>
        )}
      </div>

      {/* Bottom Tab Navigation */}
      <TabNav
        activeTab={activeTab}
        currentPhase={currentPhase}
        onTabChange={setActiveTab}
      />
    </div>
  )
}

export default App
