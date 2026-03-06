import SwiftUI

struct MainView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Phase header
                phaseHeader

                // Resource bar
                resourceBar

                Spacer()

                // Placeholder for main content
                Text("Sprint 2: Click button goes here")
                    .foregroundStyle(.secondary)

                Spacer()

                // Tab bar placeholder
                tabBar
            }
            .background(Color.black)
        }
    }

    // MARK: - Phase Header

    private var phaseHeader: some View {
        VStack(spacing: 4) {
            Text("GREATNESS SIMULATOR")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(3)
                .foregroundStyle(.yellow.opacity(0.8))

            Text("Phase \(game.phase.rawValue): \(game.phase.title)")
                .font(.headline)
                .foregroundStyle(.white)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.black, Color(white: 0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Resource Bar

    private var resourceBar: some View {
        HStack(spacing: 16) {
            resourcePill(icon: "star.fill", label: "Greatness", value: game.greatness, color: .yellow)
            resourcePill(icon: "dollarsign.circle.fill", label: "Cash", value: game.cash, color: .green)
            resourcePill(icon: "eye.fill", label: "Attention", value: game.attention, color: .cyan)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(white: 0.08))
    }

    private func resourcePill(icon: String, label: String, value: Double, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(Fmt.compact(value))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack {
            tabItem(icon: "hand.tap.fill", label: "Click")
            tabItem(icon: "arrow.up.square.fill", label: "Upgrades")
            tabItem(icon: "chart.bar.fill", label: "Stats")
            tabItem(icon: "gearshape.fill", label: "Settings")
        }
        .padding(.vertical, 8)
        .background(Color(white: 0.08))
    }

    private func tabItem(icon: String, label: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.title3)
            Text(label)
                .font(.caption2)
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
        .environment(GameState())
}
