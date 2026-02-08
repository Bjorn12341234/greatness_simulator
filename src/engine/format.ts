// ── Number Formatting ──
// Spec: <1K exact, <1M commas, <1B suffix, >=1B scientific-ish

const SUFFIXES = [
  { threshold: 1e24, suffix: ' septillion' },
  { threshold: 1e21, suffix: ' sextillion' },
  { threshold: 1e18, suffix: ' quintillion' },
  { threshold: 1e15, suffix: ' quadrillion' },
  { threshold: 1e12, suffix: ' trillion' },
  { threshold: 1e9, suffix: ' billion' },
  { threshold: 1e6, suffix: 'M' },
]

export function formatNumber(n: number, decimals = 1): string {
  if (n < 0) return '-' + formatNumber(-n, decimals)

  // Exact for small numbers
  if (n < 1000) {
    return n % 1 === 0 ? n.toString() : n.toFixed(decimals)
  }

  // Commas for < 1M
  if (n < 1e6) {
    return Math.floor(n).toLocaleString('en-US')
  }

  // Suffix notation for large numbers
  for (const { threshold, suffix } of SUFFIXES) {
    if (n >= threshold) {
      const value = n / threshold
      return value.toFixed(decimals) + suffix
    }
  }

  return n.toFixed(decimals)
}

// Compact version: always uses short suffixes
export function formatCompact(n: number): string {
  if (n < 1000) return Math.floor(n).toString()
  if (n < 1e6) return (n / 1e3).toFixed(1) + 'K'
  if (n < 1e9) return (n / 1e6).toFixed(1) + 'M'
  if (n < 1e12) return (n / 1e9).toFixed(1) + 'B'
  if (n < 1e15) return (n / 1e12).toFixed(1) + 'T'
  return n.toExponential(1)
}

// ── Time Formatting ──

export function formatDuration(seconds: number): string {
  if (seconds < 60) return `${Math.floor(seconds)}s`
  if (seconds < 3600) {
    const m = Math.floor(seconds / 60)
    const s = Math.floor(seconds % 60)
    return s > 0 ? `${m}m ${s}s` : `${m}m`
  }
  if (seconds < 86400) {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    return m > 0 ? `${h}h ${m}m` : `${h}h`
  }
  const d = Math.floor(seconds / 86400)
  const h = Math.floor((seconds % 86400) / 3600)
  return h > 0 ? `${d}d ${h}h` : `${d}d`
}

export function formatCountdown(targetMs: number): string {
  const remaining = Math.max(0, (targetMs - Date.now()) / 1000)
  return formatDuration(remaining)
}

// ── Easing Utilities ──

export function lerp(start: number, end: number, t: number): number {
  return start + (end - start) * t
}

export function easeOutCubic(t: number): number {
  return 1 - Math.pow(1 - t, 3)
}

export function easeOutExpo(t: number): number {
  return t === 1 ? 1 : 1 - Math.pow(2, -10 * t)
}
