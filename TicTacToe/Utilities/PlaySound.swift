import AVFoundation

var audioPlayer: AVAudioPlayer?
var backgroundMusicPlayer: AVAudioPlayer?
var audioSession = AVAudioSession.sharedInstance()

func playSound(sound: String, type: String, isBackgroundMusic: Bool = false) {
    do {
        try audioSession.setCategory(.ambient, mode: .default)
        try audioSession.setActive(true)
    } catch {
        print("Error setting audio session category: \(error.localizedDescription)")
    }

    if !isBackgroundMusic, let audioPlayer = audioPlayer, audioPlayer.isPlaying {
        audioPlayer.stop()
    }

    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            if isBackgroundMusic {
                backgroundMusicPlayer = player
                backgroundMusicPlayer?.numberOfLoops = -1 // Loop background music indefinitely
            } else {
                audioPlayer = player
            }
            player.play()
        } catch {
            print("ERROR: Could not find and play the sound file")
        }
    }
}

func adjustVolume(_ decrease: Bool) {
       if let player = audioPlayer {
           let currentVolume = player.volume
           let newVolume = decrease ? max(0.0, currentVolume - 0.1) : min(1.0, currentVolume + 0.1)
           player.volume = newVolume
       }
   }
