// ── Lightweight Web Audio Sound System ──
// Procedurally generated sounds using Web Audio API — no audio files needed

let audioCtx: AudioContext | null = null

function getContext(): AudioContext {
  if (!audioCtx) {
    audioCtx = new AudioContext()
  }
  // Resume if suspended (browser autoplay policy)
  if (audioCtx.state === 'suspended') {
    audioCtx.resume()
  }
  return audioCtx
}

// ── Volume Control ──

let sfxVolume = 0.7
let masterMuted = false

export function setSfxVolume(vol: number) {
  sfxVolume = Math.max(0, Math.min(1, vol))
}

export function getSfxVolume(): number {
  return sfxVolume
}

export function setMuted(muted: boolean) {
  masterMuted = muted
}

export function isMuted(): boolean {
  return masterMuted
}

function getEffectiveVolume(): number {
  return masterMuted ? 0 : sfxVolume
}

// ── Sound Generators ──

export function playClick() {
  const vol = getEffectiveVolume()
  if (vol === 0) return

  const ctx = getContext()
  const now = ctx.currentTime

  // Quick percussive click — short sine blip
  const osc = ctx.createOscillator()
  const gain = ctx.createGain()

  osc.type = 'sine'
  osc.frequency.setValueAtTime(800, now)
  osc.frequency.exponentialRampToValueAtTime(400, now + 0.08)

  gain.gain.setValueAtTime(0.15 * vol, now)
  gain.gain.exponentialRampToValueAtTime(0.001, now + 0.08)

  osc.connect(gain)
  gain.connect(ctx.destination)

  osc.start(now)
  osc.stop(now + 0.1)
}

export function playPurchase() {
  const vol = getEffectiveVolume()
  if (vol === 0) return

  const ctx = getContext()
  const now = ctx.currentTime

  // Ascending two-tone — "upgrade acquired" feel
  const osc1 = ctx.createOscillator()
  const osc2 = ctx.createOscillator()
  const gain = ctx.createGain()

  osc1.type = 'sine'
  osc1.frequency.setValueAtTime(523, now) // C5
  osc2.type = 'sine'
  osc2.frequency.setValueAtTime(659, now + 0.1) // E5

  gain.gain.setValueAtTime(0.12 * vol, now)
  gain.gain.setValueAtTime(0.12 * vol, now + 0.15)
  gain.gain.exponentialRampToValueAtTime(0.001, now + 0.35)

  osc1.connect(gain)
  osc2.connect(gain)
  gain.connect(ctx.destination)

  osc1.start(now)
  osc1.stop(now + 0.12)
  osc2.start(now + 0.1)
  osc2.stop(now + 0.35)
}

export function playEvent() {
  const vol = getEffectiveVolume()
  if (vol === 0) return

  const ctx = getContext()
  const now = ctx.currentTime

  // Notification chime — descending arpeggio
  const notes = [880, 659, 523] // A5, E5, C5
  notes.forEach((freq, i) => {
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    const t = now + i * 0.12

    osc.type = 'triangle'
    osc.frequency.setValueAtTime(freq, t)

    gain.gain.setValueAtTime(0.1 * vol, t)
    gain.gain.exponentialRampToValueAtTime(0.001, t + 0.2)

    osc.connect(gain)
    gain.connect(ctx.destination)

    osc.start(t)
    osc.stop(t + 0.25)
  })
}

export function playAchievement() {
  const vol = getEffectiveVolume()
  if (vol === 0) return

  const ctx = getContext()
  const now = ctx.currentTime

  // Triumphant ascending fanfare
  const notes = [523, 659, 784, 1047] // C5, E5, G5, C6
  notes.forEach((freq, i) => {
    const osc = ctx.createOscillator()
    const gain = ctx.createGain()
    const t = now + i * 0.1

    osc.type = 'sine'
    osc.frequency.setValueAtTime(freq, t)

    gain.gain.setValueAtTime(0.1 * vol, t)
    gain.gain.linearRampToValueAtTime(0.08 * vol, t + 0.15)
    gain.gain.exponentialRampToValueAtTime(0.001, t + 0.4)

    osc.connect(gain)
    gain.connect(ctx.destination)

    osc.start(t)
    osc.stop(t + 0.45)
  })
}

export function playPhaseTransition() {
  const vol = getEffectiveVolume()
  if (vol === 0) return

  const ctx = getContext()
  const now = ctx.currentTime

  // Deep rumble + rising tone — dramatic shift
  // Low rumble
  const rumble = ctx.createOscillator()
  const rumbleGain = ctx.createGain()
  rumble.type = 'sawtooth'
  rumble.frequency.setValueAtTime(60, now)
  rumble.frequency.linearRampToValueAtTime(80, now + 2)
  rumbleGain.gain.setValueAtTime(0.06 * vol, now)
  rumbleGain.gain.linearRampToValueAtTime(0.1 * vol, now + 1)
  rumbleGain.gain.exponentialRampToValueAtTime(0.001, now + 3)
  rumble.connect(rumbleGain)
  rumbleGain.connect(ctx.destination)
  rumble.start(now)
  rumble.stop(now + 3.5)

  // Rising tone
  const rise = ctx.createOscillator()
  const riseGain = ctx.createGain()
  rise.type = 'sine'
  rise.frequency.setValueAtTime(200, now + 0.5)
  rise.frequency.exponentialRampToValueAtTime(1200, now + 2.5)
  riseGain.gain.setValueAtTime(0.001, now + 0.5)
  riseGain.gain.linearRampToValueAtTime(0.08 * vol, now + 1.5)
  riseGain.gain.exponentialRampToValueAtTime(0.001, now + 3)
  rise.connect(riseGain)
  riseGain.connect(ctx.destination)
  rise.start(now + 0.5)
  rise.stop(now + 3.5)
}
