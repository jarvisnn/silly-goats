//
//  SpecialPowerNode.swift
//  CattleBattle
//
//  Created by Tran Cong Thien on 10/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//


import UIKit
import SpriteKit

class PowerUpNode: SKSpriteNode {
    struct Constants {
        internal static let IDENTIFIER_STORED = "storedItem"
        internal static let IDENTIFIER = "powerUpItem"
        internal static let VELOCITY = CGFloat(200)
        internal static let FRAME_TIME_DEPLOYED = 0.05
        internal static let FRAME_TIME_BUMPING = 0.07
        internal static let PHYSICS_BODY_WIDTH = CGFloat(30)
        internal static let PHYSICS_BODY_HEIGHT = CGFloat(50)
    }
    
    internal var powerUpItem: PowerUp!
    internal var side : Animal.Side = .LEFT
    
    init(type: PowerUp.PowerType) {
        powerUpItem = PowerUp(type: type, status: .WAITING)
        super.init(texture: powerUpItem.getTexture(), color: UIColor.clearColor(), size: powerUpItem.getTexture().size())
        
        self.name = Constants.IDENTIFIER

        self.xScale = powerUpItem.getImageScale()
        self.yScale = powerUpItem.getImageScale()
        
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        if let physics = self.physicsBody {
            physics.categoryBitMask = GameScene.Constants.Item
            physics.contactTestBitMask = GameScene.Constants.Category
            physics.collisionBitMask = GameScene.Constants.Category | GameScene.Constants.Item
            
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true
            
            physics.restitution = 0.3
            physics.friction = 0
        }
    }
    
    internal func randomPower() {
        powerUpItem.powerType = PowerUp.PowerType.randomPowerType()
        updateItemStatus(powerUpItem.status)
    }
    
    internal func updateItemStatus(status: PowerUp.Status) {
        self.powerUpItem.status = status
        self.texture = self.powerUpItem.getTexture()
    }
    
    internal func showUp() {
        self.alpha = 0
        var action = SKAction.fadeInWithDuration(0.1)
        self.runAction(action)
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

