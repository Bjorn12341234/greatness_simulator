import SwiftUI

struct NobelMeterView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "medal.fill")
                    .foregroundStyle(.yellow)
                Text("NOBEL PEACE PRIZE")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()

                // Prize count
                if game.nobelPrizesWon > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<min(game.nobelPrizesWon, 5), id: \.self) { _ in
                            Image(systemName: "medal.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                        }
                        if game.nobelPrizesWon > 5 {
                            Text("+\(game.nobelPrizesWon - 5)")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }

            // Progress bar
            ProgressView(value: min(game.nobelScore, game.nobelThreshold), total: game.nobelThreshold)
                .tint(closeToThreshold ? .yellow : .orange)

            HStack {
                Text("\(Int(game.nobelScore)) / \(Int(game.nobelThreshold))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if closeToThreshold {
                    Text("ALMOST THERE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                }
            }

            // Irony indicator
            ironyIndicator
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            closeToThreshold ? Color.yellow.opacity(0.4) : Color(white: 0.2),
                            lineWidth: 1
                        )
                )
        )
    }

    private var closeToThreshold: Bool {
        game.nobelScore >= game.nobelThreshold * 0.8
    }

    // Show active wars while pursuing peace prize
    private var ironyIndicator: some View {
        let activeWars = game.countries.values.filter { country in
            country.activeOperations.contains { op in
                op.tacticType == "freedom_operation" || op.tacticType == "coup_sponsorship" || op.tacticType == "extraordinary_rendition"
            }
        }.count

        return Group {
            if activeWars > 0 && game.nobelScore > 20 {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.red)
                    Text("Pursuing peace prize during \(activeWars) active war\(activeWars == 1 ? "" : "s")")
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(.red.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if game.fear > 50 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text("Global fear level: \(Int(game.fear)). \"Peace\" is a strong word.")
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(.orange.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
