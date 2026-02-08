import { useRef, useCallback } from 'react'
import { motion } from 'framer-motion'
import { ParticleCanvas, type ParticleCanvasHandle } from './ui/ParticleCanvas'
import { playClick } from '../engine/audio'

interface MainButtonProps {
  onClick: () => void
  label?: string
}

export function MainButton({ onClick, label = 'GENERATE\nATTENTION' }: MainButtonProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const particlesRef = useRef<ParticleCanvasHandle>(null)

  const handleClick = useCallback((e: React.MouseEvent) => {
    onClick()
    playClick()

    // Emit particles from click position relative to container
    if (particlesRef.current && containerRef.current) {
      const rect = containerRef.current.getBoundingClientRect()
      const x = e.clientX - rect.left
      const y = e.clientY - rect.top
      particlesRef.current.emit(x, y, 12)
    }
  }, [onClick])

  return (
    <div ref={containerRef} className="relative">
      <ParticleCanvas ref={particlesRef} />

      <motion.button
        whileTap={{ scale: 0.93 }}
        whileHover={{ scale: 1.03 }}
        onClick={handleClick}
        className="relative w-36 h-36 sm:w-40 sm:h-40 rounded-full cursor-pointer select-none
                   border-2 border-accent bg-accent/10
                   flex items-center justify-center
                   animate-pulse-glow"
        style={{
          background: 'radial-gradient(circle at 40% 40%, rgba(255, 102, 0, 0.2) 0%, rgba(255, 102, 0, 0.05) 60%, transparent 80%)',
        }}
      >
        {/* Inner glow ring */}
        <div className="absolute inset-2 rounded-full border border-accent/20" />

        <span className="text-accent font-bold text-base sm:text-lg text-center leading-tight whitespace-pre-line">
          {label}
        </span>
      </motion.button>
    </div>
  )
}
