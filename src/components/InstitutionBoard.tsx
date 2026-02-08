import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { INSTITUTIONS, INSTITUTION_ACTIONS, type InstitutionDef, type InstitutionActionDef } from '../data/phase2/institutions'
import { GlassCard } from './ui/GlassCard'
import { formatCompact } from '../engine/format'
import type { InstitutionStatus } from '../store/types'

// ── Status colors and labels ──
const STATUS_CONFIG: Record<InstitutionStatus, { color: string; label: string; dotColor: string }> = {
  independent: { color: '#888888', label: 'Independent', dotColor: '#888888' },
  'co-opting': { color: '#FF8833', label: 'Co-opting...', dotColor: '#FF8833' },
  replacing: { color: '#FF6600', label: 'Replacing...', dotColor: '#FF6600' },
  purging: { color: '#FF3333', label: 'Purging...', dotColor: '#FF3333' },
  captured: { color: '#33CC66', label: 'Captured', dotColor: '#33CC66' },
  automated: { color: '#33BBFF', label: 'Automated', dotColor: '#33BBFF' },
}

export function InstitutionBoard() {
  const institutions = useGameStore(s => s.institutions)
  const cash = useGameStore(s => s.cash)
  const loyalty = useGameStore(s => s.loyalty)
  const startAction = useGameStore(s => s.startInstitutionAction)
  const [selectedId, setSelectedId] = useState<string | null>(null)

  const capturedCount = Object.values(institutions).filter(
    i => i.status === 'captured' || i.status === 'automated'
  ).length

  return (
    <div className="flex flex-col gap-4 max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">Institutions</h2>
        <span className="text-sm font-numbers text-text-secondary">
          {capturedCount}/13 captured
        </span>
      </div>

      {/* Progress bar */}
      <div className="w-full h-2 rounded-full overflow-hidden bg-white/5">
        <motion.div
          className="h-full rounded-full"
          initial={false}
          animate={{
            width: `${(capturedCount / 13) * 100}%`,
          }}
          style={{
            background: 'linear-gradient(90deg, #FF6600, #33CC66)',
          }}
          transition={{ duration: 0.5, ease: 'easeOut' }}
        />
      </div>

      {/* Institution Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {INSTITUTIONS.map((def, index) => (
          <InstitutionCard
            key={def.id}
            def={def}
            state={institutions[def.id]}
            index={index}
            isSelected={selectedId === def.id}
            cash={cash}
            loyalty={loyalty}
            onSelect={() => setSelectedId(selectedId === def.id ? null : def.id)}
            onAction={(actionType) => {
              startAction(def.id, actionType)
            }}
          />
        ))}
      </div>
    </div>
  )
}

// ── Single Institution Card ──

interface InstitutionCardProps {
  def: InstitutionDef
  state: import('../store/types').InstitutionState | undefined
  index: number
  isSelected: boolean
  cash: number
  loyalty: number
  onSelect: () => void
  onAction: (actionType: string) => void
}

function InstitutionCard({ def, state, index, isSelected, cash, loyalty, onSelect, onAction }: InstitutionCardProps) {
  if (!state) return null

  const statusConfig = STATUS_CONFIG[state.status]
  const isInProgress = state.status === 'co-opting' || state.status === 'replacing' || state.status === 'purging'
  const isCaptured = state.status === 'captured' || state.status === 'automated'
  const borderColor = isCaptured ? statusConfig.color : isInProgress ? statusConfig.color : 'transparent'

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.04 }}
    >
      <GlassCard
        padding="sm"
        className="cursor-pointer"
        style={{
          borderColor: `${borderColor}40`,
          boxShadow: isCaptured ? `0 0 16px ${borderColor}20` : undefined,
        }}
        onClick={onSelect}
      >
        {/* Card header */}
        <div className="flex items-center gap-2 mb-2">
          <span className="text-lg">{def.icon}</span>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-medium text-text-primary truncate">{def.name}</p>
            <p className="text-[0.6rem] text-text-muted truncate">{def.description}</p>
          </div>
          {/* Status dot */}
          <div
            className="w-2 h-2 rounded-full flex-shrink-0"
            style={{ backgroundColor: statusConfig.dotColor }}
          />
        </div>

        {/* Status badge */}
        <div className="flex items-center justify-between mb-2">
          <span
            className="text-[0.6rem] uppercase tracking-wider font-medium"
            style={{ color: statusConfig.color }}
          >
            {statusConfig.label}
          </span>
          {isCaptured && (
            <span className="text-[0.55rem] text-text-muted font-numbers">
              +{def.greatnessOutput * (state.status === 'automated' ? 1.5 : 1)} GpS
            </span>
          )}
        </div>

        {/* Resistance bar (when not captured) */}
        {!isCaptured && (
          <div className="mb-2">
            <div className="flex justify-between mb-0.5">
              <span className="text-[0.55rem] text-text-muted">Resistance</span>
              <span className="text-[0.55rem] text-text-muted font-numbers">{state.resistance.toFixed(0)}%</span>
            </div>
            <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5">
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{
                  width: `${state.resistance}%`,
                  background: state.resistance > 60 ? '#FF3333' : state.resistance > 30 ? '#CCAA33' : '#33CC66',
                }}
              />
            </div>
          </div>
        )}

        {/* Progress bar (during action) */}
        {isInProgress && (
          <div className="mb-2">
            <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5">
              <motion.div
                className="h-full rounded-full"
                style={{ backgroundColor: statusConfig.color }}
                initial={{ width: 0 }}
                animate={{ width: `${state.progress}%` }}
                transition={{ duration: 0.3 }}
              />
            </div>
            <span className="text-[0.5rem] text-text-muted font-numbers">{state.progress.toFixed(0)}%</span>
          </div>
        )}

        {/* Action buttons (expanded) */}
        <AnimatePresence>
          {isSelected && !isInProgress && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="overflow-hidden"
            >
              <div className="flex flex-col gap-1.5 mt-2 pt-2 border-t border-white/5">
                {INSTITUTION_ACTIONS.filter(a => {
                  if (a.requiresCaptured && state.status !== 'captured') return false
                  if (!a.requiresCaptured && isCaptured) return false
                  if (state.status === 'automated') return false
                  return true
                }).map(action => (
                  <ActionButton
                    key={action.type}
                    action={action}
                    canAfford={cash >= action.costCash && loyalty >= action.costLoyalty}
                    onClick={() => onAction(action.type)}
                  />
                ))}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </GlassCard>
    </motion.div>
  )
}

// ── Action Button ──

function ActionButton({ action, canAfford, onClick }: {
  action: InstitutionActionDef
  canAfford: boolean
  onClick: () => void
}) {
  const costs: string[] = []
  if (action.costCash > 0) costs.push(`$${formatCompact(action.costCash)}`)
  if (action.costLoyalty > 0) costs.push(`${action.costLoyalty} Loyalty`)

  return (
    <button
      onClick={(e) => { e.stopPropagation(); onClick() }}
      disabled={!canAfford}
      className={`
        w-full flex items-center justify-between p-2 rounded-lg text-left transition-all
        ${canAfford
          ? 'bg-white/5 hover:bg-white/10 cursor-pointer'
          : 'bg-white/[0.02] opacity-50 cursor-not-allowed'}
      `}
    >
      <div className="flex flex-col">
        <span className="text-xs font-medium text-text-primary">{action.name}</span>
        <span className="text-[0.55rem] text-text-muted">{action.description}</span>
      </div>
      <div className="flex flex-col items-end flex-shrink-0 ml-2">
        {costs.length > 0 && (
          <span className="text-[0.55rem] font-numbers text-text-secondary">
            {costs.join(' + ')}
          </span>
        )}
        <span
          className="text-[0.5rem]"
          style={{
            color: action.legitimacyImpact >= 0 ? '#33CC66' : '#FF3333',
          }}
        >
          {action.legitimacyImpact >= 0 ? '+' : ''}{action.legitimacyImpact} legit
        </span>
      </div>
    </button>
  )
}
