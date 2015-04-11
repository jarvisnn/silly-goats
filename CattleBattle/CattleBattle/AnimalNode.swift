//
//  AnimalNode.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/2/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class AnimalNode: SKSpriteNode {
    
    internal var animal = Animal(color: .WHITE, size: .TINY, status: .DEPLOYED)
    
    struct PhysicsCategory {
        static let None : UInt32 = 0
        static let All  : UInt32 = UInt32.max
        static let Goat : UInt32 = 0b1 //1
    }
    
    struct Constants {
        internal static let VELOCITY = CGFloat(200)
        internal static let FRAME_TIME_DEPLOYED = 0.1
        internal static let FRAME_TIME_BUMPING = 0.15
        internal static let PHYSICS_BODY_WIDTH = CGFloat(30)
    }

    init(size: Animal.Size, side: GameModel.Side) {
        super.init()

        let color: Animal.Color = (side == .LEFT) ? .WHITE : .BLACK
        self.animal = Animal(color: color, size: size, status: .DEPLOYED)
        updateAnimalStatus(.DEPLOYED)
        
        self.name = side.rawValue + "Running"
        
        var bodySize = CGSizeMake(Constants.PHYSICS_BODY_WIDTH, self.size.height / 2)
        var centerPoint: CGPoint
        if (side == .LEFT) {
            centerPoint = CGPoint(x: self.size.width/2-bodySize.width/2, y: 0)
        } else {
            centerPoint = CGPoint(x: -self.size.width/2+bodySize.width/2, y: 0)
        }
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: bodySize, center: centerPoint)
        if let physics = self.physicsBody {
            physics.categoryBitMask = PhysicsCategory.Goat
            physics.contactTestBitMask = PhysicsCategory.Goat
            
            physics.velocity.dx = (animal.color == .WHITE) ? Constants.VELOCITY : -Constants.VELOCITY
            physics.velocity.dy = 0
            
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            
            physics.restitution = 0
            physics.friction = 0
            
            physics.mass = 0.1
        }
        
        var repeatedAction = SKAction.animateWithTextures(animal.getDeployedTexture(), timePerFrame: Constants.FRAME_TIME_DEPLOYED)
        self.runAction(SKAction.repeatActionForever(repeatedAction))
    }
    
    internal func updateAnimalStatus(status: Animal.Status) {
        self.animal.status = status
        self.texture = self.animal.getTexture()
        
        let oldHeight = self.size.height
        
        self.xScale = 1
        self.yScale = 1
        
        self.size = self.texture!.size()

        self.xScale = oldHeight < 1 ? animal.getImageScale().0 : oldHeight/self.size.height
        self.yScale = self.xScale
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}