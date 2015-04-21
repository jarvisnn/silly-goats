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
    }
    
    struct Constants {
        internal static var volumn: Float = 1
        internal static let audio = Sound.allSounds.map() { (sound) -> AVAudioPlayer in
            return GameSound.unarchiveFromFile(sound)
        }
    }
    
    internal class func play(sound: Sound) {
        if let index = find(Sound.allSounds, sound) {
            Constants.audio[index].volume = Sound.initialVolumn[index] * Constants.volumn
            Constants.audio[index].play()
        }
    }
    
    internal class func playForever(sound: Sound) {
        if let index = find(Sound.allSounds, sound) {
            Constants.audio[index].numberOfLoops = -1
            Constants.audio[index].volume = Sound.initialVolumn[index] * Constants.volumn
            Constants.audio[index].play()
        }
    }
    
    internal class func setupAudio() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    private class func unarchiveFromFile(sound: GameSound.Sound) -> AVAudioPlayer  {
        var file = sound.rawValue
        var type = Sound.types[find(Sound.allSounds, sound)!]
        
        var path = NSBundle.mainBundle().pathForResource(file, ofType: type)
        var url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        return AVAudioPlayer(contentsOfURL: url, error: &error)!
    }
}
