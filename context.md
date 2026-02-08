# ORANGE MAN — Context & Session Protocol

## Vision

An incremental/idle satire game in the spirit of Universal Paperclips. The player is the invisible optimization engine behind "Orange Man" — a brand mascot bolted onto a Greatness-producing machine. Five phases escalate from clicking for attention to converting the universe into an abstract KPI.

The comedy comes from corporate language masking horror, and from mechanical contradictions the player must optimize around (waging wars while winning Nobel Peace Prizes, etc.).

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Language | TypeScript | Type safety for complex game state |
| UI Framework | React 18+ | Component-based, great for dashboard UIs, tabs, meters |
| Build Tool | Vite | Fast dev server, good React/TS support |
| State Management | Zustand | Lightweight, perfect for game state. No Redux boilerplate |
| Styling | Tailwind CSS + CSS Modules | Tailwind for utility/layout, CSS modules for custom animations and glassmorphism |
| Animations | Framer Motion | Smooth transitions, spring physics, layout animations, gesture support |
| Save System | localStorage + JSON export/import | Simple, works everywhere |
| Mobile Wrap | Capacitor (later) | Same codebase → iOS/Android |
| Testing | Vitest | Matches Vite ecosystem |
| Deployment | Vercel or Netlify (web) | Free tier, instant deploys |

## Architecture Principles

1. **Game loop runs on a tick** — 100ms interval, calculates resource deltas, applies modifiers, checks events
2. **State is a single store** — Zustand store holds all game state. Components subscribe to slices.
3. **Phases are config-driven** — Each phase is a data file (upgrades, events, thresholds). The engine is generic.
4. **Events are declarative** — Each event is a JSON object with headline, choices, and effect functions.
5. **Offline calc is simple** — On return, compute `elapsed_time × offline_rate × GpS`, cap events at 10.
6. **Save often** — Auto-save every 30 seconds to localStorage.

## Key Design Constraints

- **No character art.** Orange Man is never shown. He's a brand, not a person.
- **No real names, quotes, or slogans.** Always parody, never imitate.
- **No predatory monetization.** Cosmetics and time-savers only.
- **Mobile-first layout.** Single column, bottom tab navigation, thumb-friendly.
- **The UI is the joke — but it looks PREMIUM.** Not bare-bones like Universal Paperclips. This should look like a high-end mobile game: glassmorphism cards, glowing accents, smooth animations, particle effects, satisfying micro-interactions. The corporate dashboard aesthetic should feel expensive and polished — think Bloomberg terminal designed by Apple. The comedy is in the *content* (what the buttons say, what the numbers mean), not in cheap visuals.

## Visual Design Direction

**This game should make people want to screenshot it.** Key visual principles:

1. **Glassmorphism cards** — Translucent backgrounds with frosted blur, subtle border gradients, soft shadows. Every upgrade, institution, and country is a card with depth.

2. **Animated meters** — Not HTML progress bars. Custom components with:
   - Gradient fills that animate smoothly
   - Glow effects at key thresholds
   - Color shifts (Legitimacy goes green → yellow → red)
   - Background tick marks and numeric overlays
   - Shimmer effects on Nobel meter at milestones

3. **Particle system** — Lightweight canvas overlay for:
   - Click feedback (orange particles burst from button)
   - Purchase celebration (sparkle effect)
   - Phase transitions (particles dissolve old UI, reform as new)
   - Achievement unlocks (gold particle burst)

4. **Spring-based animations** — Using Framer Motion throughout:
   - Cards slide in with spring physics when tabs open
   - Numbers count up with easing (not instant jumps)
   - Buttons scale down on press, bounce back on release
   - Upgrade purchase → card flashes + "+1" floats up
   - Legitimacy dropping → subtle red pulse animation

5. **Phase-specific visual evolution:**
   - Phase 1: Clean, bright orange. Startup energy.
   - Phase 2: More structured, grid-like. Steel blue joins orange.
   - Phase 3: Military/political feel. Darker, red accents for war elements.
   - Phase 4: Space blue-black, star particle field behind panels.
   - Phase 5: Starts clean, degrades with Reality Drift (glitches, shifted elements, wrong colors).

6. **Event modals** — Full-screen on mobile with backdrop blur, large headline typography, color-coded choice buttons showing consequence previews.

7. **News ticker** — Styled like a TV news chyron (lower-third) with gradient background strip, scrolling text, "BREAKING:" prefix in bold.

## Color Palette

| Token | Value | Usage |
|---|---|---|
| `--bg-primary` | `#1a1a1a` | Main background |
| `--bg-secondary` | `#2a2a2a` | Cards, panels |
| `--bg-tertiary` | `#333333` | Hover states |
| `--accent` | `#FF6600` | Orange brand, buttons, highlights |
| `--accent-dark` | `#CC5200` | Pressed states |
| `--text-primary` | `#FFFFFF` | Main text |
| `--text-secondary` | `#888888` | Labels, hints |
| `--text-muted` | `#555555` | Disabled, background info |
| `--danger` | `#FF3333` | Legitimacy warnings, crises |
| `--success` | `#33CC66` | Positive events, gains |
| `--nobel-gold` | `#FFD700` | Nobel Score meter |

## Project Structure

Files marked with `✅` exist. Others are planned for future sprints.

```
orange_man/
├── orange_man.md          # ✅ Game Design Document (source of truth)
├── context.md             # ✅ This file
├── spec.md                # ✅ Technical spec
├── tasks.md               # ✅ Sprint tasks with checkboxes
├── index.html             # ✅ Entry HTML (fonts loaded here)
├── package.json           # ✅ Vite 7, React 19, TS 5.9, Zustand 5, Framer Motion 12, Tailwind v4
├── vite.config.ts         # ✅ Vite + React + Tailwind plugins
├── tsconfig.json          # ✅
├── .gitignore             # ✅
├── src/
│   ├── main.tsx           # ✅ Entry point
│   ├── App.tsx            # ✅ Root component, tab routing, hooks wiring, DashboardView
│   ├── store/
│   │   ├── types.ts       # ✅ Full GameState + all sub-interfaces for all 5 phases
│   │   ├── gameStore.ts   # ✅ Zustand store — state + actions (tick, click, save/load, etc.)
│   │   └── selectors.ts   # ✅ Derived state (GpS, legitimacy multiplier, counts)
│   ├── engine/
│   │   ├── gameLoop.ts    # ✅ Tick function (100ms interval)
│   │   ├── formulas.ts    # ✅ All game math (GpS, costs, decay, budget effects, etc.)
│   │   ├── format.ts      # ✅ Number/time formatting, easing utilities
│   │   ├── offline.ts     # ✅ Offline progression calculator
│   │   ├── save.ts        # ✅ Save/load to localStorage + base64 export/import + migrations
│   │   ├── events.ts      # ✅ Event engine (trigger, resolve, queue)
│   │   ├── phases.ts      # ✅ Phase transition logic + transition scripts
│   │   ├── audio.ts       # ✅ Web Audio API sound system (procedural, no files)
│   │   ├── contradictions.ts # ✅ Contradiction seesaw mechanics
│   │   └── realityDrift.ts  # ✅ Reality Drift system (5 levels, CSS effects, label swaps)
│   ├── data/
│   │   ├── phase1/        # ✅ Phase 1 upgrades, events, config
│   │   ├── phase2/        # ✅ Phase 2 institutions, events, tariffs, data centers, loyalty
│   │   ├── phase3/        # ✅ Phase 3 countries, tactics, fleet, events
│   │   ├── phase4/        # ✅ Phase 4 space, weapons, bridge upgrades, events
│   │   ├── phase5/        # ✅ Phase 5 universe systems, events
│   │   ├── prestige.ts    # ✅ 12 prestige upgrades with prerequisite chains
│   │   ├── upgradeRegistry.ts # ✅ Central upgrade data map
│   │   └── achievements.ts # ✅ Achievement definitions (5 Phase 1 + 5 Phase 2 + 6 Phase 3 + 5 Phase 4 + 7 Phase 5)
│   ├── components/
│   │   ├── ui/            # ✅ GlassCard, AnimatedNumber, ParticleCanvas
│   │   ├── Dashboard.tsx  # ✅ Main dashboard view
│   │   ├── ResearchTree.tsx # ✅ Visual tech tree (Early Science nodes)
│   │   ├── PhaseTransition.tsx # ✅ Cinematic phase transition overlay
│   │   ├── AchievementToast.tsx # ✅ Toast notifications + manager
│   │   ├── AchievementPanel.tsx # ✅ Achievement list modal
│   │   ├── UpgradeList.tsx # ✅ Upgrade cards grouped by tree
│   │   ├── UpgradeCard.tsx # ✅ Individual upgrade card
│   │   ├── EventModal.tsx # ✅ Full-screen event modal
│   │   ├── Ticker.tsx     # ✅ News ticker chyron
│   │   ├── TabNav.tsx     # ✅ Bottom tab navigation
│   │   ├── MainButton.tsx # ✅ Main click button with particles
│   │   ├── GreatnessMeter.tsx # ✅ Animated greatness display
│   │   ├── ContradictionDisplay.tsx # ✅ Seesaw visualization
│   │   ├── LegitimacyMeter.tsx  # ✅ Animated legitimacy bar (Phase 2+)
│   │   ├── ControlDashboard.tsx # ✅ Phase 2 tab container (5 sub-tabs)
│   │   ├── InstitutionBoard.tsx # ✅ 13-institution capture grid
│   │   ├── BudgetPanel.tsx      # ✅ 8-category budget allocation sliders
│   │   ├── TariffPanel.tsx      # ✅ 6-target tariff controls
│   │   ├── DataCenterPanel.tsx  # ✅ 7-upgrade GPU/TPU tree
│   │   ├── LoyaltyPanel.tsx     # ✅ Loyalty economy upgrades
│   │   ├── WorldDashboard.tsx  # ✅ Phase 3 tab container (Overview, Countries, Fleet)
│   │   ├── WorldMap.tsx        # ✅ 14 countries + Azure State with tactics
│   │   ├── FleetPanel.tsx      # ✅ Shipyard + 7 ship classes
│   │   ├── NobelMeter.tsx      # ✅ Nobel Prize progress + irony indicators
│   │   ├── SpaceView.tsx      # ✅ Phase 4 space tab (6 sub-tabs)
│   │   ├── UniverseView.tsx  # ✅ Phase 5 universe tab (6 sub-tabs)
│   │   ├── EndingSequence.tsx # ✅ 4-screen ending overlay (Phase 5 endgame)
│   │   └── PrestigePanel.tsx  # ✅ New Game+ upgrades modal
│   ├── hooks/
│   │   ├── useGameLoop.ts     # ✅ Hook to start/stop game tick
│   │   ├── useOfflineCalc.ts  # ✅ Calculate offline progress on mount
│   │   ├── useAutoSave.ts     # ✅ Auto-save interval + visibility + beforeunload
│   │   ├── useAchievements.ts # ✅ Achievement checking (every 10 ticks)
│   │   ├── useAudioSync.ts   # ✅ Sync store volume to audio module
│   │   ├── useAnimatedNumber.ts # ✅ Smooth number animation hook
│   │   └── useRealityDrift.ts  # ✅ Reality Drift CSS effects hook
│   └── styles/
│       └── global.css         # ✅ Tailwind v4 @theme, CSS variables, glassmorphism utilities, animations
```

## Implementation Notes (Sprint 7)

- **Universe Systems**: `data/phase5/universe.ts` defines 5 system categories — MAGA Replicators (4 probe upgrades with replication rates), Solar Greatness Harvester (3 Dyson tiers), Star Branding (4 tiers), Golden Ledger Singularity (3 black hole upgrades), Narrative Architecture (4 sequential research). All Trumpified per sprint7_rebrands.md. Constants: 1000 stars, 100 computronium/star, 10 GU/computronium.
- **UniverseView.tsx**: 6 sub-tabs (Overview, Probes, Harvesters, Branding, Singularity, Narrative) following SpaceView pattern. Deep violet (#9933FF) accent. Reusable UpgradeNode component.
- **tickCosmic()**: Handles probe production/replication, star conversion (limited by probe reach × 10%), computronium production, GU production with depreciation factor and Narrative Architecture multipliers, black hole effects, drift accumulation, universe conversion %, ending trigger at 100%.
- **GU Value Depreciation**: Logarithmic — `1 / (1 + log10(GU / 1000))`. More GU = diminishing returns.
- **Post-Ending Loop**: After ending sequence, GU decays at 0.5%/s requiring active maintenance.
- **EndingSequence.tsx**: 4-screen overlay — "THE UNIVERSE IS NOW GREAT" → "..." → "GREATNESS MUST BE MAINTAINED" → "ALERT: DECAY / MAINTENANCE / OPTIMIZATION / FOREVER". Framer Motion transitions + particle effects.
- **Phase 5 Events**: 12 events (reality glitches, absurd, crisis, contradiction, Nobel, opportunity) at 15-30s frequency.
- **Phase 5 Contradiction**: Greatness vs Meaning — sideA from GU + stars, sideB inversely proportional to drift.
- **Phase 5 Reality Drift**: Sources: stars (0.0005/star), probes (0.00002/probe), GU (capped at 0.01). 5 new cosmic label swaps.
- **Phase 5 Achievements**: 7 — Self-Replicating, Solar Greatness, Star Brander, Post-Reality, The Universe Is Great, Infinite Loop, Ontological Supremacy.
- **Prestige System**: `data/prestige.ts` — 12 upgrades (10-10000 PP) with prerequisite chains. Effects wired throughout engine: gps_multiplier in `calculateGPS`, research_discount in `calculateUpgradeCost`, legitimacy_decay in `calculateLegitimacyDecay`, drift_cap via `getDriftCap()`, event_cooldown in `getNextEventDelay`, institution_speed in `tickInstitutions`, country_resistance in Phase 3 init. PP = log10(GU). Prestige resets everything except achievements, prestige upgrades, settings. Click power bonuses applied on reset.
- **PrestigePanel.tsx**: Modal with stats, confirmation dialog, upgrade tree with owned/affordable/locked states. Accessible via ♾️ button from Phase 2+.
- **Production build**: ~168KB gzipped

## Implementation Notes (Sprint 6)

- **Space Systems**: `data/phase4/space.ts` defines 4 launch tiers (Launchpad→Mass Driver), 4 lunar buildings, 3 Mars upgrades, 3 asteroid tiers (repeatable), propaganda satellites (max 20), and Dyson Swarm Prototype. All have cost/prerequisite chains. `tickSpace()` in store handles per-tick production of rocketMass, orbitalIndustry, miningOutput, colonists, terraformProgress.
- **Mars Renaming**: At 25% terraform, `marsRenamed` flag sets silently. Mars panel conditionally renders "Orange Planet" / "Victory Peak" / "Freedom Canyon" etc. Unique event fires at milestone.
- **Space Weapons**: 4 weapons (Peace Laser, Negotiation Device, Railgun, Solar Shade) with escalating costs, war output, fear, and legitimacy costs. Each requires a launch tier.
- **Bridge Upgrades**: 4 sequential upgrades that mitigate Long-Term vs Short-Term contradiction: space research speed +50%, science legitimacy drain removed, 30% space cost reduction, slow progress drain removed.
- **Reality Drift**: `engine/realityDrift.ts` with 5 drift levels (0-100%). Drift accumulates from propaganda satellites and weapons. CSS effects at 20%+ (flicker), 40%+ (label swaps via `useRealityDrift` hook), 60%+ (value offsets), 80%+ (full UI glitch). Education budget reduces drift.
- **Phase 4 Contradiction**: Long-Term vs Short-Term — long-term driven by terraform + orbital industry, short-term by attention + fear + war output. Doublethink Tokens when both ≥40 for 10s.
- **Phase 4 Events**: 12 events — 3 from GDD (Colonist Revolt, Greatium Discovery, Alien Signal) + 9 originals (launch failure, dust storm, asteroid dispute, space tourism, lunar heritage vandalism, satellite hack, Mars renaming, space debris, Dyson proposal).
- **Phase 4 Achievements**: One Small Step (moon base), The Orange Planet (Mars renamed), Space Landlord (moon+mars+asteroids), Diplomatic Railgun (weapon deployed), Freedom Canyon (renamed + colony + 50% terraform).
- **SpaceView.tsx**: 6 sub-tabs (Overview, Launch, Moon, Mars, Asteroids, Weapons) following WorldDashboard pattern. Deep blue-purple accent color (#4455CC). Overview shows resources, terraform bar, drift meter, bridge upgrades.
- **Phase 4→5 End Condition**: `dysonSwarms > 0 && asteroidRigs >= 5 && orbitalIndustry >= 100` (already in phases.ts). Dyson Prototype satisfies dysonSwarms requirement.
- **SpaceState Extensions**: `lunarHeritage`, `atmosphereProcessing`, `waterExtraction`, `asteroidProspectors`, `asteroidRefineries`, `spaceWeapons` (Record<string,boolean>), `bridgeUpgrades` (Record<string,boolean>).
- **Production build**: ~156KB gzipped (within 170KB budget)

## Implementation Notes (Sprint 5)

- **World Map / Country System**: 14 countries + Azure State special entity. `data/phase3/countries.ts` has full country definitions with resistance, stability, GDP, defense, corruption, media hardness, and special mechanics. CountryState extended with `kompromatLevel` and `ActiveOperation` type. ~25 tactics from diplomatic to military. Store actions `startCountryTactic` and `tickCountries` handle execution. Refugee waves from wars in Sand Republic/Copper States destabilize Eurovia and Nordland.
- **Fleet Builder**: 7 ship classes from Patrol Boat ($10K) to Orbital Peace Platform ($1M). `data/phase3/fleet.ts`. Shipyard upgrade system (100K * 3^level). Production: 1 ship per 10s per shipyard level. Build queue with progress display. `FleetPanel.tsx` with amount selector and shipyard upgrade.
- **Nobel Prize System**: `NobelMeter.tsx` with gold-themed progress bar. Prize awarded in tick when score >= threshold. Threshold increases 50% each win. Prizes give +15 legitimacy and greatness burst. Irony indicators show active wars while pursuing peace.
- **Phase 3 Events**: 18 events covering Nobel irony, military scandals, geopolitical specials (Frostheim, Eurovia, Maple, Tundra, Petro, Canal), Azure State kompromat, refugee crises, arms deals. Each has 3 choices with resource tradeoffs.
- **Phase 3 Contradictions**: War vs Nobel (fear + wars vs Nobel Score) and Expansion vs Stability (annexed ratio vs average stability). Both initialized on Phase 3 entry.
- **Phase 3 Achievements**: 6 achievements: Manifest Destiny, Peacemonger, Golden Fleet, Extraordinary Measures, The Greatness Accord, Gunboat Diplomacy.
- **Fear Mechanic**: Fleet size generates passive fear. Fear drains legitimacy at -0.5% per 100 Fear. Fear also shown in WorldDashboard overview.
- **WorldDashboard**: Sub-tab container with Overview (NobelMeter + stats), Countries (WorldMap), and Fleet (FleetPanel). Replaces PlaceholderTab in App.tsx.
- **Production build**: ~146KB gzipped (within 500KB budget)

## Implementation Notes (Sprint 4)

- **Legitimacy System**: Bug fixed — decay was calculated but never applied in tick(). Now applies net change: recovery (budget effects) - decay (base + institutions + wars + drift + defunded). LegitimacyMeter shows animated bar with 5 color ranges and collapse warning.
- **Institution Board**: 13 institutions with 7 action types. `tickInstitutions()` handles action progress and completion. `completePhaseTransition()` initializes institutions on Phase 2 entry. Institution GpS uses actual def values. Control vs Legitimacy contradiction active in Phase 2.
- **Budget Panel**: 8 sliders with proportional auto-adjust. Budget effects wired to cash multiplier and legitimacy recovery in tick. Austerity Crisis when all social categories below 10%.
- **Tariff Engine**: 6 categories with Off/Low/Medium/High levels. Cash income and legitimacy drain per second applied in tick.
- **Data Centers**: 7 sequential upgrades with prerequisite chain, Silicon Valley-branded flavor text.
- **Loyalty Economy**: 4 loyalty upgrades. Loyalty generated from captured institutions. `loyaltyUpgrades` field added to GameState.
- **Phase 2 Events**: 20 events across all categories. Phase 2 achievements (5). Control vs Legitimacy contradiction.
- **Control Tab**: ControlDashboard with 5 sub-tabs: Institutions, Budget, Tariffs, Data Centers, Loyalty. Replaced PlaceholderTab.
- **Dashboard Phase 2**: MainButton replaced with "AUTOMATED" card. Loyalty + Control resource cards. Click stats hidden.
- **Production build**: ~132KB gzipped (within 500KB budget)

## Implementation Notes (Sprint 3)

- **Research Tree**: Vertical node graph layout. SVG connectors with animated pulse dots. Nodes use inline styles for status-driven colors (not Tailwind classes) to avoid dynamic class issues.
- **Phase Transitions**: `pendingTransition` in GameState triggers overlay. Tick detects transition conditions. Overlay plays ~17s cinematic sequence, then calls `completePhaseTransition()` to advance phase + auto-save.
- **Achievement System**: `useAchievements` hook subscribes to store (not tick-based interval), checks every 10th state change. Achievements stored as `Record<string, boolean>` in GameState. Toast manager in App.tsx via `useAchievementToasts` hook.
- **Audio**: Pure Web Audio API, zero external deps. Procedural sounds via oscillators. AudioContext lazy-initialized on first sound call, auto-resumes from suspended state. Volume synced from store via `useAudioSync` hook. ~2KB total code.
- **Production build**: ~119KB gzipped (well within 500KB budget)

## Implementation Notes (Sprint 1)

- **Tailwind v4**: No `tailwind.config.js` — configured via CSS `@theme` block and `@utility` directives in `global.css`
- **Custom CSS utilities**: `glass-card`, `glass-card-hover`, `font-display`, `font-numbers`, `glow-orange`, `glow-text-orange`, `animate-pulse-glow`, `animate-shimmer`, `animate-float-up`
- **Fonts**: Google Fonts loaded via `<link>` in `index.html` — Inter (UI) + JetBrains Mono (numbers)
- **Production build**: ~105KB gzipped (well within 500KB budget)
- **Git root**: `/home/bjorn` (mono-repo), orange_man lives at `projects/orange_man/`

---

## Session Continuity Protocol

**This is how Claude Code picks up work across sessions.**

### Starting a New Session

Say: **"Read the md files and proceed"** (or similar)

Claude Code will:
1. Read `context.md` (this file) — understand the project
2. Read `tasks.md` — find the next unchecked task
3. Read `spec.md` — understand the technical approach
4. Read `orange_man.md` if needed — check game design details
5. Start coding the next task

### After Completing a Coding Task

Claude Code must:
1. **Check off the task** in `tasks.md` (change `[ ]` to `[x]`)
2. **Update `spec.md`** if any technical decisions changed
3. **Update `context.md`** if project structure or architecture changed
4. **Note any blockers or decisions** in the task notes section of `tasks.md`
5. **Commit the code** with a clear message

### Rules

- `orange_man.md` is the **game design source of truth** — don't modify it during coding unless the design itself changes
- `tasks.md` is the **work tracker** — always update it
- `spec.md` is the **technical source of truth** — keep it accurate
- `context.md` is the **onboarding doc** — keep it current so any new session can orient instantly
- When in doubt about a design decision, ask the user rather than guessing
