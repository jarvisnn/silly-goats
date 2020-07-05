//
//  RiverScene.swift
//  CattleBattle
//
//  Created by Jarvis on 4/18/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class RiverScene: SKScene {
    
    override func didMove(to view: SKView) {
        let river = SKSpriteNode(imageNamed: "river.gif")
        
        river.size.width = 770
        river.position.x = self.frame.width/2
        
        let action = SKAction.sequence([
            SKAction.moveTo(y: river.size.height/2, duration: 0),
            SKAction.moveTo(y: self.frame.height-river.size.height/2, duration: 4)
            ])
        river.run(SKAction.repeatForever(action))
        
        self.addChild(river)
    }
}
