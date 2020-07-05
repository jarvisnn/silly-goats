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
    
    internal var animal = Animal(side: .LEFT, size: .TINY, status: .DEPLOYED)
    internal var row: Int = 0
    
    struct Constants {
        internal static let VELOCITY: CGFloat = 200
        internal static let FRAME_TIME_DEPLOYED = 0.05
        internal static let FRAME_TIME_BUMPING = 0.07
        internal static let PHYSICS_BODY_WIDTH: CGFloat = 30
        internal static let PHYSICS_BODY_HEIGHT: CGFloat = 50
        
        internal static let IDENTIFIER = "animalRunning"
    }

    init(size: Animal.Size, side: Animal.Side, row: Int) {
        let scale = Animal.Constants.scale[Animal.Status.allStatuses.firstIndex(of: animal.status)!][Animal.Size.allSizes.firstIndex(of:  animal.size)!]
        super.init(texture: animal.getTexture(), color: UIColor.clear, size: CGSize(width: scale, height: scale))
        
        self.name = Constants.IDENTIFIER
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        self.animal = Animal(side: side, size: size, status: .DEPLOYED)
        self.row = row
        
        updateAnimalStatus(.DEPLOYED)
        setupPhysicsBody()
    }
    
    internal func updateAnimalStatus(_ status: Animal.Status) {
        self.animal.status = status
        self.texture = self.animal.getTexture()
        self.size = self.texture!.size() * animal.getImageScale()
        
        let textures = status == .DEPLOYED ? animal.getDeployedTexture() : animal.getBumpingTexture()
        let repeatedAction = SKAction.animate(with: textures, timePerFrame: Constants.FRAME_TIME_DEPLOYED)
        self.run(SKAction.repeatForever(repeatedAction))
        

    }
    
    fileprivate func setupPhysicsBody() {
        let bodySize = CGSize(width: Constants.PHYSICS_BODY_WIDTH, height: Constants.PHYSICS_BODY_HEIGHT)
        var centerPoint: CGPoint
        if (animal.side == .LEFT) {
            centerPoint = CGPoint(x: self.size.width/2-bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        } else {
            centerPoint = CGPoint(x: -self.size.width/2+bodySize.width/2, y: -self.size.height/2+bodySize.height/2)
        }

        let body = SKPhysicsBody(rectangleOf: bodySize, center: centerPoint)
        
        body.categoryBitMask = GameScene.Constants.Goat
        body.contactTestBitMask = GameScene.Constants.Goat
        body.collisionBitMask = GameScene.Constants.Goat
        
        body.velocity.dx = (animal.side == .LEFT) ? Constants.VELOCITY : -Constants.VELOCITY
        body.velocity.dy = 0
        
        body.affectedByGravity = false
        body.allowsRotation = false
        body.isDynamic = true
        
        body.restitution = 0
        body.friction = 0
        
        body.mass = animal.getMass()
        
        self.physicsBody = body
    }
    
    internal func updateAnimalType(_ size: Animal.Size) {
        self.animal.size = size
        updateAnimalStatus(self.animal.status)
        setupPhysicsBody()
    }
    
    override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
