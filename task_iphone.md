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
- [ ] Launch tier system (launchpad -> mass driver)
- [ ] Moon base, Mars colony, asteroid mining
- [ ] `SpaceView` with visual progression
- [ ] Space weapons
- [ ] Bridge upgrades (Phase 4->5)
- [ ] Propaganda satellites, Dyson prototypes
- [ ] Port Phase 4 upgrades and events
- [ ] Phase 4 -> 5 transition

### Sprint 8: Phase 5 — Cosmic Greatening + Ending
**Goal:** Endgame loop, universe conversion, ending sequence.
- [ ] Computronium, greatness units, reality drift
- [ ] Probe upgrades, Dyson upgrades, star branding
- [ ] Black hole upgrades, narrative research
- [ ] `UniverseView` with conversion progress
- [ ] Ending sequence when universe hits 100%
- [ ] `EndingView` — final cinematic

### Sprint 9: Persistence + Prestige + Offline
**Goal:** Game saves, loads, prestige resets work, offline progress calculated.
- [ ] SwiftData save/load (auto-save every 30s)
- [ ] Manual save/load
- [ ] Prestige system — reset with bonuses
- [ ] Prestige upgrades shop
- [ ] Offline progress calculation on app return
- [ ] `OfflineReturnView` — show what was earned

### Sprint 10: Achievements + Settings + Contradictions
**Goal:** Meta-systems complete.
- [ ] Port all achievements with unlock conditions
- [ ] `AchievementPanelView`
- [ ] Achievement toast notifications
- [ ] Contradiction system (balancing opposing forces)
- [ ] Settings panel (volume, notifications, theme)
- [ ] Ticker / news feed at bottom of screen

### Sprint 11: Polish — Animations, Themes, Audio
**Goal:** Feels like a real app, not a prototype.
- [ ] Spring animations on purchases, phase transitions
- [ ] Theme system (default, gold, warroom, void, terminal)
- [ ] Color schemes per phase
- [ ] Sound effects (tap, purchase, event, phase transition)
- [ ] Background music (optional)
- [ ] Dynamic Type support
- [ ] Landscape support (or lock to portrait)

### Sprint 12: App Store Prep
**Goal:** Ready to ship.
- [ ] App icon (asset catalog, all sizes)
- [ ] Launch screen
- [ ] TestFlight build
- [ ] App Store screenshots
- [ ] Privacy policy, age rating
- [ ] Final bug fixes from TestFlight feedback

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
| 7 | Not started | — | — |
| 8 | Not started | — | — |
| 9 | Not started | — | — |
| 10 | Not started | — | — |
| 11 | Not started | — | — |
| 12 | Not started | — | — |
