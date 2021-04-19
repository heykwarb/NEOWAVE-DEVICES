//
//  PlaySound.swift
//  NEOWAVE Kicks
//
//  Created by Yohey Kuwabara on 2021/04/11.
//

import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
            print("playSound")
        } catch {
            print("ERROR")
        }
    }
}
