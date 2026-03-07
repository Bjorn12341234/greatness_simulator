import AVFoundation

@MainActor
final class AudioEngine {
    static let shared = AudioEngine()

    private var audioEngine: AVAudioEngine?
    private var sfxVolume: Float = 0.7
    private var musicVolume: Float = 0.5

    private init() {
        configureAudioSession()
    }

    func updateVolumes(sfx: Double, music: Double) {
        sfxVolume = Float(sfx)
        musicVolume = Float(music)
    }

    // MARK: - Sound Effects

    func playTap() {
        guard sfxVolume > 0 else { return }
        playTone(frequency: 880, duration: 0.04, volume: sfxVolume * 0.3)
    }

    func playPurchase() {
        guard sfxVolume > 0 else { return }
        playTone(frequency: 523.25, duration: 0.06, volume: sfxVolume * 0.35)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            self.playTone(frequency: 659.25, duration: 0.06, volume: self.sfxVolume * 0.35)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            self.playTone(frequency: 783.99, duration: 0.08, volume: self.sfxVolume * 0.35)
        }
    }

    func playEvent() {
        guard sfxVolume > 0 else { return }
        playTone(frequency: 440, duration: 0.1, volume: sfxVolume * 0.4)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            self.playTone(frequency: 554.37, duration: 0.1, volume: self.sfxVolume * 0.4)
        }
    }

    func playEventByCategory(_ category: EventCategory) {
        guard sfxVolume > 0 else { return }
        switch category {
        case .scandal, .crisis:
            playAlarmSound()
        case .opportunity:
            playChimeSound()
        case .absurd:
            playQuirkySound()
        case .contradiction:
            playTensionSound()
        case .nobel:
            playNobelSound()
        case .realityGlitch:
            playGlitchSound()
        }
    }

    // Urgent descending alarm — two sharp square-wave notes
    private func playAlarmSound() {
        let vol = sfxVolume
        playTone(frequency: 880, duration: 0.12, volume: vol * 0.35, waveform: .square)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.playTone(frequency: 440, duration: 0.12, volume: vol * 0.35, waveform: .square)
        }
    }

    // Pleasant descending arpeggio — triangle waves
    private func playChimeSound() {
        let vol = sfxVolume
        let notes: [(freq: Double, delay: Double)] = [(880, 0.0), (659, 0.12), (523, 0.24)]
        for note in notes {
            DispatchQueue.main.asyncAfter(deadline: .now() + note.delay) {
                self.playTone(frequency: note.freq, duration: 0.18, volume: vol * 0.4, waveform: .triangle)
            }
        }
    }

    // Wobbly pitch bend — comical rising then falling
    private func playQuirkySound() {
        let vol = sfxVolume
        playTone(frequency: 300, duration: 0.08, volume: vol * 0.4)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playTone(frequency: 900, duration: 0.08, volume: vol * 0.35)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            self.playTone(frequency: 400, duration: 0.12, volume: vol * 0.3)
        }
    }

    // Dissonant minor second — unresolved tension
    private func playTensionSound() {
        let vol = sfxVolume
        playTone(frequency: 440, duration: 0.4, volume: vol * 0.3, waveform: .triangle)
        playTone(frequency: 466, duration: 0.4, volume: vol * 0.3, waveform: .triangle)
    }

    // Regal ascending fanfare — G major arpeggio
    private func playNobelSound() {
        let vol = sfxVolume
        let notes: [(freq: Double, delay: Double)] = [(392, 0.0), (494, 0.12), (587, 0.24), (784, 0.36)]
        for note in notes {
            DispatchQueue.main.asyncAfter(deadline: .now() + note.delay) {
                self.playTone(frequency: note.freq, duration: 0.35, volume: vol * 0.4)
            }
        }
    }

    // Digital noise burst — rapid random tones
    private func playGlitchSound() {
        let vol = sfxVolume
        for i in 0..<5 {
            let freq = Double.random(in: 100...2000)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.03) {
                self.playTone(frequency: freq, duration: 0.03, volume: vol * 0.25, waveform: .square)
            }
        }
    }

    func playPhaseTransition() {
        guard sfxVolume > 0 else { return }
        let notes: [(freq: Double, delay: Double)] = [
            (261.63, 0.0), (329.63, 0.15), (392.0, 0.3),
            (523.25, 0.5), (659.25, 0.7), (783.99, 0.9),
        ]
        for note in notes {
            DispatchQueue.main.asyncAfter(deadline: .now() + note.delay) {
                self.playTone(frequency: note.freq, duration: 0.2, volume: self.sfxVolume * 0.4)
            }
        }
    }

    func playAchievement() {
        guard sfxVolume > 0 else { return }
        playTone(frequency: 523.25, duration: 0.08, volume: sfxVolume * 0.35)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playTone(frequency: 659.25, duration: 0.08, volume: self.sfxVolume * 0.35)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playTone(frequency: 783.99, duration: 0.08, volume: self.sfxVolume * 0.35)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playTone(frequency: 1046.5, duration: 0.15, volume: self.sfxVolume * 0.4)
        }
    }

    func playError() {
        guard sfxVolume > 0 else { return }
        playTone(frequency: 200, duration: 0.15, volume: sfxVolume * 0.4)
    }

    // MARK: - Tone Generation

    private enum Waveform {
        case sine, square, triangle
    }

    private func playTone(frequency: Double, duration: Double, volume: Float, waveform: Waveform = .sine) {
        let engine = AVAudioEngine()
        let mixer = engine.mainMixerNode
        mixer.outputVolume = volume

        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        guard sampleRate > 0 else { return }

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        var phase: Double = 0
        let phaseIncrement = 2.0 * .pi * frequency / sampleRate

        let totalSamples = Int(duration * sampleRate)
        var samplesRendered = 0
        let fadeOutSamples = min(Int(0.01 * sampleRate), totalSamples / 4)
        let wf = waveform

        let sourceNode = AVAudioSourceNode(format: format) { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let buffer = ablPointer[0]
            let ptr = buffer.mData!.assumingMemoryBound(to: Float.self)

            for frame in 0..<Int(frameCount) {
                let currentSample = samplesRendered + frame
                guard currentSample < totalSamples else {
                    ptr[frame] = 0
                    continue
                }

                // Generate waveform sample
                let raw: Float
                switch wf {
                case .sine:
                    raw = Float(sin(phase))
                case .square:
                    raw = sin(phase) >= 0 ? 0.5 : -0.5
                case .triangle:
                    let normalized = phase / (2.0 * .pi)
                    raw = Float(4.0 * abs(normalized - 0.5) - 1.0)
                }
                var sample = raw

                // Fade out at end
                let remaining = totalSamples - currentSample
                if remaining < fadeOutSamples {
                    sample *= Float(remaining) / Float(fadeOutSamples)
                }
                // Fade in at start
                if currentSample < fadeOutSamples {
                    sample *= Float(currentSample) / Float(fadeOutSamples)
                }

                ptr[frame] = sample
                phase += phaseIncrement
                if phase > 2.0 * .pi { phase -= 2.0 * .pi }
            }
            samplesRendered += Int(frameCount)
            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mixer, format: format)

        do {
            try engine.start()
        } catch {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) {
            engine.stop()
        }
    }

    // MARK: - Audio Session

    private func configureAudioSession() {
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session configuration failed — sounds won't play
        }
        #endif
    }
}
