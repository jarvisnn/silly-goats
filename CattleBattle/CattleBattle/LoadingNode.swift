//
//  LoadingNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class LoadingNode: SKSpriteNode {
    
    var currentType : Animal.Size = .TINY
    
    
    class func loadingCattle(location: CGPoint, animalIndex : Int, side : GameModel.Side) -> LoadingNode {
        let sprite = LoadingNode(imageNamed:"goat-button-black-1.png")
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
    
    func changeImage(size : Animal.Size, side : GameModel.Side) {
        var color = Animal.Color.WHITE
        if side == .LEFT {
            color = .BLACK
        }
        var tex = Animal(color: color, size: size, status : .BUTTON).getTexture()
        self.texture = tex
        
    }
    
    func resize() {   
        self.xScale = 0.5
        self.yScale = 0.5
    }
    
    func generateRandomAnimal(side : GameModel.Side) {
        
        var generatingType : Animal.Size
        var rand = Double(Float(arc4random()) / Float(UINT32_MAX))

        if rand < 0.2 {
            generatingType = .TINY
        } else if rand < 0.4 {
            generatingType = .SMALL
        } else if rand < 0.6 {
            generatingType = .MEDIUM
        } else if rand < 0.8 {
            generatingType = .LARGE
        } else {
            generatingType = .HUGE
        }
        
        self.currentType = generatingType
        self.changeImage(generatingType, side: side)
        self.resize()
        
    }
    
    func fadeAnimation(gameModel : GameModel, side : GameModel.Side, index : Int){
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