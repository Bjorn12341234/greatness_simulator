import { useRef, useEffect, useState, useCallback } from 'react'

interface UseAnimatedNumberOptions {
  duration?: number
  decimals?: number
}

export function useAnimatedNumber(
  target: number,
  { duration = 300, decimals = 0 }: UseAnimatedNumberOptions = {}
): number {
  const [display, setDisplay] = useState(target)
  const rafRef = useRef<number>(0)
  const startRef = useRef(display)
  const startTimeRef = useRef(0)

  const easeOutExpo = useCallback((t: number): number => {
    return t === 1 ? 1 : 1 - Math.pow(2, -10 * t)
  }, [])

  useEffect(() => {
    startRef.current = display
    startTimeRef.current = performance.now()

    const animate = (now: number) => {
      const elapsed = now - startTimeRef.current
      const progress = Math.min(elapsed / duration, 1)
      const eased = easeOutExpo(progress)
      const current = startRef.current + (target - startRef.current) * eased

      const rounded = decimals === 0
        ? Math.round(current)
        : parseFloat(current.toFixed(decimals))
      setDisplay(rounded)

      if (progress < 1) {
        rafRef.current = requestAnimationFrame(animate)
      }
    }

    rafRef.current = requestAnimationFrame(animate)

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [target, duration, decimals])

  return display
}
