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
    
    init(location: CGPoint, size: Animal.Size, side: GameModel.Side) {
        super.init()

        var color: Animal.Color
        if side == .LEFT {
            color = .WHITE
        } else {
            color = .BLACK
        }
        self.animal = Animal(color: color, size: size, status: .DEPLOYED)
        self.texture = self.animal.getTexture()
        
        self.size = self.texture!.size()
        self.xScale = animal.getImageScale().0
        self.yScale = animal.getImageScale().1
        self.position = location
        
        self.name = side.rawValue + "Running"
        
        var imageSize = CGSizeMake(self.size.width + (CGFloat)(3), self.size.height + (CGFloat)(3))
        
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: imageSize)
        if let physics = self.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true
            physics.mass = 0.1
            physics.linearDamping = 0
            physics.angularDamping = 0
            physics.restitution = 0
            physics.friction = 0
            if animal.color == .WHITE {
                physics.velocity.dx = 300 * animal.getImageMass()/10
            } else {
                physics.velocity.dx = -300 * animal.getImageMass()/10
            }
        }
        
        var repeatedAction = SKAction.animateWithTextures(animal.getDeployedTexture(), timePerFrame: 0.2)
        self.runAction(SKAction.repeatActionForever(repeatedAction))
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}