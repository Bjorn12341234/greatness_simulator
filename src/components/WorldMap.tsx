import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { COUNTRIES, AZURE_STATE, getTacticsForCountry, type CountryDef, type TacticDef } from '../data/phase3/countries'
import { GlassCard } from './ui/GlassCard'
import { formatCompact, formatDuration } from '../engine/format'
import type { CountryStatus, CountryState } from '../store/types'

// ── Status config ──
const STATUS_CONFIG: Record<CountryStatus, { color: string; label: string }> = {
  independent: { color: '#888888', label: 'Independent' },
  sanctioned: { color: '#CCAA33', label: 'Sanctioned' },
  infiltrated: { color: '#FF8833', label: 'Infiltrated' },
  coup_target: { color: '#FF6600', label: 'Coup Target' },
  occupied: { color: '#FF3333', label: 'Occupied' },
  annexed: { color: '#33CC66', label: 'Annexed' },
  allied: { color: '#33BBFF', label: 'Allied' },
}

const REGION_ORDER = [
  'Northern Europe', 'Western Europe', 'Atlantic',
  'North America', 'Central America', 'South America',
  'Middle East', 'Sub-Saharan Africa',
  'East Asia', 'South Asia', 'Pacific',
  'Eurasia', 'Arctic',
]

export function WorldMap() {
  const countries = useGameStore(s => s.countries)
  const cash = useGameStore(s => s.cash)
  const loyalty = useGameStore(s => s.loyalty)
  const warOutput = useGameStore(s => s.warOutput)
  const fear = useGameStore(s => s.fear)
  const nobelScore = useGameStore(s => s.nobelScore)
  const startTactic = useGameStore(s => s.startCountryTactic)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [showAzure, setShowAzure] = useState(false)

  const annexedCount = Object.values(countries).filter(
    c => c.status === 'annexed' || c.status === 'allied'
  ).length
  const totalCountries = COUNTRIES.length

  // Group by region
  const sortedCountries = [...COUNTRIES].sort(
    (a, b) => REGION_ORDER.indexOf(a.region) - REGION_ORDER.indexOf(b.region)
  )

  return (
    <div className="flex flex-col gap-4 max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">World Greatening</h2>
        <span className="text-sm font-numbers text-text-secondary">
          {annexedCount}/{totalCountries} under Accord
        </span>
      </div>

      {/* Global Progress */}
      <div className="w-full h-2 rounded-full overflow-hidden bg-white/5">
        <motion.div
          className="h-full rounded-full"
          initial={false}
          animate={{ width: `${(annexedCount / totalCountries) * 100}%` }}
          style={{ background: 'linear-gradient(90deg, #FF6600, #33CC66)' }}
          transition={{ duration: 0.5, ease: 'easeOut' }}
        />
      </div>

      {/* Resource Summary */}
      <div className="grid grid-cols-3 gap-2">
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">War Output</p>
          <p className="text-sm font-numbers text-text-primary">{formatCompact(warOutput)}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Fear</p>
          <p className="text-sm font-numbers" style={{ color: fear > 50 ? '#FF3333' : '#FF8833' }}>
            {fear.toFixed(0)}
          </p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Nobel Score</p>
          <p className="text-sm font-numbers" style={{ color: '#FFD700' }}>
            {nobelScore.toFixed(0)}
          </p>
        </GlassCard>
      </div>

      {/* Azure State Special Section */}
      {countries['azure_state'] && (
        <AzureStateCard
          state={countries['azure_state']}
          isExpanded={showAzure}
          cash={cash}
          loyalty={loyalty}
          warOutput={warOutput}
          onToggle={() => setShowAzure(!showAzure)}
          onTactic={(type) => startTactic('azure_state', type)}
        />
      )}

      {/* Country Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {sortedCountries.map((def, index) => (
          <CountryCard
            key={def.id}
            def={def}
            state={countries[def.id]}
            index={index}
            isSelected={selectedId === def.id}
            cash={cash}
            loyalty={loyalty}
            warOutput={warOutput}
            onSelect={() => setSelectedId(selectedId === def.id ? null : def.id)}
            onTactic={(type) => startTactic(def.id, type)}
          />
        ))}
      </div>
    </div>
  )
}

// ── Azure State Card ──

function AzureStateCard({ state, isExpanded, cash, loyalty, warOutput, onToggle, onTactic }: {
  state: CountryState
  isExpanded: boolean
  cash: number
  loyalty: number
  warOutput: number
  onToggle: () => void
  onTactic: (type: string) => void
}) {
  const tactics = getTacticsForCountry('azure_state').filter(t => t.availableFor?.includes('azure_state'))

  return (
    <GlassCard
      padding="sm"
      className="cursor-pointer"
      style={{
        borderColor: 'rgba(51, 153, 255, 0.3)',
        boxShadow: '0 0 20px rgba(51, 153, 255, 0.1)',
      }}
      onClick={onToggle}
    >
      <div className="flex items-center gap-2 mb-2">
        <span className="text-xl">{AZURE_STATE.icon}</span>
        <div className="flex-1">
          <p className="text-sm font-medium text-text-primary">{AZURE_STATE.name}</p>
          <p className="text-[0.6rem] text-text-muted">{AZURE_STATE.description}</p>
        </div>
        <span className="text-[0.6rem] uppercase tracking-wider font-medium text-[#33BBFF]">
          {state.status === 'allied' ? 'Special Ally' : 'Absorbed'}
        </span>
      </div>

      {/* Kompromat Meter */}
      <div className="mb-2">
        <div className="flex justify-between mb-0.5">
          <span className="text-[0.55rem] text-text-muted">Kompromat Leverage</span>
          <span className="text-[0.55rem] font-numbers" style={{
            color: state.kompromatLevel > 50 ? '#FF3333' : state.kompromatLevel > 20 ? '#CCAA33' : '#33CC66',
          }}>
            {state.kompromatLevel.toFixed(0)}%
          </span>
        </div>
        <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5">
          <div
            className="h-full rounded-full transition-all duration-500"
            style={{
              width: `${state.kompromatLevel}%`,
              background: state.kompromatLevel > 50
                ? 'linear-gradient(90deg, #FF6600, #FF3333)'
                : 'linear-gradient(90deg, #33CC66, #CCAA33)',
            }}
          />
        </div>
      </div>

      {/* Aid sent per second */}
      <div className="flex items-center justify-between text-[0.55rem] text-text-muted mb-2">
        <span>Aid Sent: ${formatCompact(AZURE_STATE.aidPerSecond)}/s</span>
        <span>Intel Bonus: +{AZURE_STATE.intelligenceShared}% Surveillance</span>
      </div>

      {/* Active ops */}
      {state.activeOperations.length > 0 && (
        <div className="flex flex-col gap-1 mb-2">
          {state.activeOperations.map((op, i) => (
            <OperationProgress key={i} op={op} />
          ))}
        </div>
      )}

      {/* Tactic buttons */}
      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
            className="overflow-hidden"
          >
            <div className="flex flex-col gap-1.5 mt-2 pt-2 border-t border-white/5">
              {tactics.map(tactic => (
                <TacticButton
                  key={tactic.type}
                  tactic={tactic}
                  canAfford={cash >= tactic.costCash && loyalty >= tactic.costLoyalty && warOutput >= tactic.costWarOutput}
                  onClick={() => onTactic(tactic.type)}
                />
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </GlassCard>
  )
}

// ── Country Card ──

interface CountryCardProps {
  def: CountryDef
  state: CountryState | undefined
  index: number
  isSelected: boolean
  cash: number
  loyalty: number
  warOutput: number
  onSelect: () => void
  onTactic: (type: string) => void
}

function CountryCard({ def, state, index, isSelected, cash, loyalty, warOutput, onSelect, onTactic }: CountryCardProps) {
  if (!state) return null

  const statusConfig = STATUS_CONFIG[state.status]
  const isAnnexed = state.status === 'annexed' || state.status === 'allied'
  const hasOps = state.activeOperations.length > 0
  const borderColor = isAnnexed ? statusConfig.color : hasOps ? '#FF8833' : 'transparent'

  const tactics = getTacticsForCountry(def.id)
  const availableTactics = tactics.filter(t => {
    if (isAnnexed) return false
    if (t.type === 'annexation' && state.resistance > 0) return false
    return true
  })

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.03 }}
    >
      <GlassCard
        padding="sm"
        className="cursor-pointer"
        style={{
          borderColor: `${borderColor}40`,
          boxShadow: isAnnexed ? `0 0 16px ${borderColor}20` : undefined,
        }}
        onClick={onSelect}
      >
        {/* Header */}
        <div className="flex items-center gap-2 mb-2">
          <span className="text-lg">{def.icon}</span>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-medium text-text-primary truncate">{def.name}</p>
            <p className="text-[0.55rem] text-text-muted truncate">{def.region}</p>
          </div>
          <div
            className="w-2 h-2 rounded-full flex-shrink-0"
            style={{ backgroundColor: statusConfig.color }}
          />
        </div>

        {/* Status */}
        <div className="flex items-center justify-between mb-2">
          <span
            className="text-[0.6rem] uppercase tracking-wider font-medium"
            style={{ color: statusConfig.color }}
          >
            {statusConfig.label}
          </span>
          {isAnnexed && (
            <span className="text-[0.55rem] text-text-muted font-numbers">
              +{def.greatnessPotential} GpS
            </span>
          )}
        </div>

        {/* Description */}
        <p className="text-[0.55rem] text-text-muted mb-2 leading-relaxed">{def.description}</p>

        {/* Resistance + Stability bars */}
        {!isAnnexed && (
          <div className="space-y-1.5 mb-2">
            <StatBar label="Resistance" value={state.resistance} max={100}
              color={state.resistance > 60 ? '#FF3333' : state.resistance > 30 ? '#CCAA33' : '#33CC66'} />
            <StatBar label="Stability" value={state.stability} max={100}
              color={state.stability > 60 ? '#33CC66' : state.stability > 30 ? '#CCAA33' : '#FF3333'} />
          </div>
        )}

        {/* Special mechanic indicators */}
        {def.specialMechanic && !isAnnexed && (
          <SpecialMechanicBadge def={def} state={state} />
        )}

        {/* Active operations */}
        {hasOps && (
          <div className="flex flex-col gap-1 mb-2">
            {state.activeOperations.map((op, i) => (
              <OperationProgress key={i} op={op} />
            ))}
          </div>
        )}

        {/* Tactic buttons */}
        <AnimatePresence>
          {isSelected && !isAnnexed && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="overflow-hidden"
            >
              <div className="flex flex-col gap-1.5 mt-2 pt-2 border-t border-white/5">
                {availableTactics.map(tactic => (
                  <TacticButton
                    key={tactic.type}
                    tactic={tactic}
                    canAfford={cash >= tactic.costCash && loyalty >= tactic.costLoyalty && warOutput >= tactic.costWarOutput}
                    onClick={() => onTactic(tactic.type)}
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

// ── Stat Bar ──

function StatBar({ label, value, max, color }: { label: string; value: number; max: number; color: string }) {
  return (
    <div>
      <div className="flex justify-between mb-0.5">
        <span className="text-[0.55rem] text-text-muted">{label}</span>
        <span className="text-[0.55rem] text-text-muted font-numbers">{value.toFixed(0)}%</span>
      </div>
      <div className="w-full h-1.5 rounded-full overflow-hidden bg-white/5">
        <div
          className="h-full rounded-full transition-all duration-500"
          style={{ width: `${(value / max) * 100}%`, backgroundColor: color }}
        />
      </div>
    </div>
  )
}

// ── Special Mechanic Badge ──

function SpecialMechanicBadge({ def, state }: { def: CountryDef; state: CountryState }) {
  const mechanic = def.specialMechanic
  if (!mechanic) return null

  let info = ''
  let value: number | null = null

  switch (mechanic) {
    case 'encirclement':
      info = 'Encirclement'
      value = state.encirclement
      break
    case 'trade_dependency':
      info = 'Trade Dependency'
      value = state.tradeDependency
      break
    case 'purchase_offer':
      info = `Purchase Offers: ${state.purchaseOffers}/5`
      break
    case 'regime_change':
      info = 'Regime Change Target'
      break
    case 'canal_leverage':
      info = 'Strategic Waterway'
      break
    case 'refugee_source':
      info = 'Refugee Source'
      break
    case 'refugee_target':
      info = 'Refugee Destination'
      break
    default:
      info = def.specialDescription ?? ''
  }

  return (
    <div className="mb-2 p-1.5 rounded bg-white/5">
      <div className="flex items-center justify-between">
        <span className="text-[0.55rem] text-[#FF8833] font-medium">{info}</span>
        {value !== null && (
          <span className="text-[0.55rem] font-numbers text-text-secondary">{value.toFixed(0)}%</span>
        )}
      </div>
      {value !== null && (
        <div className="w-full h-1 rounded-full overflow-hidden bg-white/5 mt-1">
          <div
            className="h-full rounded-full transition-all duration-500"
            style={{ width: `${value}%`, backgroundColor: '#FF8833' }}
          />
        </div>
      )}
    </div>
  )
}

// ── Operation Progress ──

function OperationProgress({ op }: { op: import('../store/types').ActiveOperation }) {
  const elapsed = (Date.now() - op.startedAt) / 1000
  const progress = Math.min(100, (elapsed / op.duration) * 100)
  const remaining = Math.max(0, op.duration - elapsed)
  const tacticName = op.tacticType.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())

  return (
    <div className="p-1.5 rounded bg-white/5">
      <div className="flex items-center justify-between mb-0.5">
        <span className="text-[0.55rem] text-[#FF8833] font-medium">{tacticName}</span>
        <span className="text-[0.5rem] text-text-muted font-numbers">{formatDuration(remaining)}</span>
      </div>
      <div className="w-full h-1 rounded-full overflow-hidden bg-white/5">
        <motion.div
          className="h-full rounded-full bg-[#FF8833]"
          initial={{ width: 0 }}
          animate={{ width: `${progress}%` }}
          transition={{ duration: 0.3 }}
        />
      </div>
    </div>
  )
}

// ── Tactic Button ──

function TacticButton({ tactic, canAfford, onClick }: {
  tactic: TacticDef
  canAfford: boolean
  onClick: () => void
}) {
  const costs: string[] = []
  if (tactic.costCash > 0) costs.push(`$${formatCompact(tactic.costCash)}`)
  if (tactic.costLoyalty > 0) costs.push(`${tactic.costLoyalty} Loy`)
  if (tactic.costWarOutput > 0) costs.push(`${tactic.costWarOutput} War`)

  const impactColor = tactic.nobelImpact >= 0 ? '#33CC66' : '#FF3333'

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
      <div className="flex flex-col flex-1 min-w-0">
        <span className="text-xs font-medium text-text-primary">{tactic.name}</span>
        <span className="text-[0.55rem] text-text-muted leading-tight">{tactic.description}</span>
        <span className="text-[0.5rem] text-text-muted italic mt-0.5">"{tactic.flavorText}"</span>
      </div>
      <div className="flex flex-col items-end flex-shrink-0 ml-2">
        {costs.length > 0 && (
          <span className="text-[0.55rem] font-numbers text-text-secondary">
            {costs.join(' + ')}
          </span>
        )}
        <div className="flex gap-2">
          {tactic.nobelImpact !== 0 && (
            <span className="text-[0.5rem]" style={{ color: impactColor }}>
              {tactic.nobelImpact > 0 ? '+' : ''}{tactic.nobelImpact} Nobel
            </span>
          )}
          {tactic.fearGenerated > 0 && (
            <span className="text-[0.5rem] text-[#FF8833]">
              +{tactic.fearGenerated} Fear
            </span>
          )}
        </div>
        <span className="text-[0.5rem] text-text-muted font-numbers">
          {formatDuration(tactic.duration)}
        </span>
      </div>
    </button>
  )
}
