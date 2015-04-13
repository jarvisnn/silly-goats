//
//  PowerUpItem.swift
//  CattleBattle
//
//  Created by Jarvis on 4/12/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class PowerUpItem {
    enum PowerType: String {
        case FREEZING = "freezing"
        case BLACK_HOLE = "blackhole"
        case UPGRADING = "upgrading"
        case SUPER = "super"
        
        internal static let types = [FREEZING, BLACK_HOLE, UPGRADING, SUPER]
        internal static let immediatelyImplemented = [true, false, true, true]
    }
    
    enum Status: String {
        case SELECTING = "selecting-item-"
        case NOTSELECTED = "item-"
    }
    
    struct Constants {
        internal static let IMAGE_EXT = ".png"
        internal static let IMAGE_SCALE = CGFloat(0.3)
    }
    
    internal var status: Status
    internal var type: PowerType
    
    private func _getImageFileName() -> String {
        return  status.rawValue + type.rawValue + Constants.IMAGE_EXT
    }
    
    internal func getTexture() -> SKTexture {
        return SKTexture(imageNamed: _getImageFileName())
    }
    
    func randomPower() {
        type = PowerType.types[Int(arc4random_uniform(UInt32(PowerType.types.count)))]
    }
    
    init(type: PowerType, status: Status) {
        self.type = type
        self.status = status
    }
    
    internal func getImageScale() -> (CGFloat, CGFloat) {
        return (Constants.IMAGE_SCALE, Constants.IMAGE_SCALE)
    }
    
    internal func getImplementationType() -> Bool {
        return PowerType.immediatelyImplemented[find(PowerType.types, type)!]
    }
}
 