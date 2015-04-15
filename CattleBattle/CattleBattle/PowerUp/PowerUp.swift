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
        internal static let targeted = [true, false, true, true]

        internal static func randomPowerType() -> PowerType {
            return allTypes[Int(arc4random_uniform(UInt32(PowerType.allTypes.count)))]
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
    
    private func _getImageFileName() -> String {
        var fileName = join("-", [Constants.POWERUP_KEYWORD, status.rawValue, powerType.rawValue])
        return fileName + Constants.IMAGE_EXT
    }
    
    internal func getTexture() -> SKTexture {
        return Constants.textures[find(Status.allStatus, status)!][find(PowerType.allTypes, powerType)!]
    }
    
    init(type: PowerType, status: Status) {
        self.powerType = type
        self.status = status
    }
    
    internal func getImageScale() -> CGFloat {
        return Constants.IMAGE_SCALE
    }
    
    internal func getImplementationType() -> Bool {
        return PowerType.targeted[find(PowerType.allTypes, powerType)!]
    }
}
 