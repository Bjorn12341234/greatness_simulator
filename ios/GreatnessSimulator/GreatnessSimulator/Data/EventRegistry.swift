import Foundation

/// Lookup table for event headline by ID. Used by TickerView.
let allEventRegistry: [String: GameEvent] = {
    var map: [String: GameEvent] = [:]
    let allEvents = phase1Events + phase2Events + phase3Events + phase4Events + phase5Events
    for event in allEvents {
        map[event.id] = event
    }
    return map
}()
