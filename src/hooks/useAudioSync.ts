import { useEffect } from 'react'
import { useGameStore } from '../store/gameStore'
import { setSfxVolume } from '../engine/audio'

// Keeps the audio system in sync with the store's volume settings
export function useAudioSync() {
  const sfxVolume = useGameStore(s => s.settings.sfxVolume)

  useEffect(() => {
    setSfxVolume(sfxVolume)
  }, [sfxVolume])
}
