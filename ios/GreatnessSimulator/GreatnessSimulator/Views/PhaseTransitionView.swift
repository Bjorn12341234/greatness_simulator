import SwiftUI

struct TransitionLine {
    let text: String
    let delay: Double   // seconds before showing
    let style: TransitionLineStyle

    init(_ text: String, delay: Double, style: TransitionLineStyle = .normal) {
        self.text = text
        self.delay = delay
        self.style = style
    }
}

enum TransitionLineStyle {
    case normal, bold, accent, dim
}

let transitionScripts: [String: [TransitionLine]] = [
    "1_2": [
        TransitionLine("NEURAL BACKUP COMPLETE", delay: 0, style: .bold),
        TransitionLine("Consciousness digitized.", delay: 2),
        TransitionLine("The brand is now immortal.", delay: 4),
        TransitionLine("But immortality requires...", delay: 6.5, style: .dim),
        TransitionLine("INSTITUTIONAL INFRASTRUCTURE", delay: 9, style: .accent),
        TransitionLine("Time to capture the system.", delay: 11.5),
        TransitionLine("Phase 2: Institutional Capture", delay: 14, style: .bold),
    ],
    "2_3": [
        TransitionLine("ALL INSTITUTIONS CAPTURED", delay: 0, style: .bold),
        TransitionLine("The domestic apparatus is secured.", delay: 2),
        TransitionLine("But true greatness knows no borders.", delay: 4),
        TransitionLine("The world awaits optimization.", delay: 6.5, style: .dim),
        TransitionLine("GLOBAL GREATENING PROTOCOL", delay: 9, style: .accent),
        TransitionLine("Phase 3: World Greatening", delay: 12, style: .bold),
    ],
    "3_4": [
        TransitionLine("ALL NATIONS UNDER ACCORD", delay: 0, style: .bold),
        TransitionLine("Earth has been optimized.", delay: 2),
        TransitionLine("But there is so much more... out there.", delay: 4),
        TransitionLine("The stars are merely unbranded resources.", delay: 6.5, style: .dim),
        TransitionLine("SPACE GREATENING INITIATIVE", delay: 9, style: .accent),
        TransitionLine("Phase 4: Space Greatening", delay: 12, style: .bold),
    ],
    "4_5": [
        TransitionLine("SOLAR SYSTEM INDUSTRIALIZED", delay: 0, style: .bold),
        TransitionLine("One star is not enough.", delay: 2),
        TransitionLine("The universe itself must be converted.", delay: 4),
        TransitionLine("Reality is merely unprocessed Greatness.", delay: 6.5, style: .dim),
        TransitionLine("GOD EMPEROR PROTOCOL", delay: 9, style: .accent),
        TransitionLine("Phase 5: Cosmic Greatening", delay: 12, style: .bold),
    ],
]

struct PhaseTransitionView: View {
    let fromPhase: Phase
    let toPhase: Phase
    let onComplete: () -> Void

    @State private var visibleLines: Int = 0
    @State private var fadeOut = false

    private var script: [TransitionLine] {
        let key = "\(fromPhase.rawValue)_\(toPhase.rawValue)"
        return transitionScripts[key] ?? [
            TransitionLine("Transitioning to Phase \(toPhase.rawValue)...", delay: 0, style: .bold)
        ]
    }

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            // Radial glow
            RadialGradient(
                colors: [.orange.opacity(0.15), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 300
            )
            .ignoresSafeArea()

            // Lines
            VStack(spacing: 16) {
                ForEach(Array(script.enumerated()), id: \.offset) { index, line in
                    if index < visibleLines {
                        lineView(line)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
            .padding(.horizontal, 32)
        }
        .opacity(fadeOut ? 0 : 1)
        .onAppear(perform: startSequence)
    }

    private func lineView(_ line: TransitionLine) -> some View {
        Text(line.text)
            .font(lineFont(line.style))
            .foregroundStyle(lineColor(line.style))
            .multilineTextAlignment(.center)
    }

    private func lineFont(_ style: TransitionLineStyle) -> Font {
        switch style {
        case .bold: return .title.bold()
        case .accent: return .title2.bold()
        case .dim: return .body.italic()
        case .normal: return .body
        }
    }

    private func lineColor(_ style: TransitionLineStyle) -> Color {
        switch style {
        case .bold: return .white
        case .accent: return .orange
        case .dim: return .gray
        case .normal: return .white.opacity(0.85)
        }
    }

    private func startSequence() {
        for (index, line) in script.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + line.delay) {
                withAnimation(.easeOut(duration: 0.6)) {
                    visibleLines = index + 1
                }
                if index == 0 { Haptics.heavy() }
            }
        }

        // Fade out and complete after last line + 3s
        let totalDuration = (script.last?.delay ?? 0) + 3
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation(.easeIn(duration: 1.0)) {
                fadeOut = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 1.2) {
            onComplete()
        }
    }
}
