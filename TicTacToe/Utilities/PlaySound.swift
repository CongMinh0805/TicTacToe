import AVFoundation

var audioPlayer: AVAudioPlayer? //short audio sounds
var backgroundMusicPlayer: AVAudioPlayer?  //background music
var audioSession = AVAudioSession.sharedInstance()

//play the sound
func playSound(sound: String, type: String, isBackgroundMusic: Bool = false) {
    do {
        //allows mixing with other audio
        try audioSession.setCategory(.ambient, mode: .default)
        try audioSession.setActive(true)
    } catch {
        print("Error setting audio session category: \(error.localizedDescription)")
    }
    //stop current playing sound
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


//increase or decrease volume
func adjustVolume(_ decrease: Bool) {
       if let player = audioPlayer {
           let currentVolume = player.volume
           let newVolume = decrease ? max(0.0, currentVolume - 0.1) : min(1.0, currentVolume + 0.1)
           player.volume = newVolume
       }
   }
