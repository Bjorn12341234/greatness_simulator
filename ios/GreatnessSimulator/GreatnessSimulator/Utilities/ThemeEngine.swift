import SwiftUI

// MARK: - Game Theme

struct GameTheme {
    let accent: Color
    let accentSecondary: Color
    let background: Color
    let surface: Color
    let surfaceHighlight: Color
    let headerTop: Color
    let headerBottom: Color
    let tabBarBg: Color
    let text: Color
    let textSecondary: Color
    let purchaseFlash: Color
    let borderActive: Color

    // Per-resource overrides (nil = use default)
    let greatnessColor: Color
    let cashColor: Color
    let attentionColor: Color
}

// MARK: - Theme Definitions

let themes: [String: GameTheme] = [
    "default": GameTheme(
        accent: .orange,
        accentSecondary: .orange.opacity(0.7),
        background: Color.black,
        surface: Color(white: 0.08),
        surfaceHighlight: Color(white: 0.12),
        headerTop: Color.black,
        headerBottom: Color(white: 0.1),
        tabBarBg: Color(white: 0.08),
        text: .white,
        textSecondary: Color(white: 0.55),
        purchaseFlash: .orange,
        borderActive: .orange.opacity(0.4),
        greatnessColor: .yellow,
        cashColor: .green,
        attentionColor: .cyan
    ),
    "gold": GameTheme(
        accent: Color(red: 1.0, green: 0.84, blue: 0.0),
        accentSecondary: Color(red: 0.85, green: 0.65, blue: 0.13),
        background: Color(red: 0.06, green: 0.04, blue: 0.0),
        surface: Color(red: 0.1, green: 0.07, blue: 0.02),
        surfaceHighlight: Color(red: 0.15, green: 0.1, blue: 0.03),
        headerTop: Color(red: 0.05, green: 0.03, blue: 0.0),
        headerBottom: Color(red: 0.12, green: 0.08, blue: 0.0),
        tabBarBg: Color(red: 0.08, green: 0.05, blue: 0.0),
        text: Color(red: 1.0, green: 0.96, blue: 0.85),
        textSecondary: Color(red: 0.7, green: 0.6, blue: 0.4),
        purchaseFlash: Color(red: 1.0, green: 0.84, blue: 0.0),
        borderActive: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4),
        greatnessColor: Color(red: 1.0, green: 0.84, blue: 0.0),
        cashColor: Color(red: 0.7, green: 0.9, blue: 0.4),
        attentionColor: Color(red: 1.0, green: 0.7, blue: 0.3)
    ),
    "warroom": GameTheme(
        accent: Color(red: 0.4, green: 0.7, blue: 0.3),
        accentSecondary: Color(red: 0.3, green: 0.55, blue: 0.2),
        background: Color(red: 0.02, green: 0.04, blue: 0.02),
        surface: Color(red: 0.04, green: 0.08, blue: 0.04),
        surfaceHighlight: Color(red: 0.06, green: 0.12, blue: 0.06),
        headerTop: Color(red: 0.02, green: 0.04, blue: 0.02),
        headerBottom: Color(red: 0.04, green: 0.1, blue: 0.04),
        tabBarBg: Color(red: 0.03, green: 0.06, blue: 0.03),
        text: Color(red: 0.85, green: 0.95, blue: 0.85),
        textSecondary: Color(red: 0.45, green: 0.6, blue: 0.45),
        purchaseFlash: Color(red: 0.4, green: 0.7, blue: 0.3),
        borderActive: Color(red: 0.4, green: 0.7, blue: 0.3).opacity(0.4),
        greatnessColor: .yellow,
        cashColor: Color(red: 0.4, green: 0.8, blue: 0.3),
        attentionColor: Color(red: 0.3, green: 0.7, blue: 0.5)
    ),
    "void": GameTheme(
        accent: Color(red: 0.6, green: 0.3, blue: 1.0),
        accentSecondary: Color(red: 0.5, green: 0.2, blue: 0.8),
        background: Color(red: 0.02, green: 0.0, blue: 0.06),
        surface: Color(red: 0.05, green: 0.02, blue: 0.1),
        surfaceHighlight: Color(red: 0.08, green: 0.03, blue: 0.15),
        headerTop: Color(red: 0.02, green: 0.0, blue: 0.05),
        headerBottom: Color(red: 0.06, green: 0.02, blue: 0.12),
        tabBarBg: Color(red: 0.04, green: 0.01, blue: 0.08),
        text: Color(red: 0.9, green: 0.85, blue: 1.0),
        textSecondary: Color(red: 0.55, green: 0.45, blue: 0.7),
        purchaseFlash: Color(red: 0.6, green: 0.3, blue: 1.0),
        borderActive: Color(red: 0.6, green: 0.3, blue: 1.0).opacity(0.4),
        greatnessColor: Color(red: 1.0, green: 0.85, blue: 0.3),
        cashColor: Color(red: 0.3, green: 0.9, blue: 0.5),
        attentionColor: Color(red: 0.4, green: 0.7, blue: 1.0)
    ),
    "terminal": GameTheme(
        accent: Color(red: 0.0, green: 1.0, blue: 0.0),
        accentSecondary: Color(red: 0.0, green: 0.75, blue: 0.0),
        background: Color.black,
        surface: Color(red: 0.0, green: 0.04, blue: 0.0),
        surfaceHighlight: Color(red: 0.0, green: 0.08, blue: 0.0),
        headerTop: Color.black,
        headerBottom: Color(red: 0.0, green: 0.06, blue: 0.0),
        tabBarBg: Color(red: 0.0, green: 0.03, blue: 0.0),
        text: Color(red: 0.0, green: 1.0, blue: 0.0),
        textSecondary: Color(red: 0.0, green: 0.5, blue: 0.0),
        purchaseFlash: Color(red: 0.0, green: 1.0, blue: 0.0),
        borderActive: Color(red: 0.0, green: 1.0, blue: 0.0).opacity(0.4),
        greatnessColor: Color(red: 0.0, green: 1.0, blue: 0.0),
        cashColor: Color(red: 0.0, green: 0.8, blue: 0.3),
        attentionColor: Color(red: 0.3, green: 1.0, blue: 0.3)
    ),
]

// MARK: - Phase Color Accents

struct PhaseColors {
    let glow: Color
    let headerAccent: Color
}

let phaseColors: [Int: PhaseColors] = [
    1: PhaseColors(glow: .orange, headerAccent: .yellow.opacity(0.8)),
    2: PhaseColors(glow: .purple, headerAccent: .purple.opacity(0.8)),
    3: PhaseColors(glow: .red, headerAccent: .red.opacity(0.8)),
    4: PhaseColors(glow: .cyan, headerAccent: .cyan.opacity(0.8)),
    5: PhaseColors(glow: Color(red: 0.6, green: 0.2, blue: 1.0), headerAccent: Color(red: 0.7, green: 0.4, blue: 1.0)),
]

// MARK: - Theme Resolution

func resolveTheme(name: String) -> GameTheme {
    themes[name] ?? themes["default"]!
}

// MARK: - Environment Key

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: GameTheme = themes["default"]!
}

extension EnvironmentValues {
    var theme: GameTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
