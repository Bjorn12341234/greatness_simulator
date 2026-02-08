import { useState, useEffect, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import type { Phase } from '../store/types'
import { getTransitionScript, type TransitionLine } from '../engine/phases'
import { playPhaseTransition } from '../engine/audio'

interface PhaseTransitionProps {
  from: Phase
  to: Phase
  onComplete: () => void
}

export function PhaseTransition({ from, to, onComplete }: PhaseTransitionProps) {
  const [visibleLines, setVisibleLines] = useState<number>(0)
  const [showOverlay, setShowOverlay] = useState(true)
  const [fadingOut, setFadingOut] = useState(false)
  const script = getTransitionScript(from, to)

  // Play transition sound on mount
  useEffect(() => {
    playPhaseTransition()
  }, [])

  // Reveal lines one by one based on their delay
  useEffect(() => {
    const timers: ReturnType<typeof setTimeout>[] = []

    script.forEach((line, i) => {
      const timer = setTimeout(() => {
        setVisibleLines(prev => Math.max(prev, i + 1))
      }, line.delay + 1500) // +1500ms for initial fade-in
      timers.push(timer)
    })

    // After all lines shown, wait then fade out
    const lastDelay = script[script.length - 1]?.delay ?? 0
    const completeTimer = setTimeout(() => {
      setFadingOut(true)
    }, lastDelay + 4500) // 1500 initial + 3000 linger
    timers.push(completeTimer)

    return () => timers.forEach(clearTimeout)
  }, [script])

  const handleFadeOutComplete = useCallback(() => {
    if (fadingOut) {
      setShowOverlay(false)
      onComplete()
    }
  }, [fadingOut, onComplete])

  const getLineStyle = (style?: TransitionLine['style']) => {
    switch (style) {
      case 'bold':
        return 'text-xl md:text-2xl font-bold text-text-primary tracking-wide'
      case 'accent':
        return 'text-xl md:text-2xl font-bold text-accent tracking-widest uppercase'
      case 'dim':
        return 'text-base md:text-lg text-text-muted italic'
      default:
        return 'text-base md:text-lg text-text-secondary'
    }
  }

  if (!showOverlay) return null

  return (
    <AnimatePresence>
      <motion.div
        className="fixed inset-0 z-[100] flex flex-col items-center justify-center"
        style={{ background: '#000' }}
        initial={{ opacity: 0 }}
        animate={{ opacity: fadingOut ? 0 : 1 }}
        transition={{ duration: fadingOut ? 1.5 : 1.5 }}
        onAnimationComplete={handleFadeOutComplete}
      >
        {/* Subtle particle/glow background */}
        <div
          className="absolute inset-0 pointer-events-none"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(255, 102, 0, 0.08) 0%, transparent 70%)',
          }}
        />

        {/* Floating particles */}
        <TransitionParticles />

        {/* Text lines */}
        <div className="relative z-10 flex flex-col items-center gap-4 px-8 max-w-md text-center">
          {script.slice(0, visibleLines).map((line, i) => (
            <motion.p
              key={i}
              initial={{ opacity: 0, y: 12 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, ease: 'easeOut' }}
              className={getLineStyle(line.style)}
            >
              {line.style === 'accent' ? (
                <span className="glow-text-orange">{line.text}</span>
              ) : (
                line.text
              )}
            </motion.p>
          ))}
        </div>

        {/* Skip hint */}
        <motion.p
          className="absolute bottom-8 text-[0.65rem] text-text-muted/40 tracking-wider"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 3 }}
        >
          PHASE {from} → PHASE {to}
        </motion.p>
      </motion.div>
    </AnimatePresence>
  )
}

// Lightweight CSS-animated floating particles for the transition screen
function TransitionParticles() {
  // Generate static particles on mount
  const particles = Array.from({ length: 20 }, (_, i) => ({
    id: i,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    size: 2 + Math.random() * 3,
    delay: Math.random() * 4,
    duration: 3 + Math.random() * 4,
    opacity: 0.1 + Math.random() * 0.3,
  }))

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {particles.map(p => (
        <motion.div
          key={p.id}
          className="absolute rounded-full"
          style={{
            left: p.left,
            top: p.top,
            width: p.size,
            height: p.size,
            background: 'rgba(255, 102, 0, 0.6)',
            boxShadow: '0 0 6px rgba(255, 102, 0, 0.4)',
          }}
          animate={{
            y: [0, -40, 0],
            opacity: [p.opacity * 0.5, p.opacity, p.opacity * 0.5],
          }}
          transition={{
            duration: p.duration,
            delay: p.delay,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        />
      ))}
    </div>
  )
}
