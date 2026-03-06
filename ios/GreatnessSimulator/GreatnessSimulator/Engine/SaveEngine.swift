import Foundation

struct SaveEngine {
    private static let saveFileName = "greatness_save.json"
    private static let backupFileName = "greatness_save_backup.json"

    private static var saveURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(saveFileName)
    }

    private static var backupURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(backupFileName)
    }

    // MARK: - Save

    static func save(state: GameState) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(state)

            // Write backup of existing save first
            if FileManager.default.fileExists(atPath: saveURL.path) {
                try? FileManager.default.removeItem(at: backupURL)
                try? FileManager.default.copyItem(at: saveURL, to: backupURL)
            }

            try data.write(to: saveURL, options: .atomic)
            return true
        } catch {
            print("[SaveEngine] Save failed: \(error)")
            return false
        }
    }

    // MARK: - Load

    static func load() -> GameState? {
        // Try main save first
        if let state = loadFrom(url: saveURL) {
            return state
        }
        // Fall back to backup
        if let state = loadFrom(url: backupURL) {
            print("[SaveEngine] Loaded from backup save")
            return state
        }
        return nil
    }

    private static func loadFrom(url: URL) -> GameState? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let state = try decoder.decode(GameState.self, from: data)
            return state
        } catch {
            print("[SaveEngine] Load failed from \(url.lastPathComponent): \(error)")
            return nil
        }
    }

    // MARK: - Delete Save

    static func deleteSave() {
        try? FileManager.default.removeItem(at: saveURL)
        try? FileManager.default.removeItem(at: backupURL)
    }

    // MARK: - Has Save

    static var hasSave: Bool {
        FileManager.default.fileExists(atPath: saveURL.path)
    }
}
