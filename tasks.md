# ORANGE MAN — Task Tracker

## How This File Works

- Each task has a checkbox: `[ ]` = pending, `[x]` = done
- Tasks are grouped into sprints matching the production plan
- **After completing a task:** check it off, add notes if needed, update spec.md/context.md
- **Starting a new session:** Read this file, find the first unchecked task, and start working
- Tasks within a sprint should be done in order (they build on each other)

---

## Sprint 1: Project Setup & Core Engine (Week 1)

### S1.1 — Project Initialization
- [x] Initialize Vite + React + TypeScript project
- [x] Install dependencies: zustand, framer-motion, tailwindcss
- [x] Set up project structure matching context.md
- [x] Configure Tailwind with custom dark theme (colors, glassmorphism utilities, fonts)
- [x] Set up global CSS: CSS variables, Inter + JetBrains Mono fonts, dark background with noise texture
- [x] Create basic App.tsx with tab navigation shell (bottom tabs with glow effect)
- [x] Set up .gitignore, initial commit

**Notes:**
Vite 7 + React 19 + TS 5.9. Tailwind v4 with @tailwindcss/vite plugin (no tailwind.config — uses CSS @theme instead). Custom utilities: glass-card, font-display, font-numbers, glow-orange, glow-text-orange, animate-pulse-glow, animate-shimmer, animate-float-up. Noise texture via inline SVG filter. Google Fonts loaded via index.html link tags.

### S1.2 — Game State & Store
- [x] Define TypeScript interfaces in `store/types.ts` (match spec.md schema)
- [x] Create Zustand store in `store/gameStore.ts` with initial Phase 1 state
- [x] Create `store/selectors.ts` with derived values (GpS calculation, multipliers)
- [x] Implement save/load functions in `engine/save.ts` (localStorage + JSON)
- [x] Add auto-save hook (`hooks/useAutoSave.ts`)
- [x] Add save version migration framework

**Notes:**
Full GameState + GameActions types defined. Store includes all core actions: tick, click, purchaseUpgrade, resolveEvent, save/load/reset, applyEffect. Save system has export/import (base64) and migration framework ready. Auto-save every 30s + on visibility change + on beforeunload.

### S1.3 — Game Loop
- [x] Implement core tick function in `engine/gameLoop.ts`
- [x] Create `hooks/useGameLoop.ts` to start/stop the 100ms interval
- [x] Implement `engine/formulas.ts` with GpS, cost scaling, legitimacy decay
- [x] Implement offline progression calculator (`engine/offline.ts`)
- [x] Create `hooks/useOfflineCalc.ts` — calculate progress on app mount
- [x] Test: verify tick runs, resources increment, save/load round-trips

**Notes:**
Game loop tick at 100ms intervals via setInterval. Formulas include: GpS (base * legitimacy * phase * prestige), legitimacy decay, upgrade cost scaling (1.15^n), Nobel diminishing returns, budget effects, event frequency per phase. Offline calc triggers for absences >60s with configurable rate (base 10%, upgradeable). Build passes type-check and production build cleanly (105KB gzipped).

### S1.4 — Number Formatting & Utilities
- [x] Create number formatter (commas, suffixes, scientific notation)
- [x] Create time formatter (for countdowns, durations)
- [x] Create easing/animation utilities for smooth counter updates

**Notes:**
`engine/format.ts`: formatNumber (exact → commas → M suffix → word suffixes up to septillion), formatCompact (K/M/B/T), formatDuration, formatCountdown, lerp, easeOutCubic, easeOutExpo. Dashboard wired to live store — clicking generates attention + greatness.

---

## Sprint 2: Dashboard & Phase 1 UI (Week 2)

### S2.1 — Dashboard Layout & Visual Foundation
- [x] Build Dashboard.tsx — main screen layout with glassmorphism cards
- [x] Build GreatnessMeter.tsx — animated gradient bar with glow, smooth counting numbers (JetBrains Mono)
- [x] Build MainButton.tsx — large glowing "GENERATE ATTENTION" button with:
  - Scale animation on press (Framer Motion whileTap)
  - Orange particle burst on click (lightweight canvas overlay)
  - Pulse animation when idle
- [x] Build reusable GlassCard component (translucent bg, blur, border gradient, hover glow)
- [x] Build AnimatedNumber component (smooth count-up with easing, monospace font)
- [x] Style with glassmorphism dark theme, orange glow accents, gradient meters
- [x] Ensure mobile-responsive layout (single column < 768px, multi-column desktop)

**Notes:**
Components: `GlassCard` (reusable, supports glow colors + hover), `AnimatedNumber` (useAnimatedNumber hook with easeOutExpo + requestAnimationFrame), `GreatnessMeter` (number + GpS + decorative gradient bar), `MainButton` (Framer Motion whileTap + canvas particle overlay), `ParticleCanvas` (max 50 particles, gravity, fade, 60fps RAF loop). Dashboard layout: GreatnessMeter → MainButton → Resource stats grid → Contradiction → Upgrades.

### S2.2 — Upgrade System
- [x] Build UpgradeList.tsx — scrollable card list with Framer Motion stagger animations
- [x] Build UpgradeCard.tsx — glassmorphism card with icon, name, cost, effect description
  - States: locked (dimmed), affordable (orange glow border), purchased (green dot, subtle)
  - Purchase animation: flash + floating "+1" text + sparkle
- [x] Define Phase 1 upgrade data in `data/phase1/upgrades.ts`
  - Media Presence tree (5 upgrades)
  - Merchandise Empire tree (5 upgrades)
  - Algorithm Manipulation tree (5 upgrades)
  - Early "Science" tree (5 upgrades)
  - "Entrepreneurship" tree (5 upgrades: Bible Sales, University, Steak, Crypto, Truth Platform)
- [x] Implement purchase logic in store (cost deduction, effect application, cost scaling)
- [x] Add unlock conditions (some upgrades hidden until prerequisites met)
- [x] Smooth card reveal animation when new upgrades unlock (slide up + fade)

**Notes:**
25 upgrades across 5 trees. `UpgradeData` type added to types.ts. `upgradeRegistry.ts` — central map for all upgrade data. Store `purchaseUpgrade` now: looks up UpgradeData, calculates cost (1.15^n scaling), checks affordability, deducts cost from resource (attention/cash/greatness), applies immediate effects (attentionPerClick), updates upgrade state. `formulas.ts` updated to use upgrade data for production and gpsMultiplier effects. Tick now recalculates GpS from formulas every tick. Effects: `attentionPerClick` (immediate), `cashPerSecond` (tick-based), `gpsMultiplier` (formula-based). Neural Backup is the Phase 1 endgame upgrade (15,000 attention).

### S2.3 — Ticker & Events (Phase 1)
- [x] Build Ticker.tsx — TV news chyron style (gradient background strip, scrolling white text, "BREAKING:" bold prefix)
- [x] Build EventModal.tsx — full-screen mobile overlay with:
  - Backdrop blur effect
  - Large headline typography (condensed sans)
  - Context in secondary text
  - Color-coded choice buttons (green=positive, red=negative, orange=mixed)
  - Consequence preview text under each choice
  - Framer Motion scale + fade entrance
- [x] Implement event engine in `engine/events.ts` (scheduling, selection, resolution)
- [x] Define Phase 1 events in `data/phase1/events.ts` (15+ events)
- [x] Wire event effects to store (resource changes, unlocks)
- [x] Event frequency: every 2-3 minutes for Phase 1

**Notes:**
18 Phase 1 events across all categories: 3 scandal, 5 opportunity, 3 absurd, 2 contradiction, 2 crisis, 3 misc. Event engine: `checkEventTrigger` (time-based), `selectEvent` (weighted random from eligible pool), `scheduleNextEvent`. Category weights: opportunity=3, scandal=2, absurd=2, contradiction=1.5, crisis=1. Events support conditions (resource thresholds), unique flags, cooldowns. Ticker shows last 5 resolved headlines with CSS marquee scroll. EventModal uses spring animation, category color-coded badges, backdrop blur. Events fire every 120-180s in Phase 1.

### S2.4 — Phase 1 Contradiction
- [x] Implement Contradiction Engine in `engine/contradictions.ts`
- [x] Build contradiction display on Dashboard (Attention vs Credibility seesaw)
- [x] Define Phase 1 contradiction: Attention vs Credibility
  - Scandals boost Attention 3x but drain Credibility
  - Credibility minimum required for Cash donations
- [x] Implement Doublethink Token rewards for balanced management

**Notes:**
`doublethinkTokens` added to GameState. Contradiction engine runs per tick: Attention rises with activity, decays over time. Credibility pressured down by attention gains, recovers naturally. Both 0-100 scale. When both above 40 for 10s, awards 1 Doublethink Token. `getCredibilityEffect()` penalizes cash generation when credibility <30 (30% rate) or <50 (70% rate). Seesaw visualization on Dashboard with dual gradient bars, balance zone indicator, and status messages.

### S2.5 — Tab Navigation
- [x] Build TabNav.tsx — bottom navigation bar
- [x] Dashboard tab (always visible)
- [x] Research tab (unlocked Phase 1)
- [x] Tabs greyed out / hidden until phase unlocks them
- [x] Tab transition animations

**Notes:**
Extracted TabNav to its own component. Shows unlocked tabs + one "teaser" locked tab with 🔒 icon, greyed out, disabled. Active tab has orange glow indicator with spring animation (layoutId). Tab content transitions via AnimatePresence with fade + slide. Locked tabs show "???" label.

---

## Sprint 3: Phase 1 Complete & Phase Transitions (Week 3)

### S3.1 — Research Tree
- [x] Build ResearchTree.tsx — visual tech tree with nodes and connections
- [x] Wire into Phase 1 "Early Science" upgrades
- [x] Neural Backup as the final research node (Phase 1 end condition)

**Notes:**
`ResearchTree.tsx`: Vertical node graph layout for the Early Science tree (5 nodes). Each node shows icon in circular bubble, name, cost, production, and status. Statuses: locked (🔒, dimmed), available (visible, dimmed cost), affordable (orange glow border + shimmer bar), purchased (green dot + glow). SVG connector lines between nodes — dashed when locked, solid green when predecessor purchased, with animated pulse dot on active connections. Nodes alternate initial slide direction (left/right) for visual interest. "Phase 2" badge on Neural Backup node. Wired into existing `purchaseUpgrade` action. Replaced PlaceholderTab in App.tsx.

### S3.2 — Phase Transition System
- [x] Implement phase transition logic in `engine/phases.ts`
- [x] Build PhaseTransition.tsx — cinematic full-screen overlay:
  - Fade to black
  - Typewriter text effect (line by line, 2-3 sec spacing)
  - Subtle particle/glow effects behind text
  - Final line flash → new UI fades in
  - New tab appears with glow animation
  - Total duration ~15-20 seconds
- [x] Phase 1 → 2 transition: Neural Backup complete → show transition → unlock Control tab
- [x] Grey out / transform Phase 1 elements (Attention button becomes automated summary)
- [x] Auto-save on transition

**Notes:**
`engine/phases.ts`: `checkPhaseTransition()` checks end conditions for all 5 phases. Transition script data for all 4 transitions (1→2 through 4→5) with timed text lines, style variants (bold, accent, dim). `PhaseTransition.tsx`: Full-screen black overlay with radial orange gradient background, 20 floating Framer Motion particles, sequenced text reveal with fade+slide animations. ~17s total duration. `pendingTransition` field added to GameState — tick detects transition condition → sets pending → overlay plays → `completePhaseTransition()` advances phase + auto-saves. Grey-out of Phase 1 elements deferred to Phase 2 sprint (S4) since Control tab content doesn't exist yet.

### S3.3 — Achievement System (Foundation)
- [x] Build AchievementToast.tsx — popup notification for unlocked achievements
- [x] Implement achievement checking in game loop (batched, every 10 ticks)
- [x] Define Phase 1 achievements (5 achievements)
- [x] Achievement display panel (accessible from settings/menu)

**Notes:**
5 Phase 1 achievements: The Beginning (first click), Compulsive Clicker (100 clicks), Self-Improvement (first upgrade), Diversified Portfolio (one from each tree), Digital Immortality (Neural Backup). `data/achievements.ts`: `AchievementDef` type with check function per achievement. `hooks/useAchievements.ts`: Subscribes to store changes, checks every 10 ticks, batch-unlocks achievements, plays sound, calls callback. `AchievementToast.tsx`: Toast manager hook + renderer — gold-bordered glass card slides down from top with spring animation, auto-dismisses after 4s. `AchievementPanel.tsx`: Modal overlay with backdrop blur, lists all achievements for current phase, locked ones show ??? with 🔒. Trophy button (🏆) fixed top-right in App.tsx.

### S3.4 — Audio Foundation
- [x] Set up audio system (Web Audio API or Howler.js)
- [x] Click sound for main button
- [x] Purchase sound for upgrades
- [x] Event notification sound
- [x] Phase transition sound
- [x] Volume controls in settings

**Notes:**
Pure Web Audio API — zero dependencies, procedurally generated sounds. `engine/audio.ts`: 5 sound generators — `playClick` (percussive sine blip), `playPurchase` (ascending two-tone C5→E5), `playEvent` (descending triangle arpeggio A5→E5→C5), `playAchievement` (triumphant C major fanfare), `playPhaseTransition` (deep sawtooth rumble + rising sine sweep, 3.5s). Volume controlled by `setSfxVolume()` and `setMuted()`. `hooks/useAudioSync.ts` syncs store `settings.sfxVolume` to audio module. AudioContext auto-resumes on user interaction (browser autoplay policy). Wired into: MainButton, UpgradeCard, ResearchTree nodes, EventModal, PhaseTransition, useAchievements. Bundle impact: ~2KB (no audio files).

---

## Sprint 4: Phase 2 — Institutional Capture (Week 4-5)

### S4.1 — Legitimacy System
- [x] Add Legitimacy bar to Dashboard (always visible from Phase 2+)
- [x] Implement legitimacy decay formula
- [x] Implement legitimacy multiplier effects on GpS
- [x] Legitimacy range effects (bonuses, penalties, collapse warning)
- [x] Visual: color changes at different legitimacy ranges

**Notes:**
`LegitimacyMeter.tsx`: Animated Framer Motion bar with color ranges (green >80%, yellow-green 50-80%, amber 25-50%, red <25%, flashing red <10%). Shows numeric %, rate of change per second, status label, GpS multiplier effect, and COLLAPSE WARNING animation when critical. Fixed critical bug: legitimacy decay was calculated in formulas but never applied in tick(). Now tick applies net change = recovery (healthcare + social + propaganda budget effects) - decay (base + institutions + wars + drift + defunded). Budget effects from `calculateBudgetEffects()` wired into cash multiplier and legitimacy recovery.

### S4.2 — Institution Board
- [x] Build InstitutionBoard.tsx — grid of 13 institution cards (glassmorphism)
- [x] Each card shows: name, status badge, resistance bar, Greatness output, animated progress
- [x] Implement institution actions: Co-opt, Replace, Purge, Rebrand, Automate, Privatize, Loyalty Test
- [x] Progress bars for ongoing actions (animated, timed)
- [x] Define all 13 institutions with stats in `data/phase2/institutions.ts`
- [x] Capture animation: card border transitions from grey → orange → green

**Notes:**
`data/phase2/institutions.ts`: 13 institutions across 5 categories (media, judicial, security, civic, regulatory). Each has resistance, corruption susceptibility, GpS output, legitimacy impact, loyalty generation. 7 action types defined with duration, costs, resistance reduction, and legitimacy effects. `InstitutionBoard.tsx`: Responsive grid of glassmorphism cards. Cards expand on click to show available actions. Progress bars for ongoing actions with percentage. Status dots color-coded. Store `tickInstitutions()` runs per tick — handles action completion, resistance reduction, and capture. `completePhaseTransition()` now initializes all 13 institutions with starting resistance when entering Phase 2. Institution GpS now uses actual def values (not hardcoded 5).

### S4.3 — National Budget System
- [x] Build BudgetPanel.tsx — slider allocation UI for 8 budget categories
  - Healthcare, Education, Social Benefits, Military, Data Centers, Infrastructure, Propaganda, Space
  - Sliders must sum to 100% (auto-adjust others when one moves)
  - Color-coded: social programs = blue/green, military/data = orange/red
  - Real-time preview of effects as sliders move
- [x] Implement budget effects in game loop (production modifiers per category)
- [x] Budget-related events: healthcare crisis, education cuts, worker protests
- [x] "Austerity Crisis" trigger when social programs all below 10%

**Notes:**
`BudgetPanel.tsx`: 8 sliders (0-50 each), proportional auto-adjust to keep total at 100%. Social/power summary bar. Austerity Crisis warning animation when healthcare+education+socialBenefits all <10%. Real-time effect value display per category. Budget effects wired into tick: infraBonus → cash multiplier, healthcare+social+propaganda → legitimacy recovery.

### S4.4 — Tariff Engine & Data Centers
- [x] Build TariffPanel.tsx — toggleable tariff targets with level sliders
  - Consumer Goods, Industrial, Technology, Agricultural, Allied Nations, Everyone
  - Show Cash generation vs side effects in real-time
- [x] Implement tariff effects (Cash gain + production penalties + resistance increases)
- [x] Build DataCenterUpgrades.tsx — upgrade tree for GPU/TPU empire
  - Surveillance Array → Predictive Loyalty → Content Farm → Deepfake Diplomacy → Autonomous Governance → Reality Processing → Neural Compliance
- [x] Wire data center effects to Attention, Surveillance, Propaganda multipliers
- [x] Tariff and data center related events (5+ events each)

**Notes:**
`data/phase2/tariffs.ts`: 6 tariff categories with 4 levels each (Off/Low/Medium/High). Each has cash per minute, legitimacy drain per second, production penalty, and resistance increase. `TariffPanel.tsx`: Level selector buttons with real-time effect preview. Tariff cash/legitimacy effects wired into tick — tariff cash added per second, legitimacy drain applied. `data/phase2/dataCenters.ts`: 7 sequential upgrades (prerequisite chain). `DataCenterPanel.tsx`: Vertical node list with connector lines, status dots, deploy buttons. Silicon Valley-branded flavor text. `ControlDashboard.tsx`: Tab navigation for Institutions, Budget, Tariffs, Data Centers, Loyalty.

### S4.5 — Loyalty Economy
- [x] Implement Loyalty Pledges, Loyalty Scores, Loyalty Rewards, Loyalty-Based Hiring
- [x] Wire to institution efficiency, surveillance, legitimacy effects
- [x] Loyalty-related events (3+ events)

**Notes:**
`data/phase2/loyalty.ts`: 4 loyalty upgrades with escalating costs and effects. `LoyaltyPanel.tsx`: Card-based purchase UI with loyalty+cash costs, flavor text, active/inactive states. `loyaltyUpgrades` field added to GameState. Loyalty generated from captured institutions via `tickInstitutions()`. Loyalty-related events included in Phase 2 events (worker protests, loyalty app, etc.).

### S4.6 — Phase 2 Events & Contradiction
- [x] Define Phase 2 events in `data/phase2/events.ts` (20+ events including budget/tariff/loyalty events)
- [x] Implement Phase 2 contradiction: Control vs Legitimacy
- [x] Nobel Score meter introduced (via events)
- [x] Define Phase 2 achievements (5 achievements)

**Notes:**
`data/phase2/events.ts`: 20 Phase 2 events across all categories — scandal (whistleblower), crisis (polls, general defiance, health crisis, protests, veterans, austerity, court challenge), opportunity (CEO education, tariff revenue, data center growth, Nobel nomination, private prison), contradiction (health study, education review, workers benefits, climate research), absurd (intern memo, AI speech, loyalty app). All wired into ALL_EVENTS. `contradictions.ts` updated: Control vs Legitimacy seesaw — control rises with captured institutions, legitimacy mirrors actual legitimacy. Doublethink Tokens awarded when both above 40 for 10s. 5 Phase 2 achievements: Institutional Alignment, Hostile Takeover, Legitimacy Crisis, The Deep State, Tariff Man.

### S4.7 — Phase 2 → 3 Transition
- [x] End condition: all 13 institutions captured
- [x] Transition screen text
- [x] Unlock World tab (Phase 3 sprint)
- [x] Initialize Phase 3 state (countries, fleet, etc.) (Phase 3 sprint)

**Notes:**
Phase 2→3 end condition already in `phases.ts`: all 13 institutions captured/automated. Transition script text for 2→3 already defined in `phases.ts`. World tab now shows WorldDashboard. Phase 3 initialization (countries, fleet, contradictions) done in `completePhaseTransition()`.

---

## Sprint 5: Phase 3 — World Greatening (Week 5-7)

### S5.1 — World Map & Country System
- [x] Define all 14 countries with stats in `data/phase3/countries.ts`
  - Include Frostheim, Maple Federation, Petro Republic, Canal Isthmus
  - Azure State special entity (Eddstein's Isle kompromat mechanic)
- [x] Define ~25 tactics (standard, country-specific, Azure State)
- [x] Build WorldMap.tsx — country cards with status, resistance, stability, tactics
- [x] Build WorldDashboard.tsx — sub-tab container (Overview, Countries, Fleet)
- [x] Implement tactics system in store (startCountryTactic, tickCountries)
- [x] Country-specific special mechanics:
  - Frostheim: Purchase Offer (5 offers = surrender)
  - Maple Federation: Trade Dependency + Absorption Referendum
  - Tundra Republic: Encirclement meter (100% = fold)
  - Petro Republic: Sanctions → instability → Extraordinary Rendition
  - Canal Isthmus: Shipping leverage
  - Azure State: Kompromat resist → Aid reduction → Leverage reversal → Full absorption
- [x] Refugee Wave mechanic (wars in Sand Republic/Copper States destabilize Eurovia/Nordland)
- [x] Annexed countries contribute GpS in formulas.ts
- [x] Wire country initialization in completePhaseTransition for Phase 3

**Notes:**
`data/phase3/countries.ts`: 14 countries across 6 regions + Azure State special entity. Each country has resistance, stability, GDP, defense, corruption, media hardness, greatnessPotential, nobelOptics, and optional specialMechanic. CountryState extended with `kompromatLevel` field and `ActiveOperation` type (replaces string[]). ~25 tactics: standard (partnership, trade leverage, media infiltration, freedom foundation, coup, freedom operation, extraordinary rendition, annexation, post-war rebuilding, immigration weaponization) + country-specific (purchase offer, trade integration, absorption referendum, joint defense, sanctions campaign, democracy fund) + Azure State (kompromat resist, aid reduction, leverage reversal, full absorption). Store actions: `startCountryTactic` validates costs/availability/max ops, `tickCountries` progresses operations, applies resistance/stability/fear/nobel effects, handles special mechanics. Fear drains legitimacy at -0.5% per 100 Fear. Refugee waves auto-destabilize Eurovia and Nordland when wars happen in Sand Republic or Copper States.

### S5.2 — Fleet Builder & Fear
- [x] Build FleetPanel.tsx — shipyard management and ship list
- [x] Define 7 ship classes in `data/phase3/fleet.ts`
- [x] Shipyard production system (build queue, production rate, shipyard upgrades)
- [x] Fear mechanic (fleet size → passive fear → legitimacy drain)
- [x] Ship count + build amount selector UI

**Notes:**
`data/phase3/fleet.ts`: 7 ship classes — Patrol Boat ($10K), Torpedo Barge ($30K), Destroyer ($50K), "Peace Cruiser" ($150K, Nobel-positive!), Carrier ($200K), Golden Dreadnought ($500K), Orbital Peace Platform ($1M). Each has war output, fear, Nobel impact, and shipyard level requirement (1-4). Shipyard upgrades scale 100K * 3^level. Production: 1 ship per 10s per shipyard level. `FleetPanel.tsx`: Ship class cards with build amount selector (1/5/10), shipyard upgrade button, build queue progress display, fear warning. Store: `buildShip`, `upgradeShipyard`, `tickShipyard` actions. Phase 3 starts with shipyard level 1.

### S5.3 — Nobel Prize System (Full)
- [x] Build NobelMeter.tsx — Nobel Score display with progress bar and threshold
- [x] Nobel Prize awarding in tick (nobelScore >= threshold → win prize)
- [x] Diminishing returns (threshold increases 50% each prize)
- [x] Prize rewards (Legitimacy +15, Greatness burst)
- [x] Irony indicators (show active wars while pursuing peace)
- [x] Integrated into WorldDashboard overview

**Notes:**
`NobelMeter.tsx`: Gold-themed glassmorphism card showing Nobel Score progress, threshold, prizes won (medal icons), active war count, fear level, and ironic commentary. Gold glow when close to threshold. Nobel Prize awarded in tick: resets score, increases threshold by 50%, gives +15 legitimacy and greatness burst. War vs Nobel contradiction makes this the game's core Phase 3 optimization puzzle — build war output to conquer, then manufacture peace optics.

### S5.4 — Phase 3 Events, Contradictions & Achievements
- [x] Define Phase 3 events in `data/phase3/events.ts` (18 events)
  - Nobel events (nomination, ironic editorial)
  - Military events (warship leak, coalition condemns, rendition fallout)
  - Country-specific events (Frostheim, Eurovia, Maple, Tundra, Petro, Canal)
  - Crisis events (refugees, Azure State demands, Jade Empire warning)
  - Opportunity events (peace summit, arms deal, island climate, NGO backlash)
- [x] Implement War vs Nobel contradiction (fear + wars vs Nobel Score)
- [x] Implement Expansion vs Stability contradiction (annexed count vs global stability)
- [x] Phase 3 achievements (6 achievements):
  - Manifest Destiny (first annexation)
  - Peacemonger (Nobel Prize during active war)
  - Golden Fleet (build Golden Dreadnought)
  - Extraordinary Measures (use Extraordinary Rendition)
  - The Greatness Accord (all 14 countries)
  - Gunboat Diplomacy (Nobel Prize with 50+ ships)

**Notes:**
18 Phase 3 events covering Nobel irony, military scandals, geopolitical specials, refugee crises, Azure State kompromat, and arms deals. Each event has 3 choices with distinct resource tradeoffs — the satire is in how "noble" language masks terrible actions. Two Phase 3 contradictions: War vs Nobel (fear + active wars vs Nobel Score) and Expansion vs Stability (annexed country ratio vs average remaining stability). Both initialized on Phase 3 entry. 6 Phase 3 achievements. All wired into ALL_EVENTS, contradictions engine, and Phase 3 initialization.

### S5.5 — Phase 3 → 4 Transition
- [x] End condition: all 14 countries under Greatness Accord (already in phases.ts)
- [x] Transition screen text (already in phases.ts)
- [x] Initialize Phase 4 state (Phase 4 sprint)

**Notes:**
Phase 3→4 end condition already in `phases.ts`: all countries annexed/allied. Transition script text already defined. Phase 4 initialization will be done in Sprint 6.

---

## Sprint 6: Phase 4 — Space Greatening (Week 8-9)

### S6.1 — Space Systems
- [x] Build SpaceView.tsx — solar system visualization
- [x] Launch infrastructure tier system (Launchpad → Mass Driver)
- [x] Lunar industry (Moon Base, He-3 Mining, Lunar Shipyard)
- [x] Martian terraforming (colony, atmosphere, water)
- [x] Asteroid strip mining (prospectors, rigs, refineries)
- [x] Orbital propaganda satellites

**Notes:**
`data/phase4/space.ts`: 4 launch tiers (Launchpad $500K → Mass Driver $100M), 4 lunar buildings (Moon Base, He-3 Mining, Lunar Shipyard, Lunar Heritage Site), 3 Mars upgrades (Colony, Atmosphere Processing, Water Extraction), 3 asteroid tiers (Prospector Drones max 10, Mining Rigs max 10, Refineries max 5), propaganda satellites (max 20, $5M + 10 OI each), Dyson Swarm Prototype ($200M, requires mass_driver + 80 OI). `SpaceView.tsx`: 6 sub-tabs (Overview, Launch, Moon, Mars, Asteroids, Weapons). Store: `tickSpace(dt)` produces rocketMass, orbitalIndustry, miningOutput, colonists, terraformProgress per tick. 8 new store actions for building/purchasing.

### S6.2 — Mars Renaming & Space Weapons
- [x] Mars renaming milestone at 25% terraform (silent UI change)
- [x] Define space weapons (Peace Laser, Negotiation Device, Railgun, Solar Shade)
- [x] Wire space weapons to War Output and country effects

**Notes:**
Mars renaming triggers silently at 25% terraform in `tickSpace()`. Mars panel conditionally renders "Orange Planet" names. `data/phase4/weapons.ts`: 4 weapons — Orbital Peace Laser ($5M, +2K war, +50 fear, -10 legit, requires spaceport), Asteroid Negotiation Device ($10M, +3K war, +100 fear), Diplomatic Railgun ($20M, +5K war, +200 fear), Solar Shade Array ($50M, +10K war, +500 fear). Each requires a launch tier. War output and fear applied on purchase.

### S6.3 — Reality Drift (Introduced)
- [x] Implement Reality Drift accumulation mechanics
- [x] UI glitch effects at 20-40% (CSS flicker animations)
- [x] Label swaps at 40-60%
- [x] Value offsets at 60-80%
- [x] Full unreliable UI at 80-100%
- [x] Drift reduction mechanics (fund science, stabilization campaigns)

**Notes:**
`engine/realityDrift.ts`: 5 drift levels (Stable, Minor Distortion, Narrative Drift, Reality Erosion, Total Dissociation). Drift rate from satellites (0.001/unit), weapons (0.002/weapon), high fear (0.001 when >50). Reduction from education budget. `hooks/useRealityDrift.ts`: Sets CSS `--drift-intensity` variable, toggles drift classes on documentElement. Timer-based label swaps at 40%+ using `data-drift-label` attributes. CSS keyframes for flicker (opacity/hue-rotate) and glitch (clip-path/translateX).

### S6.4 — Phase 4 Events, Contradiction, Transition
- [x] Define Phase 4 events (10+ events)
- [x] Implement contradiction: Long-Term vs Short-Term
- [x] Bridge upgrades (Long-Term Thinking Simulator, Science Rebranding, etc.)
- [x] Phase 4 achievements (5 achievements)
- [x] End condition: Solar System = Greatness Industrial Zone
- [x] Transition to Phase 5

**Notes:**
12 Phase 4 events (3 GDD + 9 originals). Long-Term vs Short-Term contradiction in `contradictions.ts`. 4 bridge upgrades (research speed, science rebranding, cost reduction, patience). 5 Phase 4 achievements (One Small Step, Orange Planet, Space Landlord, Diplomatic Railgun, Freedom Canyon). End condition already in `phases.ts`: `dysonSwarms > 0 && asteroidRigs >= 5 && orbitalIndustry >= 100`. Phase 4 initialization in `completePhaseTransition()`. Transition cinematic script already defined.

---

## Sprint 7: Phase 5 — God Emperor Protocol (Week 10-11)

### S7.1 — Universe Systems
- [x] Build UniverseView.tsx — galaxy visualization
- [x] Von Neumann probe system (exponential replication)
- [x] Dyson Swarm construction
- [x] Star conversion mechanic
- [x] Black Hole Accounting
- [x] Reality Rebranding research tree

**Notes:**
`data/phase5/universe.ts`: All Phase 5 system definitions — MAGA Replicators (4 probe upgrades with replication rates), Solar Greatness Harvester (3 Dyson tiers), Star Branding (4 tiers), Golden Ledger Singularity (3 black hole upgrades), Narrative Architecture (4 sequential research). Constants: 1000 reachable stars, 100 computronium per star, 10 GU per computronium. `components/UniverseView.tsx`: 6 sub-tabs (Overview, Probes, Harvesters, Branding, Singularity, Narrative) following SpaceView pattern. Reusable UpgradeNode component with status dots, connector lines, cost display, BUILD button. Deep violet (#9933FF) accent. `store/gameStore.ts`: `tickCosmic(dt)` handles probe production/replication, star conversion (limited by probe reach), computronium production, GU production with Narrative Architecture multipliers, black hole effects, drift accumulation, universe conversion %, ending trigger at 100%. 5 purchase actions for all Phase 5 systems. Phase 5 initialization in `completePhaseTransition()`. All names Trumpified per sprint7_rebrands.md.

### S7.2 — Phase 5 Contradiction & Endgame
- [x] Implement Greatness vs Meaning contradiction
- [x] GU value depreciation (logarithmic decrease)
- [x] Event frequency acceleration (every 15-30 seconds)
- [x] Full Reality Drift UI degradation
- [x] Ending sequence (4 screens)
- [x] Post-ending maintenance loop

**Notes:**
Greatness vs Meaning contradiction in `contradictions.ts`: sideA driven by GU + stars, sideB inversely proportional to reality drift (100 - drift). `data/phase5/events.ts`: 12 Phase 5 events across reality glitches, absurd, crisis, contradiction, Nobel, and opportunity categories — 15-30s frequency. GU value depreciation: logarithmic factor `1 / (1 + log10(GU / 1000))` applied to GU production. Post-ending: 0.5% GU decay per second after endingComplete, requiring active upkeep. `components/EndingSequence.tsx`: 4-screen overlay — "THE UNIVERSE IS NOW GREAT" → "..." → "GREATNESS MUST BE MAINTAINED" → "ALERT: GREATNESS DECAY / MAINTENANCE PROTOCOL / OPTIMIZATION / FOREVER" with Framer Motion transitions and particle effects. Phase 5 Reality Drift sources: stars, probes, GU. 5 new cosmic label swaps (Stars→Branded Assets, etc.). 7 Phase 5 achievements.

### S7.3 — Prestige System
- [x] Implement prestige reset logic
- [x] Prestige Points calculation (based on total GU)
- [x] Define prestige upgrades (10+ upgrades)
- [x] Prestige upgrade purchase UI
- [x] Persistent state across resets (achievements, prestige upgrades, stats)

**Notes:**
`data/prestige.ts`: 12 prestige upgrades with prerequisite chains — Muscle Memory (10x click, 10PP), Retained Knowledge (25% cheaper research, 25PP), Institutional Inertia (50% slower decay, 50PP), Accelerated Timeline (30% faster institutions, 75PP), Old Alliances (15% less country resistance, 100PP), Media Dynasty (2x GpS, 150PP), Event Fatigue (30% slower events, 200PP), Eternal Engine (100% offline, 500PP), Ontological Anchor (-20% drift cap, 1000PP), Recursive Greatness (5x GpS, 2500PP), Manifest Permanence (50x click, 5000PP), The Golden Constant (legitimacy floor 25%, 10000PP). Effects wired throughout engine: `calculateGPS` (gps_multiplier), `calculateUpgradeCost` (research_discount), `calculateLegitimacyDecay` (legitimacy_decay), `getDriftCap` (drift_cap), `getNextEventDelay` (event_cooldown), `tickInstitutions` (institution_speed), `completePhaseTransition` Phase 3 init (country_resistance). `components/PrestigePanel.tsx`: Modal overlay with stats (level, PP, PP on reset), prestige button with confirmation, upgrade tree with owned/affordable/locked states, prerequisite display. Accessible via infinity button (♾️) from Phase 2+.

---

## Sprint 8: Polish & Ship (Week 12-14)

### S8.1 — Offline Progression Polish
- [ ] Return screen with summary
- [ ] Offline event queue (max 10, auto-resolve if Legitimacy critical)
- [ ] Test extended offline periods

**Notes:**
_Update after completion_

### S8.2 — Full Achievement Pass
- [ ] Define all remaining achievements (45+ total)
- [ ] Achievement display panel with categories
- [ ] Meta achievements
- [ ] Test all achievement triggers

**Notes:**
_Update after completion_

### S8.3 — Sound Design
- [ ] Phase-specific ambient audio
- [ ] Event category sounds
- [ ] Phase transition audio
- [ ] Reality Drift audio distortion (Phase 4-5)
- [ ] Mute/volume controls

**Notes:**
_Update after completion_

### S8.4 — Balancing Pass
- [ ] Playtest Phase 1 (target: 20-40 min)
- [ ] Playtest Phase 2 (target: 1-2 hours)
- [ ] Playtest Phase 3 (target: 2-4 hours)
- [ ] Playtest Phase 4 (target: 2-3 hours)
- [ ] Playtest Phase 5 (target: open-ended, satisfying loop)
- [ ] Tune all formulas, costs, timings
- [ ] Document final balance values in spec.md

**Notes:**
_Update after completion_

### S8.5 — Monetization & Cosmetics
- [ ] Ad removal flag
- [ ] Cosmetic themes (Gold Plated, War Room, Void, Retro Terminal)
- [ ] Time skip tokens
- [ ] Executive Package bundle
- [ ] IAP integration (Capacitor plugin, later)

**Notes:**
_Update after completion_

### S8.6 — Mobile Build & Deployment
- [ ] Capacitor setup for iOS and Android
- [ ] Test on mobile devices
- [ ] Deploy web version (Vercel/Netlify)
- [ ] App store assets (screenshots, description)
- [ ] Submit to app stores

**Notes:**
_Update after completion_

---

## Session Handoff Protocol

After every coding session, ensure:

1. [x] ← Check off completed tasks above
2. Update **Notes** under the completed sprint task with:
   - What was built
   - Any deviations from plan
   - Known issues or tech debt
3. If spec.md or context.md need updates, do it
4. Commit all code changes
5. The next session starts by reading these md files and picking up the next `[ ]` task
