//
//  PlaySound.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 05/09/2023.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?
var backgroundMusicPlayer: AVAudioPlayer? // Add a separate player for background music

func playSound(sound: String, type: String, isBackgroundMusic: Bool = false) {
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

