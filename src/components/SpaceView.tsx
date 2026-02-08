import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { GlassCard } from './ui/GlassCard'
import { useGameStore } from '../store/gameStore'
import { formatCompact, formatNumber } from '../engine/format'
import {
  LAUNCH_TIERS, LUNAR_BUILDINGS, MARS_UPGRADES, ASTEROID_TIERS,
  PROPAGANDA_SATELLITE, DYSON_PROTOTYPE,
  getNextLaunchTier, getLaunchTierDef, hasLaunchTier,
  MARS_RENAMED_LABELS,
} from '../data/phase4/space'
import { SPACE_WEAPONS } from '../data/phase4/weapons'
import { BRIDGE_UPGRADES } from '../data/phase4/bridgeUpgrades'
import { getDriftLevel } from '../engine/realityDrift'

type SpaceTab = 'overview' | 'launch' | 'moon' | 'mars' | 'asteroids' | 'weapons'

const TABS: { id: SpaceTab; label: string; icon: string }[] = [
  { id: 'overview', label: 'Overview', icon: '🛰️' },
  { id: 'launch', label: 'Launch', icon: '🚀' },
  { id: 'moon', label: 'Moon', icon: '🌙' },
  { id: 'mars', label: 'Mars', icon: '🔴' },
  { id: 'asteroids', label: 'Asteroids', icon: '☄️' },
  { id: 'weapons', label: 'Weapons', icon: '⚔️' },
]

export function SpaceView() {
  const [activeTab, setActiveTab] = useState<SpaceTab>('overview')

  return (
    <div className="flex flex-col gap-4 max-w-2xl mx-auto">
      {/* Sub-tab nav */}
      <div className="flex gap-0.5 p-1 rounded-xl bg-white/5 overflow-x-auto">
        {TABS.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`
              flex-1 flex items-center justify-center gap-1 py-2 px-2 rounded-lg text-[0.65rem] font-medium transition-all cursor-pointer whitespace-nowrap
              ${activeTab === tab.id
                ? 'bg-[#4455CC]/30 text-[#7788FF]'
                : 'text-text-secondary hover:text-text-primary hover:bg-white/5'}
            `}
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
          {activeTab === 'overview' && <SpaceOverview />}
          {activeTab === 'launch' && <LaunchPanel />}
          {activeTab === 'moon' && <LunarPanel />}
          {activeTab === 'mars' && <MarsPanel />}
          {activeTab === 'asteroids' && <AsteroidPanel />}
          {activeTab === 'weapons' && <WeaponsPanel />}
        </motion.div>
      </AnimatePresence>
    </div>
  )
}

// ── Space Overview ──

function SpaceOverview() {
  const rocketMass = useGameStore(s => s.rocketMass)
  const orbitalIndustry = useGameStore(s => s.orbitalIndustry)
  const miningOutput = useGameStore(s => s.miningOutput)
  const colonists = useGameStore(s => s.colonists)
  const terraform = useGameStore(s => s.terraformProgress)
  const drift = useGameStore(s => s.realityDrift)
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const loyalty = useGameStore(s => s.loyalty)
  const purchaseBridgeUpgrade = useGameStore(s => s.purchaseBridgeUpgrade)

  const driftLevel = getDriftLevel(drift)

  return (
    <div className="flex flex-col gap-3">
      {/* Resource summary */}
      <div className="grid grid-cols-2 gap-2">
        <ResourceCard label="Rocket Mass" value={formatNumber(rocketMass)} color="#7788FF" />
        <ResourceCard label="Orbital Industry" value={formatNumber(orbitalIndustry)} color="#55AAFF" />
        <ResourceCard label="Mining Output" value={formatNumber(miningOutput)} color="#FFAA33" />
        <ResourceCard label="Colonists" value={formatCompact(Math.floor(colonists))} color="#33CC66" />
      </div>

      {/* Terraform progress */}
      <GlassCard padding="sm">
        <p className="text-[0.6rem] text-text-muted uppercase tracking-wider mb-1">
          {space.marsRenamed ? 'Orange Planet' : 'Mars'} Terraform
        </p>
        <div className="flex items-center gap-2">
          <div className="flex-1 h-2 rounded-full overflow-hidden bg-white/5">
            <div
              className="h-full rounded-full transition-all duration-500"
              style={{
                width: `${Math.min(100, terraform)}%`,
                background: 'linear-gradient(90deg, #FF6600, #FF3333)',
              }}
            />
          </div>
          <span className="text-xs font-numbers text-[#FF6600]">{terraform.toFixed(1)}%</span>
        </div>
      </GlassCard>

      {/* Reality Drift meter */}
      <GlassCard padding="sm" glow={drift >= 40 ? 'red' : 'none'}>
        <div className="flex justify-between items-center mb-1">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Reality Drift</p>
          <span className="text-[0.6rem] font-medium" style={{
            color: drift >= 60 ? '#FF3333' : drift >= 40 ? '#FFAA33' : drift >= 20 ? '#CCAA33' : '#555',
          }}>
            {driftLevel.name}
          </span>
        </div>
        <div className="flex items-center gap-2">
          <div className="flex-1 h-2 rounded-full overflow-hidden bg-white/5">
            <div
              className="h-full rounded-full transition-all duration-500"
              style={{
                width: `${Math.min(100, drift)}%`,
                background: drift >= 60
                  ? 'linear-gradient(90deg, #FF6600, #FF3333, #FF00FF)'
                  : drift >= 40
                    ? 'linear-gradient(90deg, #FFAA33, #FF6600)'
                    : 'linear-gradient(90deg, #555, #888)',
              }}
            />
          </div>
          <span className="text-xs font-numbers" style={{
            color: drift >= 40 ? '#FF6600' : '#888',
          }}>
            {drift.toFixed(1)}%
          </span>
        </div>
      </GlassCard>

      {/* Bridge Upgrades */}
      <div>
        <p className="text-xs text-text-secondary mb-2 font-medium">Bridge Upgrades</p>
        <div className="flex flex-col gap-2">
          {BRIDGE_UPGRADES.map(def => {
            const owned = space.bridgeUpgrades[def.id]
            const preOwned = !def.prerequisite || space.bridgeUpgrades[def.prerequisite]
            const canAfford = cash >= def.costCash && loyalty >= def.costLoyalty
            return (
              <GlassCard
                key={def.id}
                padding="sm"
                hover={!owned && preOwned}
                glow={owned ? 'green' : undefined}
                className={!preOwned ? 'opacity-50' : ''}
              >
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <p className="text-xs font-medium">{def.name}</p>
                    <p className="text-[0.6rem] text-text-muted mt-0.5">{def.description}</p>
                    <p className="text-[0.55rem] text-[#55AAFF] mt-0.5">{def.effect}</p>
                  </div>
                  {owned ? (
                    <span className="text-[0.6rem] text-[#33CC66] font-medium">Active</span>
                  ) : preOwned ? (
                    <button
                      onClick={() => purchaseBridgeUpgrade(def.id)}
                      disabled={!canAfford}
                      className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                        canAfford
                          ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                          : 'bg-white/5 text-text-muted'
                      }`}
                    >
                      ${formatCompact(def.costCash)}{def.costLoyalty > 0 ? ` +${def.costLoyalty}L` : ''}
                    </button>
                  ) : (
                    <span className="text-[0.6rem] text-text-muted">🔒</span>
                  )}
                </div>
              </GlassCard>
            )
          })}
        </div>
      </div>
    </div>
  )
}

function ResourceCard({ label, value, color }: { label: string; value: string; color: string }) {
  return (
    <GlassCard padding="sm">
      <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">{label}</p>
      <p className="text-lg font-numbers" style={{ color }}>{value}</p>
    </GlassCard>
  )
}

// ── Launch Panel ──

function LaunchPanel() {
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const upgradeLaunchTier = useGameStore(s => s.upgradeLaunchTier)
  const hasCostReduction = space.bridgeUpgrades['reality_budgeting']

  const currentDef = getLaunchTierDef(space.launchTier)
  const nextDef = getNextLaunchTier(space.launchTier)

  return (
    <div className="flex flex-col gap-3">
      {/* Current tier */}
      <GlassCard padding="md" glow={currentDef ? 'orange' : 'none'}>
        <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Current Launch Infrastructure</p>
        {currentDef ? (
          <>
            <p className="text-lg font-medium mt-1">{currentDef.name}</p>
            <p className="text-[0.6rem] text-text-muted mt-1">{currentDef.description}</p>
            <p className="text-xs font-numbers text-[#7788FF] mt-2">
              +{currentDef.rocketMassPerSecond} Rocket Mass/s
            </p>
          </>
        ) : (
          <p className="text-sm text-text-muted mt-1">No launch infrastructure built</p>
        )}
      </GlassCard>

      {/* Next tier */}
      {nextDef && (
        <GlassCard padding="md" hover>
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Next Upgrade</p>
          <p className="text-sm font-medium mt-1">{nextDef.name}</p>
          <p className="text-[0.6rem] text-text-muted mt-1">{nextDef.description}</p>
          <p className="text-xs font-numbers text-[#7788FF] mt-1">
            +{nextDef.rocketMassPerSecond} Rocket Mass/s
          </p>
          <button
            onClick={upgradeLaunchTier}
            disabled={cash < nextDef.costCash * (hasCostReduction ? 0.7 : 1)}
            className={`mt-2 w-full py-2 rounded-lg cursor-pointer border-none text-xs font-medium ${
              cash >= nextDef.costCash * (hasCostReduction ? 0.7 : 1)
                ? 'bg-[#4455CC]/40 text-[#7788FF] hover:bg-[#4455CC]/60'
                : 'bg-white/5 text-text-muted'
            }`}
          >
            ${formatCompact(nextDef.costCash * (hasCostReduction ? 0.7 : 1))}
          </button>
        </GlassCard>
      )}

      {!nextDef && space.launchTier === 'mass_driver' && (
        <GlassCard padding="sm">
          <p className="text-xs text-[#33CC66] text-center">Maximum launch infrastructure reached</p>
        </GlassCard>
      )}

      {/* All tiers list */}
      <div>
        <p className="text-xs text-text-secondary mb-2 font-medium">Infrastructure Tiers</p>
        {LAUNCH_TIERS.map(tier => {
          const isOwned = hasLaunchTier(space.launchTier, tier.id)
          return (
            <div key={tier.id} className={`flex items-center gap-2 py-1.5 ${!isOwned ? 'opacity-40' : ''}`}>
              <span className={`w-2 h-2 rounded-full ${isOwned ? 'bg-[#33CC66]' : 'bg-white/20'}`} />
              <span className="text-xs">{tier.name}</span>
              <span className="text-[0.6rem] text-text-muted ml-auto">+{tier.rocketMassPerSecond}/s</span>
            </div>
          )
        })}
      </div>
    </div>
  )
}

// ── Lunar Panel ──

function LunarPanel() {
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const rocketMass = useGameStore(s => s.rocketMass)
  const buildLunarBuilding = useGameStore(s => s.buildLunarBuilding)
  const hasCostReduction = space.bridgeUpgrades['reality_budgeting']

  const getBoolKey = (id: string) =>
    id === 'moon_base' ? 'moonBase' :
    id === 'he3_mining' ? 'helium3Mining' :
    id === 'lunar_shipyard' ? 'lunarShipyard' :
    id === 'lunar_heritage' ? 'lunarHeritage' : ''

  return (
    <div className="flex flex-col gap-3">
      <p className="text-xs text-text-secondary font-medium">Lunar Infrastructure</p>
      {space.launchTier === 'none' ? (
        <GlassCard padding="sm">
          <p className="text-xs text-text-muted text-center">Build a Launchpad first</p>
        </GlassCard>
      ) : (
        LUNAR_BUILDINGS.map(def => {
          const key = getBoolKey(def.id)
          const isBuilt = key ? (space[key as keyof typeof space] as boolean) : false
          const preKey = def.prerequisite ? getBoolKey(def.prerequisite) : null
          const preMet = !preKey || (space[preKey as keyof typeof space] as boolean)
          const costCash = def.costCash * (hasCostReduction ? 0.7 : 1)
          const canAfford = cash >= costCash && rocketMass >= def.costRocketMass

          return (
            <GlassCard
              key={def.id}
              padding="sm"
              hover={!isBuilt && preMet}
              glow={isBuilt ? 'green' : undefined}
              className={!preMet ? 'opacity-50' : ''}
            >
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <p className="text-xs font-medium">{def.name}</p>
                  <p className="text-[0.6rem] text-text-muted mt-0.5">{def.description}</p>
                  <div className="flex gap-2 mt-1">
                    {def.effects.orbitalIndustryPerSecond && (
                      <span className="text-[0.55rem] text-[#55AAFF]">+{def.effects.orbitalIndustryPerSecond} OI/s</span>
                    )}
                    {def.effects.miningOutputPerSecond && (
                      <span className="text-[0.55rem] text-[#FFAA33]">+{def.effects.miningOutputPerSecond} Mining/s</span>
                    )}
                    {def.effects.legitimacyPerSecond && (
                      <span className="text-[0.55rem] text-[#33CC66]">+{def.effects.legitimacyPerSecond} Legit/s</span>
                    )}
                    {def.effects.shipCostReduction && (
                      <span className="text-[0.55rem] text-[#FFD700]">-{def.effects.shipCostReduction * 100}% ship cost</span>
                    )}
                  </div>
                </div>
                {isBuilt ? (
                  <span className="text-[0.6rem] text-[#33CC66] font-medium">Built</span>
                ) : preMet ? (
                  <button
                    onClick={() => buildLunarBuilding(def.id)}
                    disabled={!canAfford}
                    className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                      canAfford
                        ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                        : 'bg-white/5 text-text-muted'
                    }`}
                  >
                    ${formatCompact(costCash)} + {def.costRocketMass}RM
                  </button>
                ) : (
                  <span className="text-[0.6rem] text-text-muted">🔒</span>
                )}
              </div>
            </GlassCard>
          )
        })
      )}
    </div>
  )
}

// ── Mars Panel ──

function MarsPanel() {
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const rocketMass = useGameStore(s => s.rocketMass)
  const miningOutput = useGameStore(s => s.miningOutput)
  const colonists = useGameStore(s => s.colonists)
  const terraform = useGameStore(s => s.terraformProgress)
  const buildMarsUpgrade = useGameStore(s => s.buildMarsUpgrade)
  const hasCostReduction = space.bridgeUpgrades['reality_budgeting']

  const marsName = space.marsRenamed ? MARS_RENAMED_LABELS['Mars'] || 'The Orange Planet' : 'Mars'

  const getBoolKey = (id: string) =>
    id === 'mars_colony' ? 'marsColony' :
    id === 'atmosphere_processing' ? 'atmosphereProcessing' :
    id === 'water_extraction' ? 'waterExtraction' : ''

  return (
    <div className="flex flex-col gap-3">
      <div className="flex justify-between items-center">
        <p className="text-xs text-text-secondary font-medium">{marsName} Development</p>
        {space.marsRenamed && (
          <span className="text-[0.55rem] text-[#FF6600] bg-[#FF6600]/10 px-2 py-0.5 rounded-full">Renamed</span>
        )}
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 gap-2">
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Colonists</p>
          <p className="text-sm font-numbers text-[#33CC66]">{formatCompact(Math.floor(colonists))}</p>
        </GlassCard>
        <GlassCard padding="sm">
          <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Terraform</p>
          <p className="text-sm font-numbers text-[#FF6600]">{terraform.toFixed(1)}%</p>
        </GlassCard>
      </div>

      {/* Terraform bar */}
      <div className="h-2 rounded-full overflow-hidden bg-white/5">
        <div
          className="h-full rounded-full transition-all duration-500"
          style={{
            width: `${Math.min(100, terraform)}%`,
            background: space.marsRenamed
              ? 'linear-gradient(90deg, #FF6600, #FFD700)'
              : 'linear-gradient(90deg, #FF3333, #FF6600)',
          }}
        />
      </div>

      {space.launchTier === 'none' ? (
        <GlassCard padding="sm">
          <p className="text-xs text-text-muted text-center">Build a Launchpad first</p>
        </GlassCard>
      ) : (
        MARS_UPGRADES.map(def => {
          const key = getBoolKey(def.id)
          const isBuilt = key ? (space[key as keyof typeof space] as boolean) : false
          const preKey = def.prerequisite ? getBoolKey(def.prerequisite) : null
          const preMet = !preKey || (space[preKey as keyof typeof space] as boolean)
          const costCash = def.costCash * (hasCostReduction ? 0.7 : 1)
          const canAfford = cash >= costCash && rocketMass >= def.costRocketMass && miningOutput >= def.costMiningOutput

          const displayName = space.marsRenamed && def.renamedName ? def.renamedName : def.name

          return (
            <GlassCard
              key={def.id}
              padding="sm"
              hover={!isBuilt && preMet}
              glow={isBuilt ? 'green' : undefined}
              className={!preMet ? 'opacity-50' : ''}
            >
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <p className="text-xs font-medium">{displayName}</p>
                  <p className="text-[0.6rem] text-text-muted mt-0.5">{def.description}</p>
                  <div className="flex gap-2 mt-1">
                    {def.effects.colonistsPerSecond && (
                      <span className="text-[0.55rem] text-[#33CC66]">+{def.effects.colonistsPerSecond} col/s</span>
                    )}
                    {def.effects.terraformPerSecond && (
                      <span className="text-[0.55rem] text-[#FF6600]">+{def.effects.terraformPerSecond} tf/s</span>
                    )}
                    {def.effects.greatnessPerSecond && (
                      <span className="text-[0.55rem] text-[#FFD700]">+{def.effects.greatnessPerSecond} GpS</span>
                    )}
                  </div>
                </div>
                {isBuilt ? (
                  <span className="text-[0.6rem] text-[#33CC66] font-medium">Built</span>
                ) : preMet ? (
                  <button
                    onClick={() => buildMarsUpgrade(def.id)}
                    disabled={!canAfford}
                    className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                      canAfford
                        ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                        : 'bg-white/5 text-text-muted'
                    }`}
                  >
                    ${formatCompact(costCash)}
                    {def.costRocketMass > 0 ? ` +${def.costRocketMass}RM` : ''}
                    {def.costMiningOutput > 0 ? ` +${def.costMiningOutput}MO` : ''}
                  </button>
                ) : (
                  <span className="text-[0.6rem] text-text-muted">🔒</span>
                )}
              </div>
            </GlassCard>
          )
        })
      )}
    </div>
  )
}

// ── Asteroid Panel ──

function AsteroidPanel() {
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const rocketMass = useGameStore(s => s.rocketMass)
  const miningOutput = useGameStore(s => s.miningOutput)
  const buildAsteroidUnit = useGameStore(s => s.buildAsteroidUnit)
  const buildSatellite = useGameStore(s => s.buildSatellite)
  const buildDysonPrototype = useGameStore(s => s.buildDysonPrototype)
  const orbitalIndustry = useGameStore(s => s.orbitalIndustry)
  const hasCostReduction = space.bridgeUpgrades['reality_budgeting']

  const getCountKey = (id: string) =>
    id === 'prospector_drones' ? 'asteroidProspectors' :
    id === 'mining_rigs' ? 'asteroidRigs' :
    id === 'refineries' ? 'asteroidRefineries' : ''

  return (
    <div className="flex flex-col gap-3">
      {/* Mining Output summary */}
      <GlassCard padding="sm">
        <p className="text-[0.6rem] text-text-muted uppercase tracking-wider">Total Mining Output</p>
        <p className="text-lg font-numbers text-[#FFAA33]">{formatNumber(miningOutput)}</p>
      </GlassCard>

      {space.launchTier === 'none' ? (
        <GlassCard padding="sm">
          <p className="text-xs text-text-muted text-center">Build a Launchpad first</p>
        </GlassCard>
      ) : (
        <>
          {/* Asteroid tiers */}
          <p className="text-xs text-text-secondary font-medium">Asteroid Mining</p>
          {ASTEROID_TIERS.map(def => {
            const key = getCountKey(def.id)
            const current = key ? (space[key as keyof typeof space] as number) : 0
            const preKey = def.prerequisite ? getCountKey(def.prerequisite) : null
            const preMet = !preKey || (space[preKey as keyof typeof space] as number) > 0
            const costCash = def.costCash * (hasCostReduction ? 0.7 : 1)
            const canAffordOne = cash >= costCash && rocketMass >= def.costRocketMass
            const atMax = current >= def.maxCount

            return (
              <GlassCard
                key={def.id}
                padding="sm"
                hover={preMet && !atMax}
                className={!preMet ? 'opacity-50' : ''}
              >
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <p className="text-xs font-medium">{def.name}</p>
                    <p className="text-[0.6rem] text-text-muted mt-0.5">{def.description}</p>
                    <p className="text-[0.55rem] text-[#FFAA33] mt-0.5">
                      +{def.miningOutputPerUnit} MO/unit | {current}/{def.maxCount}
                    </p>
                  </div>
                  {atMax ? (
                    <span className="text-[0.6rem] text-[#33CC66] font-medium">Max</span>
                  ) : preMet ? (
                    <div className="flex gap-1">
                      <button
                        onClick={() => buildAsteroidUnit(def.id, 1)}
                        disabled={!canAffordOne}
                        className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                          canAffordOne
                            ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                            : 'bg-white/5 text-text-muted'
                        }`}
                      >
                        +1 (${formatCompact(costCash)})
                      </button>
                      {def.maxCount - current >= 5 && (
                        <button
                          onClick={() => buildAsteroidUnit(def.id, 5)}
                          disabled={cash < costCash * 5 || rocketMass < def.costRocketMass * 5}
                          className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                            cash >= costCash * 5 && rocketMass >= def.costRocketMass * 5
                              ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                              : 'bg-white/5 text-text-muted'
                          }`}
                        >
                          +5
                        </button>
                      )}
                    </div>
                  ) : (
                    <span className="text-[0.6rem] text-text-muted">🔒</span>
                  )}
                </div>
              </GlassCard>
            )
          })}

          {/* Propaganda Satellites */}
          <p className="text-xs text-text-secondary font-medium mt-2">Orbital Platforms</p>
          <GlassCard padding="sm" hover>
            <div className="flex justify-between items-start">
              <div className="flex-1">
                <p className="text-xs font-medium">Propaganda Satellite</p>
                <p className="text-[0.6rem] text-text-muted mt-0.5">
                  Broadcasts Greatness from orbit. 24/7. No off switch.
                </p>
                <p className="text-[0.55rem] text-[#7788FF] mt-0.5">
                  +{PROPAGANDA_SATELLITE.legitimacyPerUnit} Legit/s, +{PROPAGANDA_SATELLITE.attentionPerUnit} Att/s | {space.propagandaSatellites}/{PROPAGANDA_SATELLITE.maxCount}
                </p>
              </div>
              {space.propagandaSatellites >= PROPAGANDA_SATELLITE.maxCount ? (
                <span className="text-[0.6rem] text-[#33CC66] font-medium">Max</span>
              ) : (
                <button
                  onClick={buildSatellite}
                  disabled={cash < PROPAGANDA_SATELLITE.costCash * (hasCostReduction ? 0.7 : 1) || orbitalIndustry < PROPAGANDA_SATELLITE.costOrbitalIndustry}
                  className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                    cash >= PROPAGANDA_SATELLITE.costCash * (hasCostReduction ? 0.7 : 1) && orbitalIndustry >= PROPAGANDA_SATELLITE.costOrbitalIndustry
                      ? 'bg-[#4455CC]/30 text-[#7788FF] hover:bg-[#4455CC]/50'
                      : 'bg-white/5 text-text-muted'
                  }`}
                >
                  ${formatCompact(PROPAGANDA_SATELLITE.costCash * (hasCostReduction ? 0.7 : 1))} + {PROPAGANDA_SATELLITE.costOrbitalIndustry}OI
                </button>
              )}
            </div>
          </GlassCard>

          {/* Dyson Swarm Prototype */}
          <GlassCard
            padding="sm"
            hover={space.dysonSwarms === 0}
            glow={space.dysonSwarms > 0 ? 'gold' : undefined}
          >
            <div className="flex justify-between items-start">
              <div className="flex-1">
                <p className="text-xs font-medium">Dyson Swarm Prototype</p>
                <p className="text-[0.6rem] text-text-muted mt-0.5">{DYSON_PROTOTYPE.description}</p>
                <p className="text-[0.55rem] text-[#FFD700] mt-0.5">
                  Requires: Mass Driver + {DYSON_PROTOTYPE.requiresOrbitalIndustry} OI
                </p>
              </div>
              {space.dysonSwarms > 0 ? (
                <span className="text-[0.6rem] text-[#FFD700] font-medium">Active</span>
              ) : (
                <button
                  onClick={buildDysonPrototype}
                  disabled={
                    !hasLaunchTier(space.launchTier, DYSON_PROTOTYPE.requiresLaunchTier) ||
                    orbitalIndustry < DYSON_PROTOTYPE.requiresOrbitalIndustry ||
                    cash < DYSON_PROTOTYPE.costCash * (hasCostReduction ? 0.7 : 1)
                  }
                  className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                    hasLaunchTier(space.launchTier, DYSON_PROTOTYPE.requiresLaunchTier) &&
                    orbitalIndustry >= DYSON_PROTOTYPE.requiresOrbitalIndustry &&
                    cash >= DYSON_PROTOTYPE.costCash * (hasCostReduction ? 0.7 : 1)
                      ? 'bg-[#FFD700]/20 text-[#FFD700] hover:bg-[#FFD700]/30'
                      : 'bg-white/5 text-text-muted'
                  }`}
                >
                  ${formatCompact(DYSON_PROTOTYPE.costCash * (hasCostReduction ? 0.7 : 1))}
                </button>
              )}
            </div>
          </GlassCard>
        </>
      )}
    </div>
  )
}

// ── Weapons Panel ──

function WeaponsPanel() {
  const space = useGameStore(s => s.space)
  const cash = useGameStore(s => s.cash)
  const purchaseSpaceWeapon = useGameStore(s => s.purchaseSpaceWeapon)
  const hasCostReduction = space.bridgeUpgrades['reality_budgeting']

  return (
    <div className="flex flex-col gap-3">
      <p className="text-xs text-text-secondary font-medium">Space Weapons Platform</p>

      {space.launchTier === 'none' ? (
        <GlassCard padding="sm">
          <p className="text-xs text-text-muted text-center">Build a Launchpad first</p>
        </GlassCard>
      ) : (
        SPACE_WEAPONS.map(def => {
          const owned = space.spaceWeapons[def.id]
          const tierMet = hasLaunchTier(space.launchTier, def.requiresLaunchTier)
          const costCash = def.costCash * (hasCostReduction ? 0.7 : 1)
          const canAfford = cash >= costCash

          return (
            <GlassCard
              key={def.id}
              padding="sm"
              hover={!owned && tierMet}
              glow={owned ? 'red' : undefined}
              className={!tierMet ? 'opacity-50' : ''}
            >
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <p className="text-xs font-medium">{def.name}</p>
                  <p className="text-[0.6rem] text-text-muted mt-0.5">{def.description}</p>
                  <div className="flex gap-2 mt-1">
                    <span className="text-[0.55rem] text-[#FF6600]">+{formatCompact(def.warOutput)} War</span>
                    <span className="text-[0.55rem] text-[#FF3333]">+{def.fear} Fear</span>
                    <span className="text-[0.55rem] text-[#CCAA33]">{def.legitimacyImpact} Legit</span>
                  </div>
                  {!tierMet && (
                    <p className="text-[0.5rem] text-text-muted mt-0.5">
                      Requires: {LAUNCH_TIERS.find(t => t.id === def.requiresLaunchTier)?.name}
                    </p>
                  )}
                </div>
                {owned ? (
                  <span className="text-[0.6rem] text-[#FF3333] font-medium">Deployed</span>
                ) : tierMet ? (
                  <button
                    onClick={() => purchaseSpaceWeapon(def.id)}
                    disabled={!canAfford}
                    className={`text-[0.6rem] px-2 py-1 rounded-lg cursor-pointer border-none font-medium ${
                      canAfford
                        ? 'bg-[#FF3333]/20 text-[#FF6666] hover:bg-[#FF3333]/30'
                        : 'bg-white/5 text-text-muted'
                    }`}
                  >
                    ${formatCompact(costCash)}
                  </button>
                ) : (
                  <span className="text-[0.6rem] text-text-muted">🔒</span>
                )}
              </div>
            </GlassCard>
          )
        })
      )}
    </div>
  )
}
