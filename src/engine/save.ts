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

    const saveFile: SaveFile = JSON.parse(raw)

    // Run migrations if needed
    const migrated = migrate(saveFile)

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
    const saveFile: SaveFile = JSON.parse(json)
    const migrated = migrate(saveFile)
    return migrated.state
  } catch (e) {
    console.error('Failed to import save:', e)
    return null
  }
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
