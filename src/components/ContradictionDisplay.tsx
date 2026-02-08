import { useGameStore } from '../store/gameStore'
import { GlassCard } from './ui/GlassCard'

export function ContradictionDisplay() {
  const contradiction = useGameStore(s => s.contradictions.attention_credibility)
  const doublethinkTokens = useGameStore(s => s.doublethinkTokens)

  if (!contradiction?.active) return null

  const { sideA, sideB } = contradiction
  const isBalanced = sideA >= 40 && sideB >= 40

  return (
    <GlassCard padding="sm" className="w-full">
      {/* Header */}
      <div className="flex items-center justify-between mb-3">
        <span className="text-[0.65rem] uppercase tracking-wider text-text-secondary">
          Contradiction: Attention vs Credibility
        </span>
        {doublethinkTokens > 0 && (
          <span className="text-[0.6rem] font-numbers text-nobel-gold">
            {doublethinkTokens} DT
          </span>
        )}
      </div>

      {/* Seesaw visualization */}
      <div className="flex items-center gap-2">
        {/* Attention label */}
        <span className="text-[0.6rem] text-accent w-16 text-right">
          Attention
        </span>

        {/* Bar */}
        <div className="flex-1 h-4 rounded-full overflow-hidden bg-white/5 relative">
          {/* Attention fill (from left) */}
          <div
            className="absolute left-0 top-0 bottom-0 transition-all duration-300 rounded-l-full"
            style={{
              width: `${sideA}%`,
              background: `linear-gradient(90deg, rgba(255, 102, 0, 0.15), rgba(255, 102, 0, ${0.3 + sideA * 0.005}))`,
            }}
          />
          {/* Credibility fill (from right) */}
          <div
            className="absolute right-0 top-0 bottom-0 transition-all duration-300 rounded-r-full"
            style={{
              width: `${sideB}%`,
              background: `linear-gradient(270deg, rgba(51, 204, 102, 0.15), rgba(51, 204, 102, ${0.3 + sideB * 0.005}))`,
            }}
          />
          {/* Balance zone indicator */}
          <div className="absolute left-[40%] right-[40%] top-0 bottom-0 border-x border-dashed border-white/10" />
          {/* Balance glow */}
          {isBalanced && (
            <div
              className="absolute inset-0 rounded-full"
              style={{ boxShadow: 'inset 0 0 12px rgba(255, 215, 0, 0.2)' }}
            />
          )}
        </div>

        {/* Credibility label */}
        <span className="text-[0.6rem] text-success w-16">
          Credibility
        </span>
      </div>

      {/* Values */}
      <div className="flex justify-between mt-1.5 px-[4.5rem]">
        <span className="text-[0.55rem] font-numbers text-text-muted">
          {Math.round(sideA)}%
        </span>
        <span className="text-[0.55rem] font-numbers text-text-muted">
          {Math.round(sideB)}%
        </span>
      </div>

      {/* Status text */}
      {isBalanced && (
        <p className="text-[0.55rem] text-nobel-gold text-center mt-1.5 animate-pulse">
          BALANCED — Earning Doublethink Tokens
        </p>
      )}
      {sideB < 30 && (
        <p className="text-[0.55rem] text-danger text-center mt-1.5">
          LOW CREDIBILITY — Cash generation reduced
        </p>
      )}
    </GlassCard>
  )
}
