import { useMemo } from 'react'
import { useGameStore } from '../store/gameStore'
import { PHASE1_EVENTS } from '../data/phase1/events'

const ALL_EVENTS = [...PHASE1_EVENTS]

export function Ticker() {
  const eventHistory = useGameStore(s => s.eventHistory)

  const headlines = useMemo(() => {
    if (eventHistory.length === 0) return []
    // Get the last 5 resolved event headlines
    const recent = eventHistory.slice(-5)
    return recent
      .map(id => ALL_EVENTS.find(e => e.id === id)?.headline)
      .filter(Boolean) as string[]
  }, [eventHistory])

  if (headlines.length === 0) return null

  const tickerText = headlines
    .map((h, i) => (i === headlines.length - 1 ? `BREAKING: ${h}` : h))
    .join('  ///  ')

  return (
    <div className="w-full overflow-hidden relative h-8 flex-shrink-0"
      style={{
        background: 'linear-gradient(90deg, rgba(255, 102, 0, 0.15) 0%, rgba(255, 51, 51, 0.1) 50%, rgba(255, 102, 0, 0.15) 100%)',
        borderTop: '1px solid rgba(255, 102, 0, 0.2)',
        borderBottom: '1px solid rgba(255, 102, 0, 0.2)',
      }}
    >
      <div className="absolute inset-0 flex items-center animate-ticker whitespace-nowrap">
        <span className="text-[0.8rem] text-text-primary/90 tracking-wide px-4">
          {tickerText}
        </span>
        <span className="text-[0.8rem] text-text-primary/90 tracking-wide px-4">
          {tickerText}
        </span>
      </div>
    </div>
  )
}
