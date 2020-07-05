//
//  PowerUpItem.swift
//  CattleBattle
//
//  Created by Jarvis on 4/12/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class PowerUp {

    enum Status: String {
        case SELECTED = "selected"
        case WAITING = "waiting"
        
        internal static let allStatus = [SELECTED, WAITING]
    }
    
    enum PowerType: String {
        case FREEZE = "freeze"
        case BLACK_HOLE = "blackhole"
        case UPGRADE = "upgrade"
        case FIRE = "fire"
        
        internal static let allTypes = [FREEZE, BLACK_HOLE, UPGRADE, FIRE]
        internal static let targeted = [true, true, true, true]

        internal static func randomPowerType() -> PowerType {
            return allTypes[Int(arc4random_uniform(UInt32(PowerType.allTypes.count)))]
        }
        
        internal static func targetFriendly(_ powerType: PowerType) -> Bool {
            return (powerType == .UPGRADE) ? true : false
        }
    }
    
    struct Constants {
        internal static let POWERUP_KEYWORD = "item"
        internal static let IMAGE_EXT = ".png"
        internal static let IMAGE_SCALE: CGFloat = 0.3
        
        internal static var textures = Status.allStatus.map() { (status) -> [SKTexture] in
            return PowerType.allTypes.map() { (power) -> SKTexture in
                return SKTexture(imageNamed: PowerUp(type: power, status: status)._getImageFileName())
            }
        }
    }
    
    internal var status: Status
    internal var powerType: PowerType

    fileprivate func _getImageFileName() -> String {
        let fileName = [Constants.POWERUP_KEYWORD, status.rawValue, powerType.rawValue].joined(separator: "-")
        return fileName + Constants.IMAGE_EXT
    }
    
    internal func getTexture() -> SKTexture {
        return Constants.textures[Status.allStatus.index(of: status)!][PowerType.allTypes.index(of: powerType)!]
    }
    
    init(type: PowerType, status: Status) {
        self.powerType = type
        self.status = status
    }
    
    internal func getImageScale() -> CGFloat {
        return Constants.IMAGE_SCALE
    }
    
    internal func getImplementationType() -> Bool {
        return PowerType.targeted[PowerType.allTypes.index(of: powerType)!]
    }
}
 
