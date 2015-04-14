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
        internal static let VELOCITY: CGFloat = 200
        internal static let FRAME_TIME_DEPLOYED = 0.05
        internal static let FRAME_TIME_BUMPING = 0.07
        internal static let PHYSICS_BODY_WIDTH: CGFloat = 30
        internal static let PHYSICS_BODY_HEIGHT: CGFloat = 50
        
        internal static let IDENTIFIER = "animalRunning"
    }

    init(size: Animal.Size, side: GameModel.Side) {
        
        var scale = Animal.Constants.scale[find(Animal.Status.allStatuses, animal.status)!][find(Animal.Size.allSizes, animal.size)!]
        super.init(texture: animal.getTexture(), color: UIColor.clearColor(), size: CGSize(width: scale, height: scale))
        
        let color: Animal.Color = (side == .LEFT) ? .WHITE : .BLACK
        self.animal = Animal(color: color, size: size, status: .DEPLOYED)
        updateAnimalStatus(.DEPLOYED)
        
        self.anchorPoint = CGPointMake(0.5, 0)
        self.name = Constants.IDENTIFIER
        
        var bodySize = CGSizeMake(Constants.PHYSICS_BODY_WIDTH, Constants.PHYSICS_BODY_HEIGHT)
        var centerPoint: CGPoint
        if (side == .LEFT) {
            centerPoint = CGPoint(x: self.size.width/2-bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        } else {
            centerPoint = CGPoint(x: -self.size.width/2+bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        }
        
        var body = SKPhysicsBody(rectangleOfSize: bodySize, center: centerPoint)
        
        body.categoryBitMask = GameScene.Constants.Goat
        body.contactTestBitMask = GameScene.Constants.Goat
        body.collisionBitMask = GameScene.Constants.Goat
            
        body.velocity.dx = (animal.color == .WHITE) ? Constants.VELOCITY : -Constants.VELOCITY
        body.velocity.dy = 0
            
        body.affectedByGravity = false
        body.allowsRotation = false
        body.dynamic = true
            
        body.restitution = 0
        body.friction = 0
            
        body.mass = animal.getMass()
        
        self.physicsBody = body
        
        var repeatedAction = SKAction.animateWithTextures(animal.getDeployedTexture(), timePerFrame: Constants.FRAME_TIME_DEPLOYED)
        self.runAction(SKAction.repeatActionForever(repeatedAction))
    }
    
    internal func updateAnimalStatus(status: Animal.Status) {
        self.animal.status = status
        self.texture = self.animal.getTexture()
        
        self.xScale = 1
        self.yScale = 1
        
        self.size = self.texture!.size()
        
        self.xScale = animal.getImageScale()
        self.yScale = self.xScale
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}