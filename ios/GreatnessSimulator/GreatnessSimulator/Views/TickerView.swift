import SwiftUI

struct TickerView: View {
    @Environment(GameState.self) private var game
    @Environment(\.theme) private var theme
    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var startTime: Date = .now

    private var headlines: [String] {
        guard !game.eventHistory.isEmpty else { return [] }
        let recent = game.eventHistory.suffix(5)
        return recent.compactMap { eventId in
            allEventRegistry[eventId]?.headline
        }
    }

    private var tickerText: String {
        guard !headlines.isEmpty else { return "" }
        return headlines.enumerated().map { idx, h in
            idx == headlines.count - 1 ? "BREAKING: \(h)" : h
        }.joined(separator: "  ///  ")
    }

    var body: some View {
        if headlines.isEmpty {
            EmptyView()
        } else {
            GeometryReader { geo in
                let _ = DispatchQueue.main.async {
                    if containerWidth != geo.size.width { containerWidth = geo.size.width }
                }

                ZStack(alignment: .leading) {
                    // Hidden text to measure width
                    Text(tickerText)
                        .font(.system(size: 11, weight: .medium))
                        .fixedSize()
                        .hidden()
                        .background(
                            GeometryReader { textGeo in
                                Color.clear.onAppear {
                                    textWidth = textGeo.size.width
                                    startTime = .now
                                }
                                .onChange(of: textGeo.size.width) { _, newWidth in
                                    textWidth = newWidth
                                    startTime = .now
                                }
                            }
                        )

                    // Scrolling text driven by TimelineView
                    if textWidth > 0 && containerWidth > 0 {
                        TimelineView(.animation) { timeline in
                            let elapsed = timeline.date.timeIntervalSince(startTime)
                            let speed: CGFloat = 40 // points per second
                            let totalSpan = textWidth + 60 + containerWidth
                            let rawOffset = elapsed * speed
                            let cycleOffset = rawOffset.truncatingRemainder(dividingBy: totalSpan)
                            let x = containerWidth - cycleOffset

                            HStack(spacing: 60) {
                                Text(tickerText)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(theme.text.opacity(0.9))
                                    .fixedSize()

                                Text(tickerText)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(theme.text.opacity(0.9))
                                    .fixedSize()
                            }
                            .offset(x: x)
                        }
                    }
                }
                .frame(width: geo.size.width, height: 22, alignment: .leading)
                .clipped()
            }
            .frame(height: 22)
            .background(
                LinearGradient(
                    colors: [
                        theme.accent.opacity(0.12),
                        theme.accent.opacity(0.06),
                        theme.accent.opacity(0.12),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(alignment: .top) {
                Rectangle().fill(theme.accent.opacity(0.15)).frame(height: 0.5)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(theme.accent.opacity(0.15)).frame(height: 0.5)
            }
            .onChange(of: game.eventHistory.count) {
                startTime = .now
            }
        }
    }
}
