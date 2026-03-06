import SwiftUI

struct AchievementToast: Identifiable {
    let id = UUID()
    let achievement: AchievementDef
    let timestamp: Date = Date()
}

struct AchievementToastView: View {
    let toast: AchievementToast
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.achievement.icon)
                .font(.title2)
                .foregroundStyle(.yellow)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text("Achievement Unlocked")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.yellow.opacity(0.8))
                    .textCase(.uppercase)

                Text(toast.achievement.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text(toast.achievement.description)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.yellow.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .yellow.opacity(0.15), radius: 10)
        )
        .onTapGesture { onDismiss() }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct AchievementToastOverlay: View {
    @Binding var toasts: [AchievementToast]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(toasts) { toast in
                AchievementToastView(toast: toast) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        toasts.removeAll { $0.id == toast.id }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 60)
        .allowsHitTesting(!toasts.isEmpty)
        .animation(.spring(duration: 0.4), value: toasts.map(\.id))
    }
}
