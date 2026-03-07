import Foundation
import SwiftUI

// MARK: - Environment Key

private struct DriftSeedKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    var driftSeed: Int {
        get { self[DriftSeedKey.self] }
        set { self[DriftSeedKey.self] = newValue }
    }
}

// MARK: - Label Swap Pairs

private let labelSwapPairs: [(String, String)] = [
    // Header & Navigation
    ("GREATNESS", "COMPLIANCE"),
    ("Click", "Comply"),
    ("Upgrades", "Mandates"),
    ("Control", "Oversight"),
    ("World", "Domain"),
    ("Space", "Void"),
    ("Cosmic", "Entropy"),
    ("Prestige", "Rebirth"),
    ("Settings", "REDACTED"),

    // CosmicView section headers
    ("UNIVERSE CONVERSION", "REALITY ABSORPTION"),
    ("COSMIC RESOURCES", "VOID INVENTORY"),
    ("REALITY DRIFT", "FREEDOM INDEX"),
    ("SYSTEMS STATUS", "COMPLIANCE GRID"),
    ("MAGA REPLICATORS", "ASSIMILATION UNITS"),
    ("STAR BRANDING", "EXISTENCE TAGGING"),
    ("SOLAR GREATNESS HARVESTERS", "STELLAR COMPLIANCE ENGINES"),
    ("GOLDEN LEDGER SINGULARITY", "INFINITE AUDIT HORIZON"),
    ("NARRATIVE ARCHITECTURE", "TRUTH ENGINEERING"),
]

// MARK: - Label Swap Logic (drift >= 40%)

func driftSwapLabel(_ label: String, drift: Double, seed: Int) -> String {
    guard drift >= 40 else { return label }
    let swapChance = (drift - 40) / 60.0 * 0.3 // 0 at 40%, 0.3 at 100%
    let swapSeed = seed / 7 // Changes every ~2.1s (7 ticks at 0.3s)
    for (original, replacement) in labelSwapPairs {
        if label == original {
            let hash = abs(original.hashValue &+ swapSeed &* 2654435761)
            let roll = Double(hash % 1000) / 1000.0
            return roll < swapChance ? replacement : original
        }
    }
    return label
}

// MARK: - Value Jitter (drift >= 60%)

func driftJitterValue(_ value: Double, drift: Double, seed: Int) -> Double {
    guard drift >= 60 else { return value }
    let intensity = (drift - 60) / 40.0 // 0-1 range
    let maxOffset = value * 0.15 * intensity
    let jitter = sin(value * 13.37 + Double(seed) * 7.77) * maxOffset
    return value + jitter
}

// MARK: - View Modifiers

struct DriftFlickerModifier: ViewModifier {
    let drift: Double
    let seed: Int

    func body(content: Content) -> some View {
        let intensity = min(1.0, drift / 100.0)
        let isGlitch = drift >= 20 && (seed % 13 == 0)

        content
            .opacity(isGlitch ? 1.0 - intensity * 0.12 : 1.0)
            .hueRotation(.degrees(isGlitch ? intensity * 15 : 0))
            .saturation(isGlitch ? 1.0 + intensity * 0.3 : 1.0)
            .animation(.easeInOut(duration: 0.08), value: seed)
    }
}

struct DriftGlitchModifier: ViewModifier {
    let drift: Double
    let seed: Int

    func body(content: Content) -> some View {
        let intensity = drift >= 80 ? (drift - 80) / 20.0 : 0
        let isGlitch = drift >= 80 && (seed % 20 == 0)
        let direction: Double = seed % 2 == 0 ? 1 : -1

        content
            .offset(x: isGlitch ? intensity * 3.0 * direction : 0)
            .animation(.easeInOut(duration: 0.06), value: seed)
    }
}

extension View {
    func driftFlicker(drift: Double, seed: Int) -> some View {
        modifier(DriftFlickerModifier(drift: drift, seed: seed))
    }

    func driftGlitch(drift: Double, seed: Int) -> some View {
        modifier(DriftGlitchModifier(drift: drift, seed: seed))
    }
}
