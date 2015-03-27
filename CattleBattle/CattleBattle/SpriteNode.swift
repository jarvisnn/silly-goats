//
//  SpriteNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//
import UIKit
import SpriteKit

class StarNode: SKSpriteNode {
    
    class func getAnimal(location: CGPoint, direction : Int, type : Animal.name) -> StarNode {
        var animal = Animal(type : type)
        var imageName = animal.getImageName()
        let sprite = StarNode(imageNamed:imageName)
        
        
        sprite.xScale = animal.getImageScale().0
        sprite.yScale = animal.getImageScale().1
        
        sprite.position = location
       
        var tex = SKTexture(imageNamed: imageName)
        
//       sprite.physicsBody = SKPhysicsBody(texture: tex, size: sprite.size)
        var imageSize = CGSizeMake(sprite.size.width + (CGFloat)(50), sprite.size.height + (CGFloat)(10))
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:imageSize)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = true
            physics.mass = animal.getImageMass()
            physics.linearDamping = 0
            physics.angularDamping = 0
            physics.restitution = 0
            physics.friction = 0
            
//            physics.velocity.dx = 50
            
            var mvAction = SKAction.moveByX((CGFloat)(direction*30), y: 0, duration: 0.2)
            var mvforeverAction = SKAction.repeatActionForever(mvAction)
            sprite.runAction(mvforeverAction)
            
        }
        
        return sprite
    }
    
   
    
}