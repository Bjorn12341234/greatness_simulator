import { useAnimatedNumber } from '../../hooks/useAnimatedNumber'
import { formatNumber } from '../../engine/format'

interface AnimatedNumberProps {
  value: number
  duration?: number
  decimals?: number
  className?: string
  format?: (n: number) => string
}

export function AnimatedNumber({
  value,
  duration = 300,
  decimals = 1,
  className = '',
  format = formatNumber,
}: AnimatedNumberProps) {
  const animated = useAnimatedNumber(value, { duration, decimals })

  return (
    <span className={`font-numbers ${className}`}>
      {format(animated)}
    </span>
  )
}
