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
- [ ] Timer-based game loop calling `tick()` every 100ms
- [ ] Greatness-per-second calculation from upgrades
- [ ] Cash and attention auto-generation
- [ ] Port Phase 1 upgrade data (all upgrades from `phase1/upgrades.ts`)
- [ ] `UpgradeListView` — scrollable list, purchase buttons, cost display
- [ ] Upgrade prerequisites and unlock conditions
- [ ] Purchase logic (deduct cost, apply effects)

### Sprint 4: Events System + Phase Transitions
**Goal:** Random events fire, player makes choices. Phase 1 -> 2 transition works.
- [ ] Port event engine — random event selection, cooldowns, conditions
- [ ] Port Phase 1 event data
- [ ] `EventModalView` — headline, context, choice buttons with effect preview
- [ ] Apply event effects to game state
- [ ] Phase transition detection (Neural Backup -> Phase 2)
- [ ] `PhaseTransitionView` — cinematic text sequence
- [ ] Phase number visible in UI

### Sprint 5: Phase 2 — Institutions + Budget
**Goal:** Phase 2 gameplay loop functional.
- [ ] Port institution data (13 institutions)
- [ ] `InstitutionBoardView` — grid of institutions with status
- [ ] Institution actions (co-opt, replace, purge) with progress timers
- [ ] Budget allocation UI (sliders for healthcare, military, etc.)
- [ ] Budget effects on resources (loyalty, control, legitimacy)
- [ ] Port Phase 2 upgrades and events
- [ ] Tariff system (activate tariffs, side effects)
- [ ] Data center upgrades
- [ ] Phase 2 -> 3 transition (all institutions captured)

### Sprint 6: Phase 3 — World Greatening
**Goal:** Country conquest and fleet systems working.
- [ ] Port country data (14 countries)
- [ ] `WorldMapView` — countries with status indicators
- [ ] Country tactics (sanction, infiltrate, coup, annex, etc.)
- [ ] Nobel Prize system
- [ ] Fleet system — shipyard, build queue, ship types
- [ ] `FleetPanelView`
- [ ] Port Phase 3 upgrades and events
- [ ] Phase 3 -> 4 transition (all countries annexed/allied)

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
| 2 | Not started | — | — |
| 3 | Not started | — | — |
| 4 | Not started | — | — |
| 5 | Not started | — | — |
| 6 | Not started | — | — |
| 7 | Not started | — | — |
| 8 | Not started | — | — |
| 9 | Not started | — | — |
| 10 | Not started | — | — |
| 11 | Not started | — | — |
| 12 | Not started | — | — |
