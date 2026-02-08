import { useRef, useEffect, useCallback, useImperativeHandle, forwardRef } from 'react'

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  life: number
  maxLife: number
  size: number
  color: string
}

export interface ParticleCanvasHandle {
  emit: (x: number, y: number, count?: number, color?: string) => void
}

const MAX_PARTICLES = 50
const GRAVITY = 80 // pixels per second²
const COLORS = [
  '#FF6600',
  '#FF8833',
  '#FFAA55',
  '#FF5500',
  '#FFcc44',
]

export const ParticleCanvas = forwardRef<ParticleCanvasHandle>(
  function ParticleCanvas(_props, ref) {
    const canvasRef = useRef<HTMLCanvasElement>(null)
    const particlesRef = useRef<Particle[]>([])
    const rafRef = useRef<number>(0)
    const lastTimeRef = useRef(0)

    const emit = useCallback((x: number, y: number, count = 12, color?: string) => {
      const particles = particlesRef.current
      for (let i = 0; i < count; i++) {
        if (particles.length >= MAX_PARTICLES) {
          // Replace oldest particle
          particles.shift()
        }
        const angle = (Math.PI * 2 * i) / count + (Math.random() - 0.5) * 0.5
        const speed = 80 + Math.random() * 120
        particles.push({
          x,
          y,
          vx: Math.cos(angle) * speed,
          vy: Math.sin(angle) * speed - 60, // bias upward
          life: 0.6 + Math.random() * 0.4,
          maxLife: 0.6 + Math.random() * 0.4,
          size: 2 + Math.random() * 3,
          color: color ?? COLORS[Math.floor(Math.random() * COLORS.length)],
        })
      }
    }, [])

    useImperativeHandle(ref, () => ({ emit }), [emit])

    useEffect(() => {
      const canvas = canvasRef.current
      if (!canvas) return
      const ctx = canvas.getContext('2d')
      if (!ctx) return

      const resize = () => {
        const dpr = window.devicePixelRatio || 1
        canvas.width = canvas.offsetWidth * dpr
        canvas.height = canvas.offsetHeight * dpr
        ctx.scale(dpr, dpr)
      }
      resize()
      window.addEventListener('resize', resize)

      lastTimeRef.current = performance.now()

      const loop = (now: number) => {
        const dt = (now - lastTimeRef.current) / 1000
        lastTimeRef.current = now

        ctx.clearRect(0, 0, canvas.offsetWidth, canvas.offsetHeight)

        const particles = particlesRef.current
        for (let i = particles.length - 1; i >= 0; i--) {
          const p = particles[i]
          p.life -= dt
          if (p.life <= 0) {
            particles.splice(i, 1)
            continue
          }

          p.vy += GRAVITY * dt
          p.x += p.vx * dt
          p.y += p.vy * dt

          const alpha = Math.max(0, p.life / p.maxLife)
          ctx.globalAlpha = alpha
          ctx.fillStyle = p.color
          ctx.beginPath()
          ctx.arc(p.x, p.y, p.size * alpha, 0, Math.PI * 2)
          ctx.fill()
        }
        ctx.globalAlpha = 1

        rafRef.current = requestAnimationFrame(loop)
      }

      rafRef.current = requestAnimationFrame(loop)

      return () => {
        cancelAnimationFrame(rafRef.current)
        window.removeEventListener('resize', resize)
      }
    }, [])

    return (
      <canvas
        ref={canvasRef}
        className="absolute inset-0 pointer-events-none"
        style={{ width: '100%', height: '100%' }}
      />
    )
  }
)
