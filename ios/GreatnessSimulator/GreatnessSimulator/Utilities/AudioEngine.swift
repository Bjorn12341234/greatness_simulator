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

    private func playTone(frequency: Double, duration: Double, volume: Float) {
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
                var sample = Float(sin(phase))

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
