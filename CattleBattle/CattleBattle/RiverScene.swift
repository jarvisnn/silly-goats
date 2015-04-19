//
//  RiverScene.swift
//  CattleBattle
//
//  Created by Jarvis on 4/18/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class RiverScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        var river = SKSpriteNode(imageNamed: "river.gif")
        
        river.size.width = 770
        river.position.x = self.frame.width/2
        
        var action = SKAction.sequence([
            SKAction.moveToY(river.size.height/2, duration: 0),
            SKAction.moveToY(self.frame.height-river.size.height/2, duration: 4)
            ])
        river.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(river)
    }
}
