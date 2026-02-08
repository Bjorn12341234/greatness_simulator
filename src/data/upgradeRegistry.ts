import type { UpgradeData } from '../store/types'
import { PHASE1_UPGRADES } from './phase1/upgrades'

// Central registry of all upgrades, keyed by ID
const UPGRADE_MAP = new Map<string, UpgradeData>()

function registerUpgrades(upgrades: UpgradeData[]) {
  for (const u of upgrades) {
    UPGRADE_MAP.set(u.id, u)
  }
}

// Register all phases
registerUpgrades(PHASE1_UPGRADES)

export function getUpgradeData(id: string): UpgradeData | undefined {
  return UPGRADE_MAP.get(id)
}

export function getAllUpgrades(): UpgradeData[] {
  return Array.from(UPGRADE_MAP.values())
}

export function getUpgradesByPhase(phase: number): UpgradeData[] {
  return Array.from(UPGRADE_MAP.values()).filter(u => u.phase === phase)
}

export function getUpgradesByTree(tree: string): UpgradeData[] {
  return Array.from(UPGRADE_MAP.values()).filter(u => u.tree === tree)
}

export function getPhase1Trees(): string[] {
  const trees = new Set(PHASE1_UPGRADES.map(u => u.tree))
  return Array.from(trees)
}
