import type { GameState, SaveFile } from '../store/types'

const SAVE_KEY = 'orange_man_save'
const CURRENT_VERSION = 1

export function saveGame(state: GameState): void {
  const saveFile: SaveFile = {
    version: CURRENT_VERSION,
    savedAt: Date.now(),
    state,
  }

  try {
    localStorage.setItem(SAVE_KEY, JSON.stringify(saveFile))
  } catch (e) {
    console.error('Failed to save game:', e)
  }
}

export function loadGame(): GameState | null {
  try {
    const raw = localStorage.getItem(SAVE_KEY)
    if (!raw) return null

    const parsed = JSON.parse(raw)

    // Validate save file structure
    if (!isValidSaveFile(parsed)) {
      console.warn('Invalid save file structure, ignoring')
      return null
    }

    // Run migrations if needed
    const migrated = migrate(parsed)

    return migrated.state
  } catch (e) {
    console.error('Failed to load save:', e)
    return null
  }
}

export function deleteSave(): void {
  localStorage.removeItem(SAVE_KEY)
}

export function hasSave(): boolean {
  return localStorage.getItem(SAVE_KEY) !== null
}

export function exportSave(state: GameState): string {
  const saveFile: SaveFile = {
    version: CURRENT_VERSION,
    savedAt: Date.now(),
    state,
  }
  return btoa(JSON.stringify(saveFile))
}

export function importSave(encoded: string): GameState | null {
  try {
    const json = atob(encoded)
    const parsed = JSON.parse(json)

    if (!isValidSaveFile(parsed)) {
      console.warn('Invalid imported save file structure')
      return null
    }

    const migrated = migrate(parsed)
    return migrated.state
  } catch (e) {
    console.error('Failed to import save:', e)
    return null
  }
}

// ── Save Validation ──
// Checks that a parsed object has the shape of a valid SaveFile before using it.

function isValidSaveFile(obj: unknown): obj is SaveFile {
  if (typeof obj !== 'object' || obj === null) return false
  const save = obj as Record<string, unknown>

  if (typeof save.version !== 'number') return false
  if (typeof save.savedAt !== 'number') return false
  if (typeof save.state !== 'object' || save.state === null) return false

  const state = save.state as Record<string, unknown>

  // Check critical fields that the game cannot function without
  if (typeof state.phase !== 'number' || state.phase < 1 || state.phase > 5) return false
  if (typeof state.greatness !== 'number') return false
  if (typeof state.lastTickAt !== 'number') return false

  return true
}

// ── Migration Framework ──
// Add migration functions as the save format evolves.

type MigrationFn = (save: SaveFile) => SaveFile

const migrations: Record<number, MigrationFn> = {
  // Example: when version 2 is introduced
  // 1: (save) => { ... transform v1 → v2 ...; save.version = 2; return save }
}

function migrate(save: SaveFile): SaveFile {
  let current = save

  while (current.version < CURRENT_VERSION) {
    const fn = migrations[current.version]
    if (!fn) {
      console.warn(`No migration for version ${current.version}, resetting`)
      break
    }
    current = fn(current)
  }

  return current
}
