import SwiftUI

struct OfflineReturnView: View {
    let result: OfflineResult
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.cyan)

                Text("WELCOME BACK")
                    .font(.title2)
                    .fontWeight(.black)
                    .tracking(3)
                    .foregroundStyle(.white)

                Text("While you were away for \(formatDuration(result.elapsedSeconds))...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    if result.greatnessGained > 0 {
                        rewardRow(icon: "star.fill", label: "Greatness", value: result.greatnessGained, color: .yellow)
                    }
                    if result.cashGained > 0 {
                        rewardRow(icon: "dollarsign.circle.fill", label: "Cash", value: result.cashGained, color: .green)
                    }
                    if result.attentionGained > 0 {
                        rewardRow(icon: "eye.fill", label: "Attention", value: result.attentionGained, color: .cyan)
                    }
                }
                .padding()
                .background(Color(white: 0.1))
                .cornerRadius(12)

                Button {
                    onDismiss()
                    Haptics.light()
                } label: {
                    Text("CONTINUE")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .frame(maxWidth: 340)
        }
        .transition(.opacity)
    }

    private func rewardRow(icon: String, label: String, value: Double, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text("+\(Fmt.compact(value))")
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }

    private func formatDuration(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
