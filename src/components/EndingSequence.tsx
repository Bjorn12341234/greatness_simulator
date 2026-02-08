import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { useGameStore } from '../store/gameStore'

interface EndingScreen {
  text: string[]
  delay: number   // ms before this screen shows
  duration: number // ms this screen is shown
}

const ENDING_SCREENS: EndingScreen[] = [
  {
    text: ['THE UNIVERSE IS NOW GREAT.'],
    delay: 0,
    duration: 5000,
  },
  {
    text: ['...'],
    delay: 5000,
    duration: 5000,
  },
  {
    text: ['GREATNESS MUST BE MAINTAINED.'],
    delay: 10000,
    duration: 5000,
  },
  {
    text: [
      'ALERT: GREATNESS DECAY DETECTED.',
      'MAINTENANCE PROTOCOL: ACTIVE.',
      'OPTIMIZATION: REQUIRED.',
      'FOREVER.',
    ],
    delay: 15000,
    duration: 8000,
  },
]

export function EndingSequence() {
  const endingTriggered = useGameStore(s => s.universe.endingTriggered)
  const endingComplete = useGameStore(s => s.universe.endingComplete)
  const [currentScreen, setCurrentScreen] = useState(-1)
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    if (!endingTriggered || endingComplete) return

    setVisible(true)
    setCurrentScreen(0)

    const timers: ReturnType<typeof setTimeout>[] = []

    for (let i = 1; i < ENDING_SCREENS.length; i++) {
      timers.push(setTimeout(() => setCurrentScreen(i), ENDING_SCREENS[i].delay))
    }

    // After last screen, dismiss
    const totalDuration = ENDING_SCREENS[ENDING_SCREENS.length - 1].delay + ENDING_SCREENS[ENDING_SCREENS.length - 1].duration
    timers.push(setTimeout(() => {
      setVisible(false)
      // Mark ending as complete in store
      useGameStore.setState(state => ({
        universe: { ...state.universe, endingComplete: true },
      }))
    }, totalDuration))

    return () => timers.forEach(clearTimeout)
  }, [endingTriggered, endingComplete])

  if (!visible || currentScreen < 0) return null

  const screen = ENDING_SCREENS[currentScreen]

  return (
    <motion.div
      className="fixed inset-0 z-[200] flex items-center justify-center"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 1.5 }}
      style={{ background: 'radial-gradient(ellipse at center, #0a0015 0%, #000000 100%)' }}
    >
      <AnimatePresence mode="wait">
        <motion.div
          key={currentScreen}
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 1.05 }}
          transition={{ duration: 1.5 }}
          className="text-center px-8 max-w-lg"
        >
          {screen.text.map((line, i) => (
            <motion.p
              key={i}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.8, duration: 0.8 }}
              className={`font-display tracking-wider mb-3 ${
                currentScreen === 0 ? 'text-3xl font-bold' :
                currentScreen === 1 ? 'text-4xl text-text-secondary' :
                currentScreen === 2 ? 'text-2xl font-medium' :
                'text-lg'
              }`}
              style={{
                color: currentScreen === 3 && i === 3
                  ? '#FF3333'
                  : currentScreen === 0
                    ? '#9933FF'
                    : '#FFFFFF',
                textShadow: currentScreen === 0
                  ? '0 0 30px rgba(153, 51, 255, 0.5)'
                  : currentScreen === 3
                    ? '0 0 20px rgba(255, 51, 51, 0.3)'
                    : 'none',
              }}
            >
              {line}
            </motion.p>
          ))}
        </motion.div>
      </AnimatePresence>

      {/* Subtle particle effect */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        {Array.from({ length: 15 }).map((_, i) => (
          <motion.div
            key={i}
            className="absolute w-1 h-1 rounded-full"
            style={{
              background: '#9933FF',
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
            }}
            animate={{
              opacity: [0, 0.6, 0],
              scale: [0, 1.5, 0],
              y: [0, -50 - Math.random() * 50],
            }}
            transition={{
              duration: 3 + Math.random() * 3,
              repeat: Infinity,
              delay: Math.random() * 3,
              ease: 'easeOut',
            }}
          />
        ))}
      </div>
    </motion.div>
  )
}
