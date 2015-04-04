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
    
    var currentType : Animal.Size = .TINY
    
    
    class func loadingCattle(location: CGPoint, animalIndex : Int, side : GameModel.side) -> LoadingCattleNode {
        let sprite = LoadingCattleNode(imageNamed:"yellowStar.png")
        sprite.generateRandomAnimal(side)
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
    
    func changeImage(size : Animal.Size, side : GameModel.side) {
        var color = Animal.Color.WHITE
        if side == .left {
            color = .BLACK
        }
        var tex = Animal(color: color, size: size, status : .BUTTON).getTexture()
        self.texture = tex
        
    }
    
    func resize() {   
        self.xScale = 0.5
        self.yScale = 0.5
    }
    
    func generateRandomAnimal(side : GameModel.side) {
        var generatingType : Animal.Size
        var rand = Double(Float(arc4random()) / Float(UINT32_MAX))
        if rand < prob_size1 {
            generatingType = .TINY
        } else if rand < prob_size1 + prob_size2 {
            generatingType = .SMALL
        } else if rand < prob_size1 + prob_size2 + prob_size3 {
            generatingType = .MEDIUM
        } else {
            generatingType = .LARGE
        }
        self.currentType = generatingType
        self.changeImage(generatingType, side: side)
        self.resize()
        
    }
    
    func fadeAnimation(gameModel : GameModel, side : GameModel.side, index : Int){
        self.alpha = 0
        var action1 = SKAction.fadeInWithDuration(3)
        var action2 = SKAction.scaleBy(1.2, duration: 0.3)
        var action3 = action2.reversedAction()
        var actionList = SKAction.sequence([action1, action2 ,action3])
        self.runAction(actionList, completion: { () -> Void in            
            gameModel.reloadCattle(side, index: index)
        })
    }
}