import { motion, type HTMLMotionProps } from 'framer-motion'
import { forwardRef, type ReactNode } from 'react'

interface GlassCardProps extends HTMLMotionProps<'div'> {
  children: ReactNode
  hover?: boolean
  glow?: 'orange' | 'green' | 'red' | 'gold' | 'none'
  padding?: 'sm' | 'md' | 'lg'
}

const GLOW_COLORS = {
  orange: 'rgba(255, 102, 0, 0.15)',
  green: 'rgba(51, 204, 102, 0.15)',
  red: 'rgba(255, 51, 51, 0.15)',
  gold: 'rgba(255, 215, 0, 0.15)',
  none: 'transparent',
}

const PADDING = {
  sm: 'p-3',
  md: 'p-4',
  lg: 'p-6',
}

export const GlassCard = forwardRef<HTMLDivElement, GlassCardProps>(
  function GlassCard({ children, hover = false, glow = 'none', padding = 'md', className = '', style, ...props }, ref) {
    const glowStyle = glow !== 'none'
      ? { boxShadow: `0 4px 24px ${GLOW_COLORS[glow]}, 0 0 40px ${GLOW_COLORS[glow]}` }
      : undefined

    return (
      <motion.div
        ref={ref}
        className={`glass-card ${PADDING[padding]} ${hover ? 'transition-all duration-200 hover:glass-card-hover' : ''} ${className}`}
        style={{ ...glowStyle, ...style }}
        {...props}
      >
        {children}
      </motion.div>
    )
  }
)
