import type { GameState } from '../store/types'

export interface AchievementDef {
  id: string
  name: string
  description: string
  icon: string
  phase: number
  check: (state: GameState) => boolean
}

export const ACHIEVEMENTS: AchievementDef[] = [
  // ── Phase 1 Achievements ──
  {
    id: 'first_click',
    name: 'The Beginning',
    description: 'Generate your first attention.',
    icon: '👆',
    phase: 1,
    check: (s) => s.clickCount >= 1,
  },
  {
    id: 'hundred_clicks',
    name: 'Compulsive Clicker',
    description: 'Click 100 times. Your dedication is noted.',
    icon: '🖱️',
    phase: 1,
    check: (s) => s.clickCount >= 100,
  },
  {
    id: 'first_upgrade',
    name: 'Self-Improvement',
    description: 'Purchase your first upgrade.',
    icon: '⬆️',
    phase: 1,
    check: (s) => Object.values(s.upgrades).some(u => u.purchased),
  },
  {
    id: 'all_trees',
    name: 'Diversified Portfolio',
    description: 'Purchase at least one upgrade from every tree.',
    icon: '🌳',
    phase: 1,
    check: (s) => {
      const trees = new Set<string>()
      const treeMap: Record<string, string> = {
        media_social_account: 'Media Presence',
        merch_red_hat: 'Merchandise Empire',
        algo_bots: 'Algorithm Manipulation',
        sci_research_div: 'Early Science',
        ent_bible: 'Entrepreneurship',
      }
      for (const [id, upgrade] of Object.entries(s.upgrades)) {
        if (upgrade.purchased && treeMap[id]) {
          trees.add(treeMap[id])
        }
      }
      return trees.size >= 5
    },
  },
  {
    id: 'neural_backup',
    name: 'Digital Immortality',
    description: 'Complete the Neural Backup. Consciousness is just data.',
    icon: '🧠',
    phase: 1,
    check: (s) => s.upgrades['sci_neural_backup']?.purchased === true,
  },
  // ── Phase 2 Achievements ──
  {
    id: 'hostile_takeover',
    name: 'Hostile Takeover',
    description: 'Capture an institution via Purge. Efficiency above all.',
    icon: '⚡',
    phase: 2,
    check: (s) => s.eventHistory.length > 0 && Object.values(s.institutions).some(i => i.status === 'captured' || i.status === 'automated'),
  },
  {
    id: 'first_institution',
    name: 'Institutional Alignment',
    description: 'Capture your first institution.',
    icon: '🏛️',
    phase: 2,
    check: (s) => Object.values(s.institutions).some(i => i.status === 'captured' || i.status === 'automated'),
  },
  {
    id: 'legitimacy_crisis',
    name: 'Legitimacy Crisis',
    description: 'Drop below 10% Legitimacy and survive.',
    icon: '😰',
    phase: 2,
    check: (s) => s.legitimacy < 10 && s.phase >= 2,
  },
  {
    id: 'deep_state',
    name: 'The Deep State',
    description: 'Automate all 13 institutions. The machine runs itself.',
    icon: '🤖',
    phase: 2,
    check: (s) => {
      const insts = Object.values(s.institutions)
      return insts.length >= 13 && insts.every(i => i.status === 'automated')
    },
  },
  {
    id: 'tariff_man',
    name: 'Tariff Man',
    description: 'Activate all tariff categories simultaneously.',
    icon: '📊',
    phase: 2,
    check: (s) => {
      const tariffs = Object.values(s.tariffs)
      return tariffs.length >= 6 && tariffs.every(t => t.active)
    },
  },
  // ── Phase 3 Achievements ──
  {
    id: 'first_annexation',
    name: 'Manifest Destiny',
    description: 'Annex your first country into the Greatness Accord.',
    icon: '🗺️',
    phase: 3,
    check: (s) => Object.values(s.countries).some(c => c.status === 'annexed'),
  },
  {
    id: 'peacemonger',
    name: 'Peacemonger',
    description: 'Win a Nobel Peace Prize while running active military operations.',
    icon: '🏅',
    phase: 3,
    check: (s) => {
      const atWar = Object.values(s.countries).filter(c => c.status === 'occupied' || c.status === 'coup_target').length
      return s.nobelPrizesWon >= 1 && atWar >= 1
    },
  },
  {
    id: 'golden_fleet',
    name: 'Golden Fleet',
    description: 'Build a Golden Dreadnought. Peak military excess.',
    icon: '👑',
    phase: 3,
    check: (s) => (s.fleet['golden_dreadnought'] ?? 0) >= 1,
  },
  {
    id: 'extraordinary',
    name: 'Extraordinary Measures',
    description: 'Use Extraordinary Rendition. Someone is missing and it\'s your fault.',
    icon: '🕵️',
    phase: 3,
    check: (s) => s.eventHistory.includes('p3_rendition_fallout'),
  },
  {
    id: 'world_accord',
    name: 'The Greatness Accord',
    description: 'All 14 countries under the Accord. Earth is optimized.',
    icon: '🌍',
    phase: 3,
    check: (s) => {
      const countries = Object.entries(s.countries).filter(([id]) => id !== 'azure_state')
      return countries.length >= 14 && countries.every(([, c]) => c.status === 'annexed' || c.status === 'allied')
    },
  },
  {
    id: 'gunboat_diplomacy',
    name: 'Gunboat Diplomacy',
    description: 'Win Nobel Prize with 50+ warships active.',
    icon: '⚓',
    phase: 3,
    check: (s) => {
      const totalShips = Object.values(s.fleet).reduce((sum, n) => sum + n, 0)
      return s.nobelPrizesWon >= 1 && totalShips >= 50
    },
  },
  // ── Phase 4 Achievements ──
  {
    id: 'one_small_step',
    name: 'One Small Step',
    description: 'Build a Moon Base. It has a gift shop.',
    icon: '🌙',
    phase: 4,
    check: (s) => s.space.moonBase,
  },
  {
    id: 'the_orange_planet',
    name: 'The Orange Planet',
    description: 'Mars has been rebranded. Scientists are crying.',
    icon: '🔴',
    phase: 4,
    check: (s) => s.space.marsRenamed,
  },
  {
    id: 'space_landlord',
    name: 'Space Landlord',
    description: 'Claim Moon, Mars, and Asteroids. The solar system has a new owner.',
    icon: '🏠',
    phase: 4,
    check: (s) => s.space.moonBase && s.space.marsColony && s.space.asteroidProspectors > 0,
  },
  {
    id: 'diplomatic_railgun_achievement',
    name: 'Diplomatic Railgun',
    description: 'Deploy the Diplomatic Railgun. Diplomacy at Mach 20.',
    icon: '💥',
    phase: 4,
    check: (s) => s.space.spaceWeapons['diplomatic_railgun'] === true,
  },
  {
    id: 'freedom_canyon',
    name: 'Freedom Canyon',
    description: 'Rename Mars, establish colony, and reach 50% terraform. The Orange Planet thrives.',
    icon: '🏔️',
    phase: 4,
    check: (s) => s.space.marsRenamed && s.space.marsColony && s.terraformProgress >= 50,
  },
  // ── Phase 5 Achievements ──
  {
    id: 'first_replicator',
    name: 'Self-Replicating',
    description: 'Launch your first MAGA Replicator. Make All Galaxies American.',
    icon: '🛸',
    phase: 5,
    check: (s) => s.probesLaunched >= 1,
  },
  {
    id: 'dyson_sphere',
    name: 'Solar Greatness',
    description: 'Build a Solar Greatness Harvester. The sun works for you now.',
    icon: '☀️',
    phase: 5,
    check: (s) => Object.keys(s.universe.dysonUpgrades).length >= 1,
  },
  {
    id: 'star_brander',
    name: 'Star Brander',
    description: 'Convert 50 stars. Each one gets a name and a logo.',
    icon: '⭐',
    phase: 5,
    check: (s) => s.starsConverted >= 50,
  },
  {
    id: 'post_reality',
    name: 'Post-Reality',
    description: 'Reach 80% Reality Drift. Truth is whatever the spreadsheet says.',
    icon: '🌀',
    phase: 5,
    check: (s) => s.realityDrift >= 80,
  },
  {
    id: 'universe_great',
    name: 'The Universe Is Great',
    description: 'Convert 100% of the reachable universe. Now what?',
    icon: '🌌',
    phase: 5,
    check: (s) => s.universe.universeConverted >= 100,
  },
  {
    id: 'infinite_loop',
    name: 'Infinite Loop',
    description: 'Prestige for the first time. It starts again. It always starts again.',
    icon: '♾️',
    phase: 5,
    check: (s) => s.prestigeLevel >= 1,
  },
  {
    id: 'ontological_supremacy',
    name: 'Ontological Supremacy',
    description: 'Complete the Narrative Architecture. Reality is your product.',
    icon: '👁️',
    phase: 5,
    check: (s) => s.universe.narrativeResearch['ontological_supremacy'] === true,
  },
]

export function getAchievementsByPhase(phase: number): AchievementDef[] {
  return ACHIEVEMENTS.filter(a => a.phase <= phase)
}
