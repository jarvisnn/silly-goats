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
    
    struct Constants {
        internal static let VELOCITY = CGFloat(200)
        internal static let FRAME_TIME_DEPLOYED = 0.05
        internal static let FRAME_TIME_BUMPING = 0.07
        internal static let PHYSICS_BODY_WIDTH = CGFloat(30)
        internal static let PHYSICS_BODY_HEIGHT = CGFloat(50)
    }

    init(size: Animal.Size, side: GameModel.Side) {
        super.init()

        let color: Animal.Color = (side == .LEFT) ? .WHITE : .BLACK
        self.animal = Animal(color: color, size: size, status: .DEPLOYED)
        updateAnimalStatus(.DEPLOYED)
        
        self.name = side.rawValue + "Running"
        
        var bodySize = CGSizeMake(Constants.PHYSICS_BODY_WIDTH, Constants.PHYSICS_BODY_HEIGHT)
        var centerPoint: CGPoint
        if (side == .LEFT) {
            centerPoint = CGPoint(x: self.size.width/2-bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        } else {
            centerPoint = CGPoint(x: -self.size.width/2+bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: bodySize, center: centerPoint)
        
        physicsBody!.categoryBitMask = GameScene.Constants.Goat
        physicsBody!.contactTestBitMask = GameScene.Constants.Goat
        physicsBody!.collisionBitMask = GameScene.Constants.Goat
            
        physicsBody!.velocity.dx = (animal.color == .WHITE) ? Constants.VELOCITY : -Constants.VELOCITY
        physicsBody!.velocity.dy = 0
            
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
        physicsBody!.dynamic = true
            
        physicsBody!.restitution = 0
        physicsBody!.friction = 0
            
        physicsBody!.mass = animal.getMass()
        
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