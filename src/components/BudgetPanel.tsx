import { useCallback } from 'react'
import { motion } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { calculateBudgetEffects } from '../engine/formulas'
import { GlassCard } from './ui/GlassCard'
import type { BudgetAllocation } from '../store/types'

// ── Budget Category Definitions ──

interface BudgetCategoryDef {
  key: keyof BudgetAllocation
  name: string
  icon: string
  color: string
  effectLabel: string
  category: 'social' | 'power'
}

const BUDGET_CATEGORIES: BudgetCategoryDef[] = [
  { key: 'healthcare', name: 'Healthcare', icon: '🏥', color: '#33CC66', effectLabel: 'Legitimacy recovery', category: 'social' },
  { key: 'education', name: 'Education', icon: '🎓', color: '#33BBFF', effectLabel: 'Reality drift reduction', category: 'social' },
  { key: 'socialBenefits', name: 'Social Benefits', icon: '🤝', color: '#88CC44', effectLabel: 'Legitimacy recovery', category: 'social' },
  { key: 'infrastructure', name: 'Infrastructure', icon: '🏗️', color: '#CCAA33', effectLabel: 'Cash generation', category: 'social' },
  { key: 'military', name: 'Military', icon: '⚔️', color: '#FF6600', effectLabel: 'War output', category: 'power' },
  { key: 'dataCenters', name: 'Data Centers', icon: '🖥️', color: '#FF3333', effectLabel: 'Attention + surveillance', category: 'power' },
  { key: 'propagandaBureau', name: 'Propaganda Bureau', icon: '📡', color: '#CC5200', effectLabel: 'Legitimacy generation', category: 'power' },
  { key: 'spaceProgram', name: 'Space Program', icon: '🚀', color: '#8855FF', effectLabel: 'Space research speed', category: 'power' },
]

export function BudgetPanel() {
  const budget = useGameStore(s => s.budget)
  const setBudget = useGameStore(s => s.setBudget)
  const budgetEffects = useGameStore(s => calculateBudgetEffects(s))

  const totalAllocated = Object.values(budget).reduce((sum, v) => sum + v, 0)

  // Adjust other sliders when one changes to keep total at 100
  const handleSliderChange = useCallback((key: keyof BudgetAllocation, newValue: number) => {
    const oldValue = budget[key]
    const diff = newValue - oldValue

    if (diff === 0) return

    // Get other keys and their current values
    const otherKeys = BUDGET_CATEGORIES.map(c => c.key).filter(k => k !== key)
    const otherTotal = otherKeys.reduce((sum, k) => sum + budget[k], 0)

    if (otherTotal === 0 && diff > 0) return // Can't take from others if they're all 0

    // Distribute the difference proportionally among others
    const updates: Partial<BudgetAllocation> = { [key]: newValue }
    let remaining = -diff

    for (let i = 0; i < otherKeys.length; i++) {
      const k = otherKeys[i]
      const proportion = otherTotal > 0 ? budget[k] / otherTotal : 1 / otherKeys.length
      let adjustment: number

      if (i === otherKeys.length - 1) {
        // Last one gets the remainder to avoid rounding issues
        adjustment = remaining
      } else {
        adjustment = Math.round(proportion * (-diff))
        remaining -= adjustment
      }

      const adjusted = Math.max(0, Math.min(100, budget[k] + adjustment))
      updates[k] = adjusted
    }

    setBudget(updates)
  }, [budget, setBudget])

  const socialTotal = BUDGET_CATEGORIES
    .filter(c => c.category === 'social')
    .reduce((sum, c) => sum + budget[c.key], 0)

  const powerTotal = BUDGET_CATEGORIES
    .filter(c => c.category === 'power')
    .reduce((sum, c) => sum + budget[c.key], 0)

  const austerityCrisis = budget.healthcare < 10 && budget.education < 10 && budget.socialBenefits < 10

  return (
    <div className="flex flex-col gap-4 max-w-lg mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-medium text-text-primary">National Budget</h2>
        <span className="text-xs font-numbers text-text-muted">
          {totalAllocated.toFixed(0)}% allocated
        </span>
      </div>

      {/* Summary bar */}
      <div className="w-full h-3 rounded-full overflow-hidden bg-white/5 flex">
        <div
          className="h-full transition-all duration-300"
          style={{ width: `${socialTotal}%`, background: 'linear-gradient(90deg, #33CC66, #88CC44)' }}
        />
        <div
          className="h-full transition-all duration-300"
          style={{ width: `${powerTotal}%`, background: 'linear-gradient(90deg, #FF6600, #FF3333)' }}
        />
      </div>
      <div className="flex justify-between text-[0.55rem] text-text-muted">
        <span>Social: {socialTotal}%</span>
        <span>Power: {powerTotal}%</span>
      </div>

      {/* Austerity warning */}
      {austerityCrisis && (
        <motion.div
          className="p-2 rounded-lg border border-danger/30 bg-danger/5"
          animate={{ opacity: [1, 0.5, 1] }}
          transition={{ duration: 1.5, repeat: Infinity }}
        >
          <p className="text-xs text-danger font-medium">AUSTERITY CRISIS</p>
          <p className="text-[0.6rem] text-danger/70">Healthcare, Education, and Social Benefits all below 10%</p>
        </motion.div>
      )}

      {/* Category Sliders */}
      <div className="flex flex-col gap-3">
        {BUDGET_CATEGORIES.map((cat, i) => (
          <BudgetSlider
            key={cat.key}
            def={cat}
            value={budget[cat.key]}
            effectValue={getEffectValue(cat.key, budgetEffects)}
            index={i}
            onChange={(v) => handleSliderChange(cat.key, v)}
          />
        ))}
      </div>
    </div>
  )
}

// ── Single Budget Slider ──

interface BudgetSliderProps {
  def: BudgetCategoryDef
  value: number
  effectValue: number
  index: number
  onChange: (value: number) => void
}

function BudgetSlider({ def, value, effectValue, index, onChange }: BudgetSliderProps) {
  const isDefunded = value < 10 && def.category === 'social'

  return (
    <motion.div
      initial={{ opacity: 0, x: -8 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: index * 0.03 }}
    >
      <GlassCard padding="sm" className={isDefunded ? 'border-danger/20' : ''}>
        <div className="flex items-center gap-2 mb-1.5">
          <span className="text-base">{def.icon}</span>
          <div className="flex-1 min-w-0">
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-text-primary">{def.name}</span>
              <span className="text-xs font-numbers font-medium" style={{ color: def.color }}>
                {value}%
              </span>
            </div>
            <span className="text-[0.5rem] text-text-muted">
              {def.effectLabel}: {effectValue > 0 ? '+' : ''}{effectValue.toFixed(3)}/s
            </span>
          </div>
        </div>

        {/* Slider */}
        <div className="relative">
          <input
            type="range"
            min={0}
            max={50}
            value={value}
            onChange={(e) => onChange(Number(e.target.value))}
            className="w-full h-2 rounded-full appearance-none cursor-pointer"
            style={{
              background: `linear-gradient(to right, ${def.color} ${value * 2}%, rgba(255,255,255,0.05) ${value * 2}%)`,
            }}
          />
        </div>
      </GlassCard>
    </motion.div>
  )
}

// ── Helpers ──

function getEffectValue(key: keyof BudgetAllocation, effects: ReturnType<typeof calculateBudgetEffects>): number {
  const map: Record<keyof BudgetAllocation, number> = {
    healthcare: effects.healthcareBonus,
    education: effects.educationBonus,
    socialBenefits: effects.socialBonus,
    military: effects.militaryBonus,
    dataCenters: effects.datacenterBonus,
    infrastructure: effects.infraBonus,
    propagandaBureau: effects.propagandaBonus,
    spaceProgram: effects.spaceBonus,
  }
  return map[key]
}
