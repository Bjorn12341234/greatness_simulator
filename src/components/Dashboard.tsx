import { useGameStore } from '../store/gameStore'
import { useGPS } from '../store/selectors'
import { formatNumber, formatCompact } from '../engine/format'
import { GreatnessMeter } from './GreatnessMeter'
import { LegitimacyMeter } from './LegitimacyMeter'
import { MainButton } from './MainButton'
import { UpgradeList } from './UpgradeList'
import { ContradictionDisplay } from './ContradictionDisplay'
import { GlassCard } from './ui/GlassCard'
import { AnimatedNumber } from './ui/AnimatedNumber'

export function Dashboard() {
  const greatness = useGameStore(s => s.greatness)
  const attention = useGameStore(s => s.attention)
  const cash = useGameStore(s => s.cash)
  const clickCount = useGameStore(s => s.clickCount)
  const attentionPerClick = useGameStore(s => s.attentionPerClick)
  const click = useGameStore(s => s.click)
  const phase = useGameStore(s => s.phase)
  const loyalty = useGameStore(s => s.loyalty)
  const control = useGameStore(s => s.control)
  const gps = useGPS()

  return (
    <div className="flex flex-col items-center gap-6 pt-6 pb-4 max-w-lg mx-auto">
      {/* Greatness Display */}
      <GreatnessMeter greatness={greatness} gps={gps} />

      {/* Legitimacy Meter (Phase 2+) */}
      <LegitimacyMeter />

      {/* Main Click Button (Phase 1 only shows manual button; Phase 2+ shows automated summary) */}
      {phase < 2 ? (
        <div className="my-2">
          <MainButton onClick={click} />
        </div>
      ) : (
        <GlassCard padding="sm" className="w-full opacity-60">
          <div className="flex items-center justify-between">
            <span className="text-text-muted text-xs">Attention Engine</span>
            <span className="text-text-secondary text-xs font-numbers">AUTOMATED</span>
          </div>
        </GlassCard>
      )}

      {/* Resource Stats */}
      <div className={`grid gap-3 w-full ${phase >= 2 ? 'grid-cols-2 sm:grid-cols-4' : 'grid-cols-2'}`}>
        <GlassCard padding="sm">
          <div className="flex flex-col gap-0.5">
            <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">
              Attention
            </span>
            <AnimatedNumber
              value={attention}
              className="text-lg text-text-primary"
            />
            <span className="text-text-muted text-[0.6rem]">
              {phase < 2 ? `+${formatNumber(attentionPerClick)} per click` : 'automated'}
            </span>
          </div>
        </GlassCard>

        <GlassCard padding="sm">
          <div className="flex flex-col gap-0.5">
            <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">
              Cash
            </span>
            <AnimatedNumber
              value={cash}
              className="text-lg text-text-primary"
              format={(n) => `$${formatCompact(n)}`}
            />
            <span className="text-text-muted text-[0.6rem]">
              from ventures
            </span>
          </div>
        </GlassCard>

        {/* Phase 2+ resources */}
        {phase >= 2 && (
          <>
            <GlassCard padding="sm">
              <div className="flex flex-col gap-0.5">
                <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">
                  Loyalty
                </span>
                <AnimatedNumber
                  value={loyalty}
                  className="text-lg text-text-primary"
                />
                <span className="text-text-muted text-[0.6rem]">
                  from institutions
                </span>
              </div>
            </GlassCard>

            <GlassCard padding="sm">
              <div className="flex flex-col gap-0.5">
                <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">
                  Control
                </span>
                <AnimatedNumber
                  value={control}
                  className="text-lg text-text-primary"
                />
                <span className="text-text-muted text-[0.6rem]">
                  institutional
                </span>
              </div>
            </GlassCard>
          </>
        )}
      </div>

      {/* Click Stats (Phase 1 only) */}
      {phase < 2 && (
        <GlassCard padding="sm" className="w-full">
          <div className="flex justify-between items-center">
            <span className="text-text-secondary text-sm">Total Clicks</span>
            <AnimatedNumber
              value={clickCount}
              className="text-sm text-text-primary"
            />
          </div>
        </GlassCard>
      )}

      {/* Contradiction Seesaw */}
      <ContradictionDisplay />

      {/* Upgrades (Phase 1) */}
      {phase < 2 && (
        <div className="w-full mt-2">
          <h2 className="text-sm font-medium text-text-primary mb-3 px-1">Upgrades</h2>
          <UpgradeList />
        </div>
      )}
    </div>
  )
}
