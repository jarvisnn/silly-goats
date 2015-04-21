//
//  GameSound.swift
//  CattleBattle
//
//  Created by kunn on 4/19/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import AVFoundation
import SpriteKit

class GameSound {
    
    struct Constants {
        internal static let soundtrack = GameSound.unarchiveFromFile("sound-track", type: "mp3")
        internal static let freeze = GameSound.unarchiveFromFile("freeze", type: "mp3")
        internal static let blackhole = GameSound.unarchiveFromFile("blackhole", type: "wav")
        internal static let upgrade = GameSound.unarchiveFromFile("upgrade", type: "wav")
        internal static let goatSound = GameSound.unarchiveFromFile("goat-sound", type: "flac")
    }
    
    internal class func setupAudio() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    private class func unarchiveFromFile(file: String, type: String) -> AVAudioPlayer  {
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType:type as String)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        return audioPlayer!
    }
}
