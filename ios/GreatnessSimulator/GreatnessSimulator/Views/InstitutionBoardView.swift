import SwiftUI

struct InstitutionBoardView: View {
    @Environment(GameState.self) private var game

    private var sortedInstitutions: [InstitutionDef] {
        institutionDefs.sorted { a, b in
            let sa = game.institutions[a.id] ?? InstitutionState()
            let sb = game.institutions[b.id] ?? InstitutionState()
            if sa.status == .captured && sb.status != .captured { return false }
            if sb.status == .captured && sa.status != .captured { return true }
            return a.resistance < b.resistance
        }
    }

    var body: some View {
        ScrollView {
            let captured = game.institutions.values.filter { $0.status == .captured || $0.status == .automated }.count
            Text("\(captured)/13 Institutions Captured")
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.top, 8)

            LazyVStack(spacing: 12) {
                ForEach(sortedInstitutions, id: \.id) { def in
                    InstitutionCard(def: def)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct InstitutionCard: View {
    @Environment(GameState.self) private var game
    let def: InstitutionDef
    @State private var expanded = false

    private var state: InstitutionState {
        game.institutions[def.id] ?? InstitutionState()
    }

    private var isCaptured: Bool {
        state.status == .captured || state.status == .automated
    }

    private var hasActiveAction: Bool {
        state.actionStartedAt != nil
    }

    private var actionProgress: Double {
        guard let startedAt = state.actionStartedAt else { return 0 }
        let actionType = state.status.rawValue
        guard let actionDef = actionRegistry[actionType] else { return 0 }
        let elapsed = Date().timeIntervalSince1970 - startedAt
        return min(1.0, elapsed / actionDef.duration)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            Button {
                withAnimation(.spring(duration: 0.3)) { expanded.toggle() }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: def.icon)
                        .font(.title3)
                        .foregroundStyle(statusColor)
                        .frame(width: 30)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(def.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text(def.description)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        statusBadge
                        Text("+\(Fmt.compact(def.greatnessOutput)) GpS")
                            .font(.caption2)
                            .foregroundStyle(.yellow.opacity(0.7))
                    }
                }
            }
            .buttonStyle(.plain)

            // Resistance bar (not for captured)
            if !isCaptured {
                HStack(spacing: 8) {
                    Text("Resistance")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.1))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.red.opacity(0.6))
                                .frame(width: geo.size.width * (state.resistance / 100))
                        }
                    }
                    .frame(height: 6)
                    Text("\(Int(state.resistance))%")
                        .font(.caption2)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }

            // Action progress bar
            if hasActiveAction {
                HStack(spacing: 8) {
                    Text(actionLabel)
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.1))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.orange.opacity(0.7))
                                .frame(width: geo.size.width * actionProgress)
                        }
                    }
                    .frame(height: 6)
                }
            }

            // Expanded action buttons
            if expanded {
                actionButtons
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(isCaptured ? 0.03 : 0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(borderColor, lineWidth: 1)
                )
        )
    }

    private var statusColor: Color {
        switch state.status {
        case .independent: return .gray
        case .coOpting, .replacing, .purging: return .orange
        case .captured: return .green
        case .automated: return .cyan
        }
    }

    private var borderColor: Color {
        if isCaptured { return .green.opacity(0.3) }
        if hasActiveAction { return .orange.opacity(0.4) }
        return .clear
    }

    private var statusBadge: some View {
        let text: String
        let color: Color
        switch state.status {
        case .independent: text = "Independent"; color = .gray
        case .coOpting: text = "Co-opting..."; color = .orange
        case .replacing: text = "Replacing..."; color = .orange
        case .purging: text = "Purging..."; color = .red
        case .captured: text = "Captured"; color = .green
        case .automated: text = "Automated"; color = .cyan
        }
        return Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(color)
    }

    private var actionLabel: String {
        switch state.status {
        case .coOpting: return "Co-opting"
        case .replacing: return "Replacing"
        case .purging: return "Purging"
        default: return "Working..."
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        let available = institutionActions.filter { action in
            if action.requiresCaptured && !isCaptured { return false }
            if !action.requiresCaptured && isCaptured { return false }
            if hasActiveAction { return false }
            return true
        }

        if available.isEmpty {
            Text(hasActiveAction ? "Action in progress..." : "No actions available")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        } else {
            VStack(spacing: 6) {
                ForEach(available, id: \.type) { action in
                    actionButton(action)
                }
            }
            .padding(.top, 4)
        }
    }

    private func actionButton(_ action: InstitutionActionDef) -> some View {
        let canAfford = game.cash >= action.costCash && game.loyalty >= action.costLoyalty
        return Button {
            game.startInstitutionAction(institutionId: def.id, actionType: action.type)
            Haptics.medium()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(action.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(canAfford ? .white : .gray)
                    Text(action.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    if action.costCash > 0 {
                        Text("\(Fmt.compact(action.costCash)) $")
                            .font(.caption2)
                            .foregroundStyle(game.cash >= action.costCash ? .green : .red)
                    }
                    if action.costLoyalty > 0 {
                        Text("\(Fmt.compact(action.costLoyalty)) loyalty")
                            .font(.caption2)
                            .foregroundStyle(game.loyalty >= action.costLoyalty ? .purple : .red)
                    }
                    Text("\(Int(action.duration))s")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(canAfford ? 0.05 : 0.02))
            )
        }
        .buttonStyle(.plain)
        .disabled(!canAfford)
    }
}
