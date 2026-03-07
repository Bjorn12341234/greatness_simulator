import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.text)

                    Text("Last updated: March 7, 2026")
                        .font(.caption)
                        .foregroundStyle(theme.textSecondary)

                    policySection("Data Collection",
                        "Greatness Simulator does not collect, store, or transmit any personal data. All game data is stored locally on your device.")

                    policySection("Analytics",
                        "This app does not use any analytics, tracking, or advertising frameworks. No data is sent to external servers.")

                    policySection("Local Storage",
                        "Game save data is stored on your device using standard iOS file storage. This data is not synced, backed up to external servers, or shared with third parties. It may be included in your iCloud backups if you have iCloud backup enabled on your device.")

                    policySection("Third-Party Services",
                        "Greatness Simulator does not integrate with any third-party services, SDKs, or APIs.")

                    policySection("Children's Privacy",
                        "This app does not knowingly collect any information from children or any other users.")

                    policySection("Changes to This Policy",
                        "If this privacy policy is updated, the changes will be included in an app update. Continued use of the app constitutes acceptance of any changes.")

                    policySection("Contact",
                        "If you have questions about this privacy policy, please reach out via the App Store listing.")
                }
                .padding()
            }
            .background(theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(theme.accent)
                }
            }
        }
    }

    private func policySection(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(theme.text)
            Text(body)
                .font(.subheadline)
                .foregroundStyle(theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
