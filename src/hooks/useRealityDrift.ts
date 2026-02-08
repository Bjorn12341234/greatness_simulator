import { useEffect, useRef } from 'react'
import { useGameStore } from '../store/gameStore'
import { getDriftLevel, LABEL_SWAPS } from '../engine/realityDrift'

/**
 * Manages Reality Drift CSS effects on the document root.
 * - Sets CSS custom property --drift-intensity
 * - Adds/removes drift CSS classes based on threshold
 * - Periodically swaps labels at high drift (Phase 4+)
 */
export function useRealityDrift() {
  const drift = useGameStore(s => s.realityDrift)
  const phase = useGameStore(s => s.phase)
  const swapTimerRef = useRef<ReturnType<typeof setInterval> | null>(null)

  useEffect(() => {
    if (phase < 4) return

    const root = document.documentElement
    const level = getDriftLevel(drift)

    // Set CSS variable
    root.style.setProperty('--drift-intensity', String(Math.min(1, drift / 100)))

    // Toggle CSS classes
    root.classList.toggle('drift-flicker', level.effects.includes('css_flicker'))
    root.classList.toggle('drift-labels', level.effects.includes('label_swaps'))
    root.classList.toggle('drift-glitch', level.effects.includes('unreliable_ui'))

    return () => {
      root.style.removeProperty('--drift-intensity')
      root.classList.remove('drift-flicker', 'drift-labels', 'drift-glitch')
    }
  }, [drift, phase])

  // Label swap timer at drift >= 40%
  useEffect(() => {
    if (phase < 4 || drift < 40) {
      if (swapTimerRef.current) {
        clearInterval(swapTimerRef.current)
        swapTimerRef.current = null
      }
      // Restore any swapped labels
      restoreLabels()
      return
    }

    const interval = drift >= 60 ? 2000 : 3000 // swap more frequently at higher drift

    swapTimerRef.current = setInterval(() => {
      const swapChance = (drift - 40) / 60
      // Find all elements with data-drift-label attribute
      const elements = document.querySelectorAll('[data-drift-label]')
      elements.forEach(el => {
        const original = el.getAttribute('data-drift-label') || ''
        if (Math.random() < swapChance * 0.3) {
          const swap = LABEL_SWAPS.find(([a]) => a === original)
          if (swap) {
            el.textContent = swap[1]
          }
        } else {
          el.textContent = original
        }
      })
    }, interval)

    return () => {
      if (swapTimerRef.current) {
        clearInterval(swapTimerRef.current)
        swapTimerRef.current = null
      }
    }
  }, [drift, phase])
}

function restoreLabels() {
  const elements = document.querySelectorAll('[data-drift-label]')
  elements.forEach(el => {
    const original = el.getAttribute('data-drift-label')
    if (original) el.textContent = original
  })
}
