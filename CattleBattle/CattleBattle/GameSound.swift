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
    
    enum Sound: String {
        case SOUNDTRACK = "sound-track"
        case FREEZE = "freeze"
        case BLACKHOLE = "blackhole"
        case UPGRADE = "upgrade"
        case FIRE = "fire"
        case BUTTON_CLICK = "button-clicked"
        case GOAT_SOUND = "goat-sound"
        
        private static let allSounds = [SOUNDTRACK, FREEZE, BLACKHOLE, UPGRADE, FIRE, BUTTON_CLICK, GOAT_SOUND]
        private static let types = ["mp3", "mp3", "wav", "wav", "wav", "wav", "wav"]
        private static let initialVolumn: [Float] = [1, 1, 1, 1, 1, 1, 1]
        private static let startPoints: [Double] = [0, 0, 0, 0, 0, 0, 0.5]
    }
    
    struct Constants {
        internal static let audio = Sound.allSounds.map() { (sound) -> AVAudioPlayer in
            return _sharedInstance.unarchiveFromFile(sound)
        }
       
        internal static let instance: GameSound = _sharedInstance
    }
    
    private var volumn: Float
    
    private init() {
        self.volumn = 1
    }
    
    internal func play(sound: Sound) {
        if let index = find(Sound.allSounds, sound) {
            Constants.audio[index].volume = Sound.initialVolumn[index] * self.volumn
            Constants.audio[index].currentTime = Sound.startPoints[index]
            Constants.audio[index].play()
        }
    }
    
    internal func playForever(sound: Sound) {
        if let index = find(Sound.allSounds, sound) {
            Constants.audio[index].numberOfLoops = -1
            Constants.audio[index].volume = Sound.initialVolumn[index] * self.volumn
            Constants.audio[index].currentTime = Sound.startPoints[index]
            Constants.audio[index].play()
        }
    }
    
    internal func setupAudio() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    private func unarchiveFromFile(sound: GameSound.Sound) -> AVAudioPlayer  {
        var file = sound.rawValue
        var type = Sound.types[find(Sound.allSounds, sound)!]
        
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        return AVAudioPlayer(contentsOfURL: url, error: &error)!
    }
}

private let _sharedInstance = GameSound()