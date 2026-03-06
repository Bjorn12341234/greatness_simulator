import SwiftUI

struct TickerView: View {
    @Environment(GameState.self) private var game
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0

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
        guard !headlines.isEmpty else { return AnyView(EmptyView()) }

        return AnyView(
            GeometryReader { geo in
                let text = tickerText
                let _ = updateContainerWidth(geo.size.width)

                ZStack {
                    // Measure text width
                    Text(text)
                        .font(.system(size: 12, weight: .medium))
                        .fixedSize()
                        .hidden()
                        .background(
                            GeometryReader { textGeo in
                                Color.clear.preference(key: TextWidthKey.self, value: textGeo.size.width)
                            }
                        )

                    // Two copies for seamless scrolling
                    HStack(spacing: 60) {
                        Text(text)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .fixedSize()

                        Text(text)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .fixedSize()
                    }
                    .offset(x: offset)
                }
                .frame(width: geo.size.width, height: 28, alignment: .leading)
                .clipped()
            }
            .frame(height: 28)
            .background(
                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.15),
                        Color.red.opacity(0.1),
                        Color.orange.opacity(0.15),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(alignment: .top) {
                Rectangle().fill(Color.orange.opacity(0.2)).frame(height: 1)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Color.orange.opacity(0.2)).frame(height: 1)
            }
            .onPreferenceChange(TextWidthKey.self) { width in
                textWidth = width
                startAnimation()
            }
            .onChange(of: game.eventHistory.count) {
                startAnimation()
            }
        )
    }

    private func updateContainerWidth(_ width: CGFloat) -> Bool {
        if containerWidth != width {
            DispatchQueue.main.async { containerWidth = width }
        }
        return true
    }

    private func startAnimation() {
        guard textWidth > 0 else { return }
        let totalWidth = textWidth + 60
        offset = containerWidth
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            offset = -totalWidth
        }
    }
}

private struct TextWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
