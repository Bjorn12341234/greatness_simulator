import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'
import { formatNumber, formatCompact } from '../engine/format'
import { getDriftLevel } from '../engine/realityDrift'
import {
  PROBE_UPGRADES, DYSON_SWARM_TIERS, STAR_BRANDING_TIERS,
  BLACK_HOLE_UPGRADES, NARRATIVE_RESEARCH, TOTAL_REACHABLE_STARS,
} from '../data/phase5/universe'

type UniverseTab = 'overview' | 'probes' | 'harvesters' | 'branding' | 'singularity' | 'narrative'

const TABS: { id: UniverseTab; label: string; icon: string }[] = [
  { id: 'overview', label: 'Overview', icon: '🌌' },
  { id: 'probes', label: 'Probes', icon: '🛸' },
  { id: 'harvesters', label: 'Harvest', icon: '☀️' },
  { id: 'branding', label: 'Branding', icon: '⭐' },
  { id: 'singularity', label: 'Ledger', icon: '🕳️' },
  { id: 'narrative', label: 'Narrative', icon: '👁️' },
]

// ── Accent color for Phase 5: deep violet / cosmic ──
const ACCENT = '#9933FF'
const ACCENT_DIM = 'rgba(153, 51, 255, 0.3)'

export function UniverseView() {
  const [activeTab, setActiveTab] = useState<UniverseTab>('overview')

  return (
    <div className="flex flex-col gap-4">
      {/* Tab buttons */}
      <div className="flex gap-0.5 p-1 rounded-xl bg-white/5">
        {TABS.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex-1 flex items-center justify-center gap-1 py-2 px-2 rounded-lg text-[0.65rem] font-medium cursor-pointer border-none transition-colors
              ${activeTab === tab.id
                ? 'text-[#BB77FF]'
                : 'text-text-secondary hover:text-text-primary hover:bg-white/5'}`}
            style={activeTab === tab.id ? { background: ACCENT_DIM } : undefined}
          >
            <span>{tab.icon}</span>
            {tab.label}
          </button>
        ))}
      </div>

      {/* Tab content */}
      <AnimatePresence mode="wait">
        <motion.div
          key={activeTab}
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -8 }}
          transition={{ duration: 0.15 }}
        >
          {activeTab === 'overview' && <CosmicOverview />}
          {activeTab === 'probes' && <ProbePanel />}
          {activeTab === 'harvesters' && <HarvesterPanel />}
          {activeTab === 'branding' && <StarBrandingPanel />}
          {activeTab === 'singularity' && <SingularityPanel />}
          {activeTab === 'narrative' && <NarrativePanel />}
        </motion.div>
      </AnimatePresence>
    </div>
  )
}

// ── Cosmic Overview ──

function CosmicOverview() {
  const probesLaunched = useGameStore(s => s.probesLaunched)
  const starsConverted = useGameStore(s => s.starsConverted)
  const computronium = useGameStore(s => s.computronium)
  const greatnessUnits = useGameStore(s => s.greatnessUnits)
  const realityDrift = useGameStore(s => s.realityDrift)
  const universeConverted = useGameStore(s => s.universe.universeConverted)
  const driftLevel = getDriftLevel(realityDrift)

  return (
    <div className="flex flex-col gap-3">
      {/* Universe Conversion Progress */}
      <div className="glass-card p-4">
        <div className="text-[0.65rem] uppercase tracking-widest text-text-secondary mb-1">
          Universe Conversion
        </div>
        <div className="flex items-end gap-2 mb-2">
          <span className="text-2xl font-bold font-numbers" style={{ color: ACCENT }}>
            {universeConverted.toFixed(1)}%
          </span>
          <span className="text-xs text-text-secondary mb-1">
            of reachable universe
          </span>
        </div>
        <div className="h-3 rounded-full bg-white/5 overflow-hidden">
          <motion.div
            className="h-full rounded-full"
            style={{
              width: `${universeConverted}%`,
              background: `linear-gradient(90deg, ${ACCENT}, #FF33FF)`,
              boxShadow: universeConverted > 80 ? `0 0 12px ${ACCENT}` : 'none',
            }}
            animate={{ width: `${universeConverted}%` }}
            transition={{ duration: 0.3 }}
          />
        </div>
        <div className="text-[0.6rem] text-text-muted mt-1">
          {formatNumber(starsConverted)} / {formatNumber(TOTAL_REACHABLE_STARS)} stars branded
        </div>
      </div>

      {/* Resource Grid */}
      <div className="grid grid-cols-2 gap-2">
        <ResourceCard
          label="MAGA Replicators"
          value={formatCompact(probesLaunched)}
          icon="🛸"
          color="#33CCFF"
        />
        <ResourceCard
          label="Stars Branded"
          value={formatCompact(starsConverted)}
          icon="⭐"
          color="#FFCC33"
        />
        <ResourceCard
          label="Executive Processing"
          value={formatCompact(computronium)}
          icon="💎"
          color="#33FF99"
        />
        <ResourceCard
          label="Greatness Units"
          value={formatCompact(greatnessUnits)}
          icon="👑"
          color={ACCENT}
        />
      </div>

      {/* Reality Drift */}
      <div className="glass-card p-3">
        <div className="flex justify-between items-center mb-1">
          <span className="text-[0.65rem] uppercase tracking-widest text-text-secondary">
            Reality Drift
          </span>
          <span className="text-xs font-numbers" style={{
            color: realityDrift >= 80 ? '#FF3333' : realityDrift >= 60 ? '#FFAA33' : realityDrift >= 40 ? '#FFCC33' : '#33CC66',
          }}>
            {driftLevel.name}
          </span>
        </div>
        <div className="h-2 rounded-full bg-white/5 overflow-hidden">
          <motion.div
            className="h-full rounded-full"
            style={{
              width: `${realityDrift}%`,
              background: realityDrift >= 80
                ? 'linear-gradient(90deg, #FF3333, #FF0066)'
                : realityDrift >= 60
                  ? 'linear-gradient(90deg, #FFAA33, #FF3333)'
                  : realityDrift >= 40
                    ? 'linear-gradient(90deg, #FFCC33, #FFAA33)'
                    : 'linear-gradient(90deg, #33CC66, #FFCC33)',
            }}
            animate={{ width: `${realityDrift}%` }}
            transition={{ duration: 0.3 }}
          />
        </div>
        <div className="text-[0.6rem] text-text-muted mt-1 font-numbers">
          {realityDrift.toFixed(1)}%
        </div>
      </div>
    </div>
  )
}

function ResourceCard({ label, value, icon, color }: {
  label: string; value: string; icon: string; color: string
}) {
  return (
    <div className="glass-card p-3">
      <div className="flex items-center gap-2 mb-1">
        <span className="text-base">{icon}</span>
        <span className="text-[0.6rem] uppercase tracking-wider text-text-secondary">{label}</span>
      </div>
      <div className="text-lg font-bold font-numbers" style={{ color }}>{value}</div>
    </div>
  )
}

// ── MAGA Replicator Panel ──

function ProbePanel() {
  const universe = useGameStore(s => s.universe)
  const cash = useGameStore(s => s.cash)
  const computronium = useGameStore(s => s.computronium)
  const probesLaunched = useGameStore(s => s.probesLaunched)
  const purchaseProbeUpgrade = useGameStore(s => s.purchaseProbeUpgrade)

  return (
    <div className="flex flex-col gap-3">
      <div className="glass-card p-3">
        <div className="text-sm font-medium mb-1">MAGA Replicators</div>
        <div className="text-[0.7rem] text-text-secondary mb-2">
          "Make All Galaxies American" — self-replicating branding units that spread Greatness exponentially.
        </div>
        <div className="text-lg font-bold font-numbers" style={{ color: '#33CCFF' }}>
          {formatCompact(probesLaunched)} active probes
        </div>
      </div>

      {/* Upgrade nodes */}
      <div className="flex flex-col gap-2">
        {PROBE_UPGRADES.map((def, i) => {
          const purchased = universe.probeUpgrades[def.id]
          const prereqMet = !def.prerequisite || universe.probeUpgrades[def.prerequisite]
          const canAfford = cash >= def.costCash && computronium >= def.costComputronium

          return (
            <UpgradeNode
              key={def.id}
              name={def.name}
              description={def.description}
              costs={[
                def.costCash > 0 ? `$${formatCompact(def.costCash)}` : null,
                def.costComputronium > 0 ? `${formatCompact(def.costComputronium)} EP` : null,
              ].filter(Boolean) as string[]}
              purchased={!!purchased}
              available={prereqMet && !purchased}
              affordable={canAfford && prereqMet && !purchased}
              onPurchase={() => purchaseProbeUpgrade(def.id)}
              showConnector={i > 0}
              accentColor="#33CCFF"
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Solar Greatness Harvester Panel ──

function HarvesterPanel() {
  const universe = useGameStore(s => s.universe)
  const cash = useGameStore(s => s.cash)
  const orbitalIndustry = useGameStore(s => s.orbitalIndustry)
  const computronium = useGameStore(s => s.computronium)
  const dysonSwarms = useGameStore(s => s.space.dysonSwarms)
  const purchaseDysonUpgrade = useGameStore(s => s.purchaseDysonUpgrade)

  return (
    <div className="flex flex-col gap-3">
      <div className="glass-card p-3">
        <div className="text-sm font-medium mb-1">Solar Greatness Harvesters</div>
        <div className="text-[0.7rem] text-text-secondary mb-2">
          Capture entire stellar energy output. The sun is just sitting there doing nothing useful.
        </div>
        <div className="text-lg font-bold font-numbers" style={{ color: '#FFCC33' }}>
          {dysonSwarms} active harvester{dysonSwarms !== 1 ? 's' : ''}
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {DYSON_SWARM_TIERS.map((def, i) => {
          const purchased = universe.dysonUpgrades[def.id]
          const prereqMet = !def.prerequisite || universe.dysonUpgrades[def.prerequisite]
          const canAfford = cash >= def.costCash && orbitalIndustry >= def.costOrbitalIndustry && computronium >= def.costComputronium

          return (
            <UpgradeNode
              key={def.id}
              name={def.name}
              description={def.description}
              costs={[
                `$${formatCompact(def.costCash)}`,
                `${formatCompact(def.costOrbitalIndustry)} OI`,
                def.costComputronium > 0 ? `${formatCompact(def.costComputronium)} EP` : null,
              ].filter(Boolean) as string[]}
              purchased={!!purchased}
              available={prereqMet && !purchased}
              affordable={canAfford && prereqMet && !purchased}
              onPurchase={() => purchaseDysonUpgrade(def.id)}
              showConnector={i > 0}
              accentColor="#FFCC33"
              extraInfo={`+${def.guPerSecond} GU/s`}
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Star Branding Panel ──

function StarBrandingPanel() {
  const universe = useGameStore(s => s.universe)
  const cash = useGameStore(s => s.cash)
  const computronium = useGameStore(s => s.computronium)
  const starsConverted = useGameStore(s => s.starsConverted)
  const purchaseStarBranding = useGameStore(s => s.purchaseStarBranding)

  return (
    <div className="flex flex-col gap-3">
      <div className="glass-card p-3">
        <div className="text-sm font-medium mb-1">Star Branding</div>
        <div className="text-[0.7rem] text-text-secondary mb-2">
          Convert stars into Executive Processing substrate. Each star gets a name and a logo.
        </div>
        <div className="flex items-end gap-3">
          <div>
            <div className="text-[0.6rem] text-text-muted uppercase">Stars Branded</div>
            <div className="text-lg font-bold font-numbers" style={{ color: '#FFAA33' }}>
              {formatNumber(starsConverted)}
            </div>
          </div>
          <div>
            <div className="text-[0.6rem] text-text-muted uppercase">Target</div>
            <div className="text-lg font-bold font-numbers text-text-secondary">
              {formatNumber(TOTAL_REACHABLE_STARS)}
            </div>
          </div>
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {STAR_BRANDING_TIERS.map((def, i) => {
          const purchased = universe.starBrandingUpgrades[def.id]
          const prereqMet = !def.prerequisite || universe.starBrandingUpgrades[def.prerequisite]
          const canAfford = cash >= def.costCash && computronium >= def.costComputronium

          return (
            <UpgradeNode
              key={def.id}
              name={def.name}
              description={def.description}
              costs={[
                `$${formatCompact(def.costCash)}`,
                def.costComputronium > 0 ? `${formatCompact(def.costComputronium)} EP` : null,
              ].filter(Boolean) as string[]}
              purchased={!!purchased}
              available={prereqMet && !purchased}
              affordable={canAfford && prereqMet && !purchased}
              onPurchase={() => purchaseStarBranding(def.id)}
              showConnector={i > 0}
              accentColor="#FFAA33"
              extraInfo={def.conversionRatePerSecond > 0 ? `${def.conversionRatePerSecond}/s conversion` : 'Enables scanning'}
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Golden Ledger Singularity Panel ──

function SingularityPanel() {
  const universe = useGameStore(s => s.universe)
  const cash = useGameStore(s => s.cash)
  const computronium = useGameStore(s => s.computronium)
  const purchaseBlackHole = useGameStore(s => s.purchaseBlackHole)

  return (
    <div className="flex flex-col gap-3">
      <div className="glass-card p-3">
        <div className="text-sm font-medium mb-1">Golden Ledger Singularity</div>
        <div className="text-[0.7rem] text-text-secondary mb-2">
          Where numbers go when they're too big to audit. Black holes as cosmic accounting infrastructure.
        </div>
        <div className="text-lg font-bold font-numbers" style={{ color: '#FF66CC' }}>
          {universe.blackHoles} singularit{universe.blackHoles !== 1 ? 'ies' : 'y'}
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {BLACK_HOLE_UPGRADES.map((def, i) => {
          const purchased = universe.blackHoleUpgrades[def.id]
          const prereqMet = !def.prerequisite || universe.blackHoleUpgrades[def.prerequisite]
          const canAfford = cash >= def.costCash && computronium >= def.costComputronium

          const effects: string[] = []
          if (def.effect.guStorage) effects.push(`+${def.effect.guStorage} GU/s`)
          if (def.effect.legitimacyPerSecond) effects.push(`+${def.effect.legitimacyPerSecond}/s Legit`)
          if (def.effect.driftReduction) effects.push(`-${def.effect.driftReduction}/s Drift`)

          return (
            <UpgradeNode
              key={def.id}
              name={def.name}
              description={def.description}
              costs={[
                `$${formatCompact(def.costCash)}`,
                `${formatCompact(def.costComputronium)} EP`,
              ]}
              purchased={!!purchased}
              available={prereqMet && !purchased}
              affordable={canAfford && prereqMet && !purchased}
              onPurchase={() => purchaseBlackHole(def.id)}
              showConnector={i > 0}
              accentColor="#FF66CC"
              extraInfo={effects.join(', ')}
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Narrative Architecture Panel ──

function NarrativePanel() {
  const universe = useGameStore(s => s.universe)
  const greatnessUnits = useGameStore(s => s.greatnessUnits)
  const purchaseNarrativeResearch = useGameStore(s => s.purchaseNarrativeResearch)

  return (
    <div className="flex flex-col gap-3">
      <div className="glass-card p-3">
        <div className="text-sm font-medium mb-1">Narrative Architecture</div>
        <div className="text-[0.7rem] text-text-secondary mb-2">
          Rebuilding reality to match the press release. The final research tree.
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {NARRATIVE_RESEARCH.map((def, i) => {
          const purchased = universe.narrativeResearch[def.id]
          const prereqMet = !def.prerequisite || universe.narrativeResearch[def.prerequisite]
          const canAfford = greatnessUnits >= def.costGU

          const effects: string[] = []
          if (def.effect.guMultiplier) effects.push(`${def.effect.guMultiplier}x GU`)
          if (def.effect.productionBonus) effects.push(`+${def.effect.productionBonus} GU/s`)
          if (def.effect.driftReduction) effects.push(`Drift -${def.effect.driftReduction}/s`)
          if (def.effect.legitimacyFloor) effects.push(`Legit floor ${def.effect.legitimacyFloor}%`)

          return (
            <UpgradeNode
              key={def.id}
              name={def.name}
              description={def.description}
              costs={[`${formatCompact(def.costGU)} GU`]}
              purchased={!!purchased}
              available={prereqMet && !purchased}
              affordable={canAfford && prereqMet && !purchased}
              onPurchase={() => purchaseNarrativeResearch(def.id)}
              showConnector={i > 0}
              accentColor={ACCENT}
              extraInfo={effects.join(', ')}
            />
          )
        })}
      </div>
    </div>
  )
}

// ── Reusable Upgrade Node Component ──

function UpgradeNode({
  name, description, costs, purchased, available, affordable, onPurchase,
  showConnector, accentColor, extraInfo,
}: {
  name: string
  description: string
  costs: string[]
  purchased: boolean
  available: boolean
  affordable: boolean
  onPurchase: () => void
  showConnector: boolean
  accentColor: string
  extraInfo?: string
}) {
  return (
    <div className="relative">
      {/* Connector line */}
      {showConnector && (
        <div
          className="absolute -top-2 left-6 w-px h-4"
          style={{
            background: purchased
              ? accentColor
              : available
                ? 'rgba(255,255,255,0.15)'
                : 'rgba(255,255,255,0.05)',
          }}
        />
      )}

      <div
        className={`glass-card p-3 transition-all duration-200 ${
          purchased
            ? 'opacity-70'
            : affordable
              ? 'cursor-pointer hover:scale-[1.01]'
              : available
                ? 'opacity-60'
                : 'opacity-30'
        }`}
        style={{
          borderColor: purchased
            ? `${accentColor}44`
            : affordable
              ? `${accentColor}66`
              : undefined,
          boxShadow: affordable ? `0 0 12px ${accentColor}22` : undefined,
        }}
        onClick={() => affordable && onPurchase()}
      >
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-0.5">
              {/* Status dot */}
              <div
                className="w-2 h-2 rounded-full shrink-0"
                style={{
                  background: purchased ? '#33CC66' : affordable ? accentColor : 'rgba(255,255,255,0.2)',
                  boxShadow: purchased ? '0 0 6px #33CC66' : affordable ? `0 0 6px ${accentColor}` : 'none',
                }}
              />
              <span className="text-sm font-medium truncate">{name}</span>
            </div>
            <p className="text-[0.65rem] text-text-secondary leading-tight mb-1">
              {description}
            </p>
            {extraInfo && (
              <div className="text-[0.6rem] font-numbers" style={{ color: accentColor }}>
                {extraInfo}
              </div>
            )}
          </div>

          {/* Cost / Status */}
          <div className="shrink-0 text-right">
            {purchased ? (
              <span className="text-[0.6rem] text-green-400 font-medium">ACTIVE</span>
            ) : (
              <div className="flex flex-col gap-0.5">
                {costs.map((cost, i) => (
                  <span key={i} className="text-[0.6rem] font-numbers text-text-secondary">
                    {cost}
                  </span>
                ))}
                {affordable && (
                  <button
                    className="mt-1 px-2 py-0.5 rounded text-[0.6rem] font-medium border-none cursor-pointer"
                    style={{ background: accentColor, color: '#000' }}
                    onClick={(e) => { e.stopPropagation(); onPurchase() }}
                  >
                    BUILD
                  </button>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
