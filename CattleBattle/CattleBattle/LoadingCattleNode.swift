//
//  LoadingCattleNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import UIKit
import SpriteKit

class LoadingCattleNode: SKSpriteNode {
    
    let prob_size1 = 0.25
    let prob_size2 = 0.25
    let prob_size3 = 0.25
    let prob_size4 = 0.25
    
    var currentType : Animal.name = .empty
    
    
    class func loadingCattle(location: CGPoint, animalIndex : Int) -> LoadingCattleNode {
        let sprite = LoadingCattleNode(imageNamed:"yellowStar.png")
        sprite.generateRandomAnimal()
        sprite.position = location
        
       
        //       sprite.physicsBody = SKPhysicsBody(texture: tex, size: sprite.size)
        var imageSize = CGSizeMake(sprite.size.width + (CGFloat)(2), sprite.size.height + (CGFloat)(2))
//        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:imageSize)
//        if let physics = sprite.physicsBody {
//            physics.affectedByGravity = true
//            physics.allowsRotation = false
//            physics.dynamic = true;
//            physics.linearDamping = 1
//            physics.angularDamping = 1
//            
//            //            physics.velocity.dx = 50
//            
//            var mvAction = SKAction.moveByX((CGFloat)(direction*30), y: 0, duration: 0.3)
//            var mvforeverAction = SKAction.repeatActionForever(mvAction)
//            sprite.runAction(mvforeverAction)
//            
//        }
        
        return sprite
    }
    
    func changeImage(type : Animal.name) {
        var tex = SKTexture(imageNamed: Animal.getImageName(Animal(type: type))())
        self.texture = tex
        
    }
    
    func resize() {
        self.xScale = Animal(type: self.currentType).getImageScale().0
        self.yScale = Animal(type: self.currentType).getImageScale().1
    }
    
    func generateRandomAnimal() {
        var generatingType : Animal.name
        var rand = Double(Float(arc4random()) / Float(UINT32_MAX))
        if rand < prob_size1 {
            generatingType = .size1
        } else if rand < prob_size1 + prob_size2 {
            generatingType = .size2
        } else if rand < prob_size1 + prob_size2 + prob_size3 {
            generatingType = .size3
        } else {
            generatingType = .size4
        }
        self.currentType = generatingType
        self.changeImage(generatingType)
        self.resize()
    }
    
}