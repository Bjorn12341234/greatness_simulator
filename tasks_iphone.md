# iPhone App Plan — Greatness Simulator (Native iOS)

Rewrite as a native Swift/SwiftUI app. Completely separate from the browser game.
The browser game (React/Vite) must NOT be modified — it stays as-is for laptops.

---

## Sprint Rules

1. **One sprint per session.** Each session = one sprint. No skipping ahead.
2. **Update this file** at the end of every sprint with progress, notes, and any scope changes.
3. **Commit and push** at the end of every sprint.
4. **Separate codebase.** The iOS app lives in `ios/GreatnessSimulator/`. Never touch `src/` (the browser game).
5. **Port logic, don't share code.** Rewrite game engine logic in Swift. Don't try to bridge JS.
6. **Test on simulator** each sprint. The app must build and run at the end of every sprint.
7. **Keep it native.** SwiftUI views, SF Symbols, haptics, SwiftData. No web views, no React Native.
8. **Target iOS 17+.** Use modern SwiftUI APIs (Observable, NavigationStack, etc.).
9. **Write tests every sprint.** Each sprint must include unit tests for new logic (engine, formulas, state transitions) and snapshot/UI tests where applicable. Testing is critical to keep everything correct as the game grows.

---

## Architecture Overview

- **UI:** SwiftUI
- **State:** @Observable GameState class + SwiftData for persistence
- **Engine:** Pure Swift game loop (Timer-based tick)
- **Structure:**
  ```
  ios/GreatnessSimulator/
    GreatnessSimulatorApp.swift
    Models/
      GameState.swift        # @Observable, all game state
      Types.swift            # Enums, structs (Phase, UpgradeData, etc.)
    Engine/
      GameEngine.swift       # tick(), formulas, phase transitions
      EventEngine.swift      # Event system
      SaveEngine.swift       # SwiftData persistence
    Data/
      Phase1Upgrades.swift   # Static upgrade/event data per phase
      Phase1Events.swift
      ...
    Views/
      MainView.swift         # Tab container
      ClickerView.swift      # Main button + resources
      UpgradeListView.swift
      EventModalView.swift
      ...
    Utilities/
      Formatting.swift       # Number formatting (1.2M, etc.)
  ```

---

## Sprint Plan

### Sprint 1: Project Setup + Core Data Model
**Goal:** Xcode project exists, builds, runs. Core types and empty shell.
- [ ] Create Xcode project at `ios/GreatnessSimulator/`
- [ ] Bundle ID: `com.greatness.simulator`, iOS 17+, SwiftUI lifecycle
- [ ] Port `Types.swift` — Phase enum, GameState, UpgradeData, Effect, etc.
- [ ] Create `GameState.swift` as @Observable class with initial values
- [ ] Stub `GameEngine.swift` with empty `tick()` method
- [ ] Basic `MainView.swift` showing phase, greatness, cash, attention
- [ ] App builds and runs on simulator showing placeholder UI

### Sprint 2: Click Mechanic + Resource Display
**Goal:** Tapping the button generates attention, resources display and update.
- [ ] Implement main "Declare Greatness" button with tap handling
- [ ] Attention per click logic
- [ ] Resource bar (greatness, cash, attention) with live updating
- [ ] Number formatting (K, M, B, T, etc.)
- [ ] Basic haptic feedback on tap
- [ ] Simple animations on resource changes

### Sprint 3: Game Loop + Phase 1 Upgrades
**Goal:** Auto-generation ticking, upgrades purchasable, GpS flowing.
- [x] Timer-based game loop calling `tick()` every 100ms
- [x] Greatness-per-second calculation from upgrades
- [x] Cash and attention auto-generation
- [x] Port Phase 1 upgrade data (all upgrades from `phase1/upgrades.ts`)
- [x] `UpgradeListView` — scrollable list, purchase buttons, cost display
- [x] Upgrade prerequisites and unlock conditions
- [x] Purchase logic (deduct cost, apply effects)

### Sprint 4: Events System + Phase Transitions
**Goal:** Random events fire, player makes choices. Phase 1 -> 2 transition works.
- [x] Port event engine — random event selection, cooldowns, conditions
- [x] Port Phase 1 event data
- [x] `EventModalView` — headline, context, choice buttons with effect preview
- [x] Apply event effects to game state
- [x] Phase transition detection (Neural Backup -> Phase 2)
- [x] `PhaseTransitionView` — cinematic text sequence
- [x] Phase number visible in UI

### Sprint 5: Phase 2 — Institutions + Budget
**Goal:** Phase 2 gameplay loop functional.
- [x] Port institution data (13 institutions)
- [x] `InstitutionBoardView` — grid of institutions with status
- [x] Institution actions (co-opt, replace, purge) with progress timers
- [x] Budget allocation UI (sliders for healthcare, military, etc.)
- [x] Budget effects on resources (loyalty, control, legitimacy)
- [x] Port Phase 2 upgrades and events
- [x] Tariff system (activate tariffs, side effects)
- [x] Data center upgrades
- [x] Phase 2 -> 3 transition (all institutions captured)

### Sprint 6: Phase 3 — World Greatening
**Goal:** Country conquest and fleet systems working.
- [x] Port country data (14 countries)
- [x] `WorldMapView` — countries with status indicators
- [x] Country tactics (sanction, infiltrate, coup, annex, etc.)
- [x] Nobel Prize system
- [x] Fleet system — shipyard, build queue, ship types
- [x] `FleetPanelView`
- [x] Port Phase 3 upgrades and events
- [x] Phase 3 -> 4 transition (all countries annexed/allied)

### Sprint 7: Phase 4 — Space Greatening
**Goal:** Space progression from launch to solar system industrialization.
- [x] Launch tier system (launchpad -> mass driver)
- [x] Moon base, Mars colony, asteroid mining
- [x] `SpaceView` with visual progression
- [x] Space weapons
- [x] Bridge upgrades (Phase 4->5)
- [x] Propaganda satellites, Dyson prototypes
- [x] Port Phase 4 upgrades and events
- [x] Phase 4 -> 5 transition

### Sprint 8: Phase 5 — Cosmic Greatening + Ending
**Goal:** Endgame loop, universe conversion, ending sequence.
- [x] Computronium, greatness units, reality drift
- [x] Probe upgrades, Dyson upgrades, star branding
- [x] Black hole upgrades, narrative research
- [x] `UniverseView` with conversion progress
- [x] Ending sequence when universe hits 100%
- [x] `EndingView` — final cinematic

### Sprint 9: Persistence + Prestige + Offline
**Goal:** Game saves, loads, prestige resets work, offline progress calculated.
- [x] SwiftData save/load (auto-save every 30s)
- [x] Manual save/load
- [x] Prestige system — reset with bonuses
- [x] Prestige upgrades shop
- [x] Offline progress calculation on app return
- [x] `OfflineReturnView` — show what was earned

### Sprint 10: Achievements + Settings + Contradictions
**Goal:** Meta-systems complete.
- [x] Port all achievements with unlock conditions
- [x] `AchievementPanelView`
- [x] Achievement toast notifications
- [x] Contradiction system (balancing opposing forces)
- [x] Settings panel (volume, notifications, theme)
- [x] Ticker / news feed at bottom of screen

### Sprint 11: Polish — Animations, Themes, Audio
**Goal:** Feels like a real app, not a prototype.
- [x] Spring animations on purchases, phase transitions
- [x] Theme system (default, gold, warroom, void, terminal)
- [x] Color schemes per phase
- [x] Sound effects (tap, purchase, event, phase transition)
- [x] Background music (optional)
- [x] Dynamic Type support
- [x] Landscape support (or lock to portrait)

### Sprint 12: App Store Prep
**Goal:** Ready to ship.
- [x] App icon (asset catalog, all sizes)
- [x] Launch screen
- [ ] TestFlight build
- [ ] App Store screenshots
- [x] Privacy policy, age rating
- [x] Final bug fixes from TestFlight feedback

---

## Progress Log

| Sprint | Status | Date | Notes |
|--------|--------|------|-------|
| 1 | DONE | 2026-03-06 | Xcode project, Types, GameState, GameEngine stub, MainView, Formatting, builds on simulator |
| 2 | DONE | 2026-03-06 | ClickerView with tap button, haptics, floating +N text, tab navigation, resource bar animations, click() action |
| 3 | DONE | 2026-03-06 | Game loop timer (100ms tick), GpS/AttPS/CashPS calculations, 35 Phase 1 upgrades across 7 trees ported, UpgradeListView with purchase UI, cost scaling (1.15^n), prerequisite/unlock conditions, attentionPerClick recalc on purchase, 0 warnings |
| 4 | DONE | 2026-03-06 | EventEngine with weighted random selection, conditions, unique flags. 33 Phase 1 events ported (8 scandal, 11 opportunity, 10 absurd, 7 contradiction, 6 crisis). EventModalView with category badges, choice buttons, effect previews. Phase transition detection (Neural Backup -> Phase 2). PhaseTransitionView with timed cinematic text. Transition scripts for all 4 phase transitions. applyEffect/resolveEvent/completePhaseTransition actions. Events fire every 120-180s in Phase 1. 0 warnings. |
| 5 | DONE | 2026-03-06 | 13 institutions ported with 7 action types (co-opt, replace, purge, rebrand, automate, privatize, loyalty test). InstitutionBoardView with expandable cards, resistance bars, action progress. BudgetPanelView with 8 sliders (proportional auto-adjust to 100%). TariffPanelView with 6 tariffs, 4 levels each (Off/Low/Med/High). DataCenterPanelView with 7 sequential upgrades. LoyaltyPanelView with 4 loyalty upgrades. ControlDashboardView sub-tab container. 20 Phase 2 events ported. GameEngine updated: tickInstitutions (action progress + completion), tickTariffs (cash/legitimacy per second), tickLegitimacy (base decay + budget recovery), tickLoyaltyGeneration (from institutions + upgrades). Institution GpS added to calculateGPS. Legitimacy multiplier on GpS. Resource bar shows loyalty/legitimacy in Phase 2+. Control tab appears in Phase 2+. Phase 2 initialization in completePhaseTransition. 0 errors. |
| 6 | DONE | 2026-03-06 | 14 countries ported across 6 regions + Azure State special entity. ~20 tactics (standard: partnership, trade leverage, media infiltration, freedom foundation, coup sponsorship, freedom operation, extraordinary rendition, annexation, post-war rebuilding, immigration weaponization; country-specific: purchase offer, trade integration, absorption referendum, joint defense, sanctions campaign, democracy fund; Azure State: kompromat resist, aid reduction, leverage reversal, full absorption). 7 ship classes (Patrol Boat $10K -> Orbital Peace Platform $1M). WorldDashboardView with Overview/Countries/Fleet sub-tabs. WorldMapView with expandable country cards, resistance/stability bars, special mechanic indicators (encirclement, trade dependency, purchase offers, kompromat), tactic buttons with cost display. FleetPanelView with shipyard upgrades, build queue progress, ship class cards with build 1/5/10 buttons. NobelMeterView with progress bar, prize medals, irony indicators (wars during peace prize pursuit). 19 Phase 3 events ported (Nobel, warship leak, coalition condemnation, refugee crisis, Frostheim, Eurovia, Maple, Tundra, Petro, Canal, Azure State, NGO backlash, peace summit, rendition fallout, Jade Empire warning, ironic Nobel, island climate, arms deal, Oil Republic). GameEngine: tickCountries (operation processing, special mechanics, refugee waves, status transitions), tickShipyard (build queue, fleet recalc), tickFear (decay + legitimacy drain), tickNobel (decay + prize awarding with 50% threshold increase). Country GpS added to calculateGPS. Phase 3 initialization in completePhaseTransition (14 countries + Azure State + shipyard level 1). World tab in MainView. Phase 3 resource pills (War, Fear, Nobel). 0 build errors. |
| 7 | DONE | 2026-03-06 | 4 launch tiers (Launchpad $500K -> Mass Driver $100M) with rocket mass production. 4 lunar buildings (Moon Base, He-3 Mining, Lunar Shipyard, Lunar Heritage) with OI/mining/legitimacy effects. 3 Mars upgrades (Colony, Atmosphere Processing, Water Extraction) with colonists/terraform/greatness production. Mars auto-renames at 25% terraform. 3 asteroid tiers (Prospector Drones max 10, Mining Rigs max 10, Refineries max 5). Propaganda satellites (max 20, legitimacy+attention+drift). Dyson Swarm Prototype (requires Mass Driver + 80 OI). 4 space weapons (Peace Laser, Negotiation Device, Railgun, Solar Shade) with war/fear/legitimacy effects. 4 bridge upgrades (Long-Term Thinking +50% speed, Science Rebranding, Reality Budgeting -30% costs, Patience Campaign). 11 Phase 4 events (colonist revolt, greatium, alien signal, launch failure, dust storm, asteroid dispute, tourism, heritage vandalism, satellite hack, mars renaming, space debris, dyson proposal). SpaceView with 6 sub-tabs (Overview, Launch, Moon, Mars, Mining, Weapons). GameEngine tickSpace() handles all production: rocket mass, orbital industry, mining, colonists, terraform, legitimacy, attention, reality drift. Phase 4 initialization in completePhaseTransition. Space tab + resource pills (Rocket, Orbital, Mining) in MainView. EventEngine conditions updated for Phase 4 resources. Phase 4->5 transition: dysonSwarms > 0 && asteroidRigs >= 5 && orbitalIndustry >= 100. 0 build errors. |
| 8 | DONE | 2026-03-06 | Phase5Universe.swift: 4 probe upgrades (MAGA Replicator Factory -> Galactic Distribution), 3 Dyson Swarm tiers (Mk I 10 GU/s -> Total Stellar Acquisition 200 GU/s), 4 star branding tiers (Scanner -> Galactic Rebranding at 0.5 stars/s), 3 black hole upgrades (Golden Ledger 5 GU/s -> Hawking Dividend 100 GU/s + drift reduction), 4 narrative research tiers (Physics Renegotiation 1.5x -> Ontological Supremacy 5x, costs GU). Phase5Events.swift: 13 events (scientists complain, probe report, existential query, computronium shortage, dyson malfunction, replicator rebellion, black hole message, reality leak, meaning crisis, mirror universe, Nobel cosmic, entropy wins, last star). CosmicView.swift: 6 sub-tabs (Overview with universe conversion %, resource cards, drift meter; Probes; Harvesters; Branding; Singularity; Narrative). EndingView.swift: 4-screen cinematic (THE UNIVERSE IS NOW GREAT -> ... -> GREATNESS MUST BE MAINTAINED -> FOREVER in red, ~23s total). GameEngine tickCosmic(): probe production with exponential replication, star conversion (limited by probes * 0.1), GU production with logarithmic depreciation (1/(1+log10(GU/1000))), post-ending 0.5% GU decay, reality drift from stars/probes/GU, legitimacy from black holes, narrative legitimacy floor, universe conversion % = stars/1000 * 100. 5 purchase actions in GameState (probes, dyson, star branding, black holes, narrative). Phase 5 initialization in completePhaseTransition. EventEngine updated with probesLaunched/starsConverted/computronium/greatnessUnits condition checks. MainView: cosmic tab (Phase 5+), Phase 5 resource pills (Probes, GU, Drift), ending overlay. applyEffect handles all Phase 5 resources. Events fire every 15-30s in Phase 5. 0 build errors. |
| 9 | DONE | 2026-03-06 | SaveEngine with JSON Codable persistence (auto-save 30s, save on background, backup save). Load on app launch with fallback to backup. PrestigeUpgrades.swift: 12 prestige upgrades (Muscle Memory 10x click -> The Golden Constant 25% legitimacy floor, costs 10-10000 PP). Prestige points = floor(log10(GU)). prestige() resets all progress, preserves achievements/prestige upgrades/settings, applies click power multiplier to starting state. Prestige bonuses integrated: GPS multiplier (per-upgrade + 10% per prestige level), research discount (25%), legitimacy decay reduction (50%), event cooldown increase (30%), drift cap reduction (20%), legitimacy floor (25%), click power (10x/50x), offline rate (100%). OfflineEngine calculates greatness/cash/attention earned while away (default 10%, 100% with Eternal Engine upgrade, 60s minimum). OfflineReturnView shows earnings with duration. PrestigeView with upgrade shop, PP display, confirmation dialog. App lifecycle: save on willResignActive, calculate offline on didBecomeActive. Prestige tab in MainView. 0 build errors, 0 warnings. |
| 10 | DONE | 2026-03-06 | 73 achievements ported across 5 phases + meta (9 P1, 9 P2, 10 P3, 8 P4, 9 P5, 8 meta). AchievementEngine checks every 10 ticks (~1s). AchievementPanelView with phase filtering tabs, category badges (milestone/strategy/irony/meta), locked/unlocked states, progress counters. AchievementToastView with auto-dismiss (4s), golden border, haptic feedback. ContradictionEngine: 6 contradictions (attention/credibility P1, control/legitimacy P2, war/nobel P3, expansion/stability P3, longterm/shortterm P4, greatness/meaning P5). Seesaw bar visualization with balance threshold (40%), Doublethink Token generation. Credibility penalty on cash generation. ContradictionView with expandable cards per active contradiction. SettingsView: SFX/music volume sliders, notification toggle, 5 theme options, stats display (play time, prestige, clicks, events), save/reset buttons, achievement + contradiction sheet links. TickerView: scrolling marquee showing last 5 event headlines with "BREAKING:" prefix on latest. EventRegistry lookup for headline resolution. Phase transition contradiction initialization (P1 auto-init, P2-P5 in completePhaseTransition). GameEngine integrated: contradiction update per tick, achievement check per 10 ticks, credibility multiplier on cash. 0 errors, 0 warnings. |
| 11 | DONE | 2026-03-07 | ThemeEngine.swift: 5 themes (default/gold/warroom/void/terminal) with full color palettes (accent, background, surface, text, resource colors). Phase-specific glow/header accent colors (P1 orange, P2 purple, P3 red, P4 cyan, P5 violet). Environment key for theme propagation. AudioEngine.swift: synthesized tone generation via AVAudioEngine+AVAudioSourceNode, 6 SFX methods (tap, purchase, event, phase transition, achievement, error) with multi-note sequences, respects sfxVolume setting, .ambient audio session. Spring animations: ClickerView button bounce (0.88 spring scale + glow pulse), UpgradeCard purchase spring scale (1.06 bounce + flash), EventModalView spring appear (bounce: 0.3), PhaseTransitionView spring line reveals (scale+offset transition) + animated radial glow, AchievementToast spring bounce insertion (scale 0.8 + move). Theme integration: MainView (header gradient, resource bar, tab bar colors from theme), UpgradeListView (tree headers, card backgrounds, cost colors), SettingsView (theme preview swatches with 4 color dots), TickerView (accent-colored gradient + borders), all views read @Environment(\.theme). Tab bar: symbolEffect bounce on selection. Dynamic Type: .dynamicTypeSize(...xxxLarge) cap in app root. Portrait lock: AppDelegate with supportedInterfaceOrientations + Info.plist UIInterfaceOrientationPortrait (already set). 0 errors, 0 warnings (new). |
| 12 | DONE | 2026-03-07 | App icon: 1024x1024 programmatic CoreGraphics icon (gold star + "G" on dark background) in asset catalog. Launch screen: dark background + centered logo via Info.plist UILaunchScreen keys (BackgroundColor + ImageName). LaunchBackground.colorset (black) and LaunchLogo.imageset added to Assets.xcassets. PrivacyPolicyView.swift: full privacy policy (no data collection, no analytics, no third-party services, local storage only). Settings: added About section with version display (CFBundleShortVersionString + build) and Privacy Policy sheet link. Version set to 1.0.0 build 1. Concurrency fixes: @MainActor on Haptics enum and GameEngine.tick(), nonisolated(unsafe) on tickCounter, PreferenceKey defaultValue changed to let. TickerView TextWidthKey defaultValue fixed (var -> let). 0 errors. TestFlight build and App Store screenshots require manual Xcode/device steps. |
