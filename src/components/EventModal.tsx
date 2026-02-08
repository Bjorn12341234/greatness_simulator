import { useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import type { GameEvent } from '../store/types'
import { playEvent } from '../engine/audio'

const CATEGORY_COLORS: Record<string, string> = {
  scandal: '#FF3333',
  opportunity: '#33CC66',
  contradiction: '#FFD700',
  absurd: '#FF8833',
  crisis: '#FF3333',
  nobel: '#FFD700',
  reality_glitch: '#8833FF',
}

const CATEGORY_LABELS: Record<string, string> = {
  scandal: 'SCANDAL',
  opportunity: 'OPPORTUNITY',
  contradiction: 'CONTRADICTION',
  absurd: 'BIZARRE',
  crisis: 'CRISIS',
  nobel: 'NOBEL COMMITTEE',
  reality_glitch: 'GLITCH',
}

export function EventModal() {
  const activeEvent = useGameStore(s => s.activeEvent)
  const resolveEvent = useGameStore(s => s.resolveEvent)

  return (
    <AnimatePresence>
      {activeEvent && (
        <EventModalContent
          event={activeEvent}
          onChoice={resolveEvent}
        />
      )}
    </AnimatePresence>
  )
}

function EventModalContent({
  event,
  onChoice,
}: {
  event: GameEvent
  onChoice: (index: number) => void
}) {
  useEffect(() => {
    playEvent()
  }, [])

  const color = CATEGORY_COLORS[event.category] ?? '#FF6600'
  const label = CATEGORY_LABELS[event.category] ?? 'EVENT'

  return (
    <>
      {/* Backdrop */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 z-[100] bg-black/70 backdrop-blur-sm"
      />

      {/* Modal */}
      <motion.div
        initial={{ opacity: 0, scale: 0.85, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.9, y: 10 }}
        transition={{ type: 'spring', stiffness: 400, damping: 30 }}
        className="fixed inset-0 z-[101] flex items-center justify-center p-4"
      >
        <div className="glass-card p-6 max-w-md w-full mx-auto"
          style={{
            borderColor: `${color}33`,
            boxShadow: `0 0 40px ${color}22, 0 4px 24px rgba(0,0,0,0.5)`,
          }}
        >
          {/* Category badge */}
          <div className="mb-4">
            <span
              className="text-[0.6rem] font-bold uppercase tracking-[0.15em] px-2 py-1 rounded"
              style={{
                color,
                background: `${color}15`,
                border: `1px solid ${color}30`,
              }}
            >
              {label}
            </span>
          </div>

          {/* Headline */}
          <h2 className="text-xl font-bold text-text-primary leading-tight mb-2">
            {event.headline}
          </h2>

          {/* Context */}
          <p className="text-sm text-text-secondary leading-relaxed mb-6">
            {event.context}
          </p>

          {/* Choices */}
          <div className="flex flex-col gap-2.5">
            {event.choices.map((choice, i) => (
              <button
                key={i}
                onClick={() => onChoice(i)}
                className="w-full text-left p-3 rounded-lg border cursor-pointer
                           transition-all duration-150 hover:brightness-110
                           bg-white/[0.03] border-white/10 hover:border-white/20"
              >
                <span className="text-sm font-medium text-text-primary">
                  {choice.label}
                </span>
                {choice.description && (
                  <p className="text-[0.65rem] text-text-muted mt-0.5">
                    {choice.description}
                  </p>
                )}
              </button>
            ))}
          </div>
        </div>
      </motion.div>
    </>
  )
}
