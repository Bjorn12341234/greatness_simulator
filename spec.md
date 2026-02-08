# ORANGE MAN — Technical Specification

## 1) Game State Schema

All game state lives in a single Zustand store. This is the master type definition.

```typescript
interface GameState {
  // Meta
  phase: 1 | 2 | 3 | 4 | 5;
  startedAt: number;          // timestamp
  lastTickAt: number;         // timestamp
  lastSaveAt: number;         // timestamp
  totalPlayTime: number;      // seconds
  prestigeLevel: number;
  prestigePoints: number;

  // Core Resources
  greatness: number;          // lifetime total (never decreases)
  greatnessPerSecond: number; // computed each tick
  cash: number;
  attention: number;
  influence: number;

  // Phase 2+
  loyalty: number;
  control: number;
  legitimacy: number;         // 0-100 percentage
  surveillance: number;       // from Data Centers

  // Budget allocation (Phase 2+) — percentages that must sum to 100
  budget: BudgetAllocation;

  // Tariffs (Phase 2+)
  tariffs: Record<string, TariffState>;

  // Data Centers (Phase 2+)
  dataCenterUpgrades: Record<string, boolean>;

  // Phase 3+
  treatyPower: number;
  sanctions: number;
  annexationPoints: number;
  warOutput: number;
  nobelScore: number;
  nobelPrizesWon: number;
  nobelThreshold: number;     // increases each win
  fear: number;

  // Phase 4+
  rocketMass: number;
  orbitalIndustry: number;
  miningOutput: number;
  colonists: number;
  terraformProgress: number;  // 0-100 percentage

  // Phase 5+
  computronium: number;
  greatnessUnits: number;
  realityDrift: number;       // 0-100 percentage
  starsConverted: number;
  probesLaunched: number;

  // Tracking
  clickCount: number;
  attentionPerClick: number;

  // Upgrades — keyed by upgrade ID
  upgrades: Record<string, UpgradeState>;

  // Phase 2: Institutions
  institutions: Record<string, InstitutionState>;

  // Phase 3: Countries
  countries: Record<string, CountryState>;

  // Phase 3: Fleet
  fleet: Record<string, number>; // shipClassId → count

  // Phase 4: Space infrastructure
  space: SpaceState;

  // Contradictions
  contradictions: Record<string, ContradictionState>;

  // Events
  eventQueue: GameEvent[];
  eventHistory: string[];     // IDs of resolved events
  activeEvent: GameEvent | null;

  // Achievements
  achievements: Record<string, boolean>;

  // Prestige upgrades (persist across resets)
  prestigeUpgrades: Record<string, boolean>;

  // Settings
  settings: {
    musicVolume: number;
    sfxVolume: number;
    notificationsEnabled: boolean;
    theme: string;
  };
}

interface UpgradeState {
  purchased: boolean;
  count: number;            // for repeatable upgrades
  unlocked: boolean;        // visible to player
}

interface InstitutionState {
  status: 'independent' | 'co-opting' | 'replacing' | 'purging' | 'captured' | 'automated';
  resistance: number;       // 0-100
  progress: number;         // 0-100 (for ongoing actions)
  actionStartedAt: number | null;
  rebranded: boolean;
}

interface CountryState {
  status: 'independent' | 'sanctioned' | 'infiltrated' | 'coup_target' | 'occupied' | 'annexed' | 'allied';
  resistance: number;       // 0-100
  stability: number;        // 0-100
  activeOperations: string[];
  refugeeWavesSent: number; // for Refugee Engine mechanic
  encirclement: number;     // 0-100, Tundra Republic special
  tradeDependency: number;  // 0-100, Maple Federation special
  purchaseOffers: number;   // Frostheim special
}

interface BudgetAllocation {
  healthcare: number;       // 0-100 percentage of budget
  education: number;
  socialBenefits: number;
  military: number;
  dataCenters: number;
  infrastructure: number;
  propagandaBureau: number;
  spaceProgram: number;
}

interface TariffState {
  active: boolean;
  level: number;            // 0-3 (off, low, medium, high)
  cashGenerated: number;    // total cash earned from this tariff
  sideEffectAccumulated: number;
}

interface ContradictionState {
  sideA: number;            // 0-100
  sideB: number;            // 0-100
  balancedTime: number;     // seconds both above threshold
  active: boolean;
}

interface SpaceState {
  launchTier: 'none' | 'launchpad' | 'spaceport' | 'orbital_elevator' | 'mass_driver';
  moonBase: boolean;
  helium3Mining: boolean;
  lunarShipyard: boolean;
  marsColony: boolean;
  marsRenamed: boolean;
  asteroidRigs: number;
  propagandaSatellites: number;
  dysonSwarms: number;
  vonNeumannProbes: number;
}

interface GameEvent {
  id: string;
  phase: number;
  category: 'scandal' | 'opportunity' | 'contradiction' | 'absurd' | 'crisis' | 'nobel' | 'reality_glitch';
  headline: string;
  context: string;
  choices: EventChoice[];
  conditions?: EventCondition[];  // when can this fire
  cooldown?: number;              // min seconds between firings
  unique?: boolean;               // fire only once
}

interface EventChoice {
  label: string;
  effects: Effect[];
  description?: string;           // shown as hint
}

interface Effect {
  resource: string;
  amount: number;
  type: 'add' | 'multiply' | 'set';
  duration?: number;              // temporary effect in seconds
}
```

## 2) Game Loop

The core tick runs every **100ms** (10 ticks per second).

```
Each tick:
  1. Calculate deltaTime since lastTick
  2. Apply resource generation:
     - attention += attentionPerSecond * dt
     - cash += cashPerSecond * dt
     - greatness += GpS * dt
     - (other resources based on phase)
  3. Apply decay:
     - legitimacy -= decayRate * dt
     - nobelScore -= nobelDecayRate * dt (if any)
  4. Update contradictions:
     - Recalculate seesaw positions
     - Award Doublethink Tokens if balanced
  5. Check event triggers:
     - Time-based (random within frequency range)
     - Threshold-based (resource hits a value)
     - Phase-based (phase transition events)
  6. Check phase transition conditions
  7. Check achievement conditions
  8. Update computed values (GpS, multipliers)
  9. Update lastTickAt
```

## 3) Formula Reference

### Greatness per Second (GpS)
```
GpS = base_production * legitimacy_multiplier * phase_multiplier * prestige_bonus
```
- `base_production` = sum of all upgrade/institution/country production
- `legitimacy_multiplier`:
  - `>80%` → 1.2
  - `50-80%` → 1.0
  - `25-49%` → 0.7
  - `<25%` → 0.4
- `phase_multiplier`: 1, 10, 100, 10000, 1000000
- `prestige_bonus` = 1 + (0.1 * prestigeLevel)

### Upgrade Cost Scaling
```
cost(n) = base_cost * 1.15^n
```

### Budget Effects on Production
```
healthcare_bonus = budget.healthcare * 0.003           // legitimacy recovery per second
education_bonus = budget.education * 0.001             // reality drift reduction per second
social_bonus = budget.socialBenefits * 0.002           // legitimacy recovery per second
military_bonus = budget.military * 0.01                // war output multiplier
datacenter_bonus = budget.dataCenters * 0.005          // attention + surveillance multiplier
infra_bonus = budget.infrastructure * 0.003            // cash generation multiplier
propaganda_bonus = budget.propagandaBureau * 0.004     // legitimacy generation multiplier
space_bonus = budget.spaceProgram * 0.002              // space research speed multiplier
```
Defunding healthcare + education + social below 10% each triggers "Austerity Crisis" events.

### Tariff Effects
```
tariff_cash = base_rate * tariff_level
tariff_production_penalty = tariff_level * 0.05        // per active tariff
tariff_resistance_increase = allied_tariffs * 5        // per allied nation tariffed
```

### Legitimacy Decay
```
decay_per_second = 0.001 + (captured_institutions * 0.0002) + (active_wars * 0.005) + (reality_drift * 0.001) + (defunded_social_penalty * 0.003)
```

### Nobel Score Diminishing Returns
```
effective_gain = base_gain * (1 / (1 + times_used * 0.1))
```

### Reality Drift Accumulation
```
drift_per_event = (rebranding * 0.5%) + (scientist_firings * 1%) + (star_conversions * 1%) - (science_funding * 0.2%)
```

### Fear Effect on Resistance
```
resistance_reduction = fear * 0.01  // applied globally per tick
```

### Offline Progression
```
offline_greatness = GpS * elapsed_seconds * offline_rate
```
- Base `offline_rate` = 0.1 (10%)
- Upgradeable to 0.5 (50%)
- Prestige "Eternal Engine" = 1.0 (100%)

## 4) Save System

### Format
JSON blob stored in `localStorage` under key `orange_man_save`.

### Auto-save
Every 30 seconds. Also saves on:
- Phase transition
- Event resolution
- Tab becoming hidden (visibilitychange)
- Manual save button

### Export/Import
Base64-encoded JSON string. Copy/paste for backup.

### Schema Versioning
```typescript
interface SaveFile {
  version: number;        // increment on breaking changes
  savedAt: number;        // timestamp
  state: GameState;
}
```

Migration functions handle version upgrades: `migrate_v1_to_v2(state)`, etc.

## 5) Event Engine

### Event Scheduling
Each phase defines a frequency range (min/max seconds between events). When an event resolves, the next one is scheduled:
```
nextEventIn = random(minFrequency, maxFrequency)
```

| Phase | Min (sec) | Max (sec) |
|---|---|---|
| 1 | 120 | 180 |
| 2 | 60 | 120 |
| 3 | 45 | 90 |
| 4 | 30 | 60 |
| 5 | 15 | 30 |

### Event Selection
1. Filter events by: phase, conditions met, not on cooldown, not unique+already-fired
2. Weight by category (crises are rarer, opportunities common)
3. Random weighted selection

### Event Resolution
Player picks a choice → effects applied instantly (or over duration) → event added to history → next event scheduled.

## 6) Phase Transitions

Each phase has an **end condition** checked every tick:

| Phase | Condition |
|---|---|
| 1 → 2 | Neural Backup research purchased |
| 2 → 3 | All 13 institutions captured |
| 3 → 4 | All 14 countries annexed |
| 4 → 5 | Solar System = "Greatness Industrial Zone" (all bodies claimed + max orbital industry) |
| 5 → End | 100% reachable universe converted |

### Transition Sequence
1. Pause game tick
2. Show transition overlay (text sequence with delays)
3. Unlock new tab
4. Grey out / transform old UI elements
5. Initialize new phase state
6. Resume tick
7. Auto-save

## 7) Component Rendering Strategy

- **Dashboard** always renders (it's the home tab)
- **Other tabs** render only when active (lazy)
- **Meters** (Greatness, Legitimacy, Nobel) use `requestAnimationFrame` for smooth animation, not React re-renders
- **Ticker** is a CSS animation scrolling div, content updated from event history
- **Numbers** use a formatting utility:
  - < 1,000: show exact
  - < 1,000,000: show with commas (1,247,892)
  - < 1B: show with suffix (247.3M)
  - >= 1B: scientific-ish (4.7 trillion, 2.3 octillion)

## 8) Reality Drift UI Effects (Phase 3+)

Implemented as CSS classes and JS overrides applied based on drift level:

| Drift | Effect Implementation |
|---|---|
| 20-40% | CSS `animation: flicker` on random number displays |
| 40-60% | Random label text swaps (setTimeout, restore after 2s) |
| 60-80% | Random value offsets (display ±10% of real value) |
| 80-100% | Full unreliable narrator: displayed values randomly ±50%, labels swap, fake events in ticker |

## 9) Mobile Considerations

- Bottom tab nav (thumb zone)
- Min touch target: 44x44px
- Main button: large, centered, satisfying tap feedback
- Event modals: full-screen on mobile, centered card on desktop
- Swipe between tabs (optional, later)
- Safe area insets for notch devices (Capacitor handles this)

## 10) Performance Budget

- Initial bundle: < 500KB gzipped
- Tick computation: < 5ms (leave 95ms for rendering at 100ms interval)
- No DOM updates on every tick — batch with requestAnimationFrame
- Event data loaded per-phase (code-split)
- Achievement checks batched (every 10 ticks, not every tick)

## 11) Animation & Visual Implementation

### Dependencies
- **Framer Motion** — Layout animations, spring physics, gesture handling, AnimatePresence for mount/unmount
- **Tailwind CSS** — Utility classes for layout, spacing, responsive. Custom theme with glassmorphism utilities.
- **CSS Modules** — For complex custom animations (particle effects, meter gradients, Reality Drift glitches)

### Animation Catalog

| Element | Animation | Implementation |
|---|---|---|
| Main button press | Scale 0.95 → bounce back | Framer Motion `whileTap={{ scale: 0.95 }}` |
| Main button particles | Orange dots burst outward on click | Lightweight canvas overlay, 10-15 particles per click |
| Number counters | Smooth count-up to target value | Custom hook: `useAnimatedNumber(value, { duration: 300 })` |
| Meter fill | Gradient bar animates to new width | CSS `transition: width 0.3s ease-out` + dynamic gradient |
| Upgrade card appear | Slide up + fade in | Framer Motion `initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }}` |
| Upgrade purchase | Flash + floating "+1" | CSS `@keyframes flash` + absolute positioned animated div |
| Tab switch | Cross-fade with slight slide | Framer Motion `AnimatePresence` with exit/enter animations |
| Event modal open | Scale from 0.8 + fade + backdrop blur | Framer Motion `animate={{ scale: 1, opacity: 1 }}` |
| Phase transition | Fade to black → typewriter text → fade to new | Multi-step Framer Motion sequence with `useAnimate` |
| Achievement toast | Slide down from top + gold glow | Framer Motion + CSS `box-shadow` animation |
| Legitimacy pulse | Red glow pulse when dropping | CSS `@keyframes pulse-red` triggered by state |
| Ticker scroll | Continuous horizontal marquee | CSS `@keyframes marquee` with `translateX` |
| Reality Drift glitch | Random `transform: skew` + color shift | CSS class toggled by JS timer, duration based on drift level |

### Glassmorphism Card Recipe
```css
.glass-card {
  background: rgba(42, 42, 42, 0.6);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.3);
}

.glass-card:hover {
  border-color: rgba(255, 102, 0, 0.2);
  box-shadow: 0 4px 24px rgba(255, 102, 0, 0.1);
}
```

### Meter Component Spec
Custom React component (not `<progress>`):
- SVG-based or div-based with layered fills
- Background track: `rgba(255,255,255,0.05)`
- Fill: CSS `linear-gradient` matching resource color
- Glow: `box-shadow: 0 0 12px {color}` when above 80%
- Animated width transitions (CSS transition)
- Numeric overlay with animated counting
- Optional tick marks every 25% on the track

### Particle System
Lightweight canvas-based system (no library — keep it small):
- Particle pool: max 50 particles active
- Each particle: { x, y, vx, vy, life, color, size }
- Render at 60fps via `requestAnimationFrame` (separate from game tick)
- Gravity: subtle downward pull for click particles
- Fade: opacity = remaining life / max life
- Used for: button clicks, purchases, achievements, phase transitions

### Responsive Typography Scale
```css
--font-display: 2.5rem;    /* Large numbers (Greatness counter) */
--font-heading: 1.5rem;    /* Section headings */
--font-body: 1rem;         /* Normal text */
--font-label: 0.75rem;     /* Labels, hints, secondary info */
--font-ticker: 0.875rem;   /* News ticker text */

/* Monospace for numbers (prevents layout shift) */
--font-numbers: 'JetBrains Mono', 'Fira Code', monospace;
/* Sans for UI */
--font-ui: 'Inter', -apple-system, sans-serif;
/* Condensed for headlines/events */
--font-headline: 'Inter Tight', 'Arial Narrow', sans-serif;
```
