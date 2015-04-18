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
        
        
        println("hello")
        
        river.position = CGPointMake(500, 500)
        self.addChild(river)

    }
}
