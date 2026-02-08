import { AnimatedNumber } from './ui/AnimatedNumber'

interface GreatnessMeterProps {
  greatness: number
  gps: number
}

export function GreatnessMeter({ greatness, gps }: GreatnessMeterProps) {
  return (
    <div className="flex flex-col items-center gap-2 w-full">
      {/* Main Greatness Number */}
      <AnimatedNumber
        value={greatness}
        duration={400}
        className="font-display text-accent glow-text-orange"
      />

      <p className="text-text-secondary text-xs uppercase tracking-[0.2em]">
        Greatness Units
      </p>

      {/* Decorative gradient bar */}
      <div className="w-full max-w-xs h-1 rounded-full overflow-hidden bg-white/5 mt-1">
        <div
          className="h-full rounded-full transition-all duration-500 ease-out"
          style={{
            width: `${Math.min(100, (greatness % 1000) / 10)}%`,
            background: 'linear-gradient(90deg, #CC5200, #FF6600, #FF8833)',
            boxShadow: greatness > 0 ? '0 0 8px rgba(255, 102, 0, 0.5)' : 'none',
          }}
        />
      </div>

      {/* GpS display */}
      {gps > 0 && (
        <div className="flex items-center gap-1.5 mt-1">
          <span className="text-text-muted text-[0.65rem] uppercase tracking-wider">per sec</span>
          <AnimatedNumber
            value={gps}
            duration={500}
            decimals={1}
            className="text-sm text-text-secondary"
          />
        </div>
      )}
    </div>
  )
}
