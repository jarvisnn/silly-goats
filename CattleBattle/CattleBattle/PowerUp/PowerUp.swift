//
//  PowerUpItem.swift
//  CattleBattle
//
//  Created by Jarvis on 4/12/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class PowerUp {
    enum PowerType: String {
        case FREEZING = "freezing"
        case BLACK_HOLE = "blackhole"
        case UPGRADING = "upgrading"
        case SUPER = "super"
        
        internal static let allTypes = [FREEZING, BLACK_HOLE, UPGRADING, SUPER]
        internal static let targeted = [true, false, true, true]

        internal static func randomPowerType() -> PowerType {
            return allTypes[Int(arc4random_uniform(UInt32(PowerType.allTypes.count)))]
        }
    }
    
    enum Status: String {
        case SELECTING = "selecting-item-"
        case NOTSELECTED = "item-"
    }
    
    struct Constants {
        internal static let IMAGE_EXT = ".png"
        internal static let IMAGE_SCALE: CGFloat = 0.3
    }
    
    internal var status: Status
    internal var type: PowerType
    
    private func _getImageFileName() -> String {
        return status.rawValue + type.rawValue + Constants.IMAGE_EXT
    }
    
    internal func getTexture() -> SKTexture {
        return SKTexture(imageNamed: _getImageFileName())
    }
    
    
    init(type: PowerType, status: Status) {
        self.type = type
        self.status = status
    }
    
    internal func getImageScale() -> (CGFloat, CGFloat) {
        return (Constants.IMAGE_SCALE, Constants.IMAGE_SCALE)
    }
    
    internal func getImplementationType() -> Bool {
        return PowerType.targeted[find(PowerType.allTypes, type)!]
    }
}
 