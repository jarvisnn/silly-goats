//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var dir = 1
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
//            for touch: AnyObject in touches {
//                let sprite = StarNode.star(touch.locationInNode(self), direction: dir)
//                changeDirection()
//                sprite.xScale = 0.03
//                sprite.yScale = 0.03
//                self.addChild(sprite)
//            }
           
        }
    }
    
   
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addObject(location : CGPoint, direction : Int) {
        let sprite = StarNode.star(location, direction: direction)
        sprite.xScale = 0.03
        sprite.yScale = 0.03
        self.addChild(sprite)
    }
    
    func changeDirection() {
        if dir == 1 {
            dir = -1
        } else {
            dir = 1
        }
    }
}
