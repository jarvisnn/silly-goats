//
//  SpecialPowerNode.swift
//  CattleBattle
//
//  Created by Tran Cong Thien on 10/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//


import UIKit
import SpriteKit

class PowerUpItemNode: SKSpriteNode {
    struct PhysicsCategory {
        static let None : UInt32 = 0
        static let All  : UInt32 = UInt32.max
        static let Category : UInt32 = 0b10 //2
    }
    
    struct Constants {
        internal static let IDENTIFIER = "powerUpItem"
        internal static let VELOCITY = CGFloat(200)
        internal static let FRAME_TIME_DEPLOYED = 0.05
        internal static let FRAME_TIME_BUMPING = 0.07
        internal static let PHYSICS_BODY_WIDTH = CGFloat(30)
        internal static let PHYSICS_BODY_HEIGHT = CGFloat(50)
    }
    
    internal var powerUpItem = PowerUpItem(type: .FREEZING, status: .SELECTING)
    
    init(type: PowerUpItem.PowerType) {
        super.init()
        
        self.powerUpItem = PowerUpItem(type: type, status: .SELECTING)
        updateAnimalStatus(.SELECTING)

        self.name = Constants.IDENTIFIER
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        if let physics = self.physicsBody {
            physics.categoryBitMask = PhysicsCategory.Category
            physics.contactTestBitMask = PhysicsCategory.Category
            
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true
            
            physics.restitution = 0.3
            physics.friction = 0
        }
    }
    
    internal func updateAnimalStatus(status: PowerUpItem.Status) {
        self.powerUpItem.status = status
        self.texture = self.powerUpItem.getTexture()
        
        self.size = self.texture!.size()
        
        self.xScale = powerUpItem.getImageScale().0
        self.yScale = powerUpItem.getImageScale().1
    }
    
    internal func showUp() {
        self.physicsBody!.velocity = CGVector(dx: random() % 10 + 1, dy: random() % 10 + 1)
        self.alpha = 0
        var action1 = SKAction.fadeInWithDuration(2)
        var actionList = SKAction.sequence([action1])
        self.runAction(actionList)

    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

