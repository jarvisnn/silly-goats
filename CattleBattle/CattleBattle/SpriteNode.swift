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
        
        sprite.xScale = 0.075
        sprite.yScale = 0.075
        sprite.position = location
        
        var tex = SKTexture(imageNamed: imageName)
        
//       sprite.physicsBody = SKPhysicsBody(texture: tex, size: sprite.size)
        var imageSize = CGSizeMake(sprite.size.width + (CGFloat)(2), sprite.size.height + (CGFloat)(2))
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:imageSize)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true;
            physics.linearDamping = 1
            physics.angularDamping = 1
            
//            physics.velocity.dx = 50
            
            var mvAction = SKAction.moveByX((CGFloat)(direction*30), y: 0, duration: 0.3)
            var mvforeverAction = SKAction.repeatActionForever(mvAction)
            sprite.runAction(mvforeverAction)
            
        }
        
        return sprite
    }
    
   
    
}