import AVFoundation
import SwiftUI
import Combine

class AudioManager: ObservableObject {
    var backgroundAudioPlayer: AVAudioPlayer?

    init() {
        if let url = Bundle.main.url(forResource: "game-music", withExtension: "mp3") {
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundAudioPlayer?.prepareToPlay()
                backgroundAudioPlayer?.play()
            } catch {
                print("Error loading background music: \(error)")
            }
        }
    }
}
// Make AudioManager accessible from the preview
#if DEBUG
extension EnvironmentValues {
    var audioManager: AudioManager {
        get { self[AudioManagerKey.self] }
        set { self[AudioManagerKey.self] = newValue }
    }
}

private struct AudioManagerKey: EnvironmentKey {
    static var defaultValue: AudioManager { AudioManager() }
}
#endif
