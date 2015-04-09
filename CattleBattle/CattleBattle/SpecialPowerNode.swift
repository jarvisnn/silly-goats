//
//  SpecialPowerNode.swift
//  CattleBattle
//
//  Created by Tran Cong Thien on 10/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//


import UIKit
import SpriteKit

class SpecialPowerNode: SKSpriteNode {
    
    enum PowerType: String {
        case FREEZING = "freezing"
        case BLACK_HOLE = "blackhole"
        case UPGRADING = "upgrading"
        case SUPER = "super"
    
    }
    
    var type :PowerType = .FREEZING
    
    //init special power node from type
    override init(texture:SKTexture, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setType(type: PowerType) {
        self.type = type
    }
    
    func generateRandomSpecialPower() -> PowerType {
        var rdmValue = Float(arc4random()) /  Float(UInt32.max)
        
        if rdmValue < 0.25 {
            return .FREEZING
        } else if rdmValue < 0.5 {
            return .BLACK_HOLE
        } else if rdmValue < 0.75  {
            return .UPGRADING
        } else {
            return .SUPER
        }
    }
}

