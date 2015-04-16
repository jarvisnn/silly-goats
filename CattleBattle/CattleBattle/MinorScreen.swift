//
//  MinorScreen.swift
//  CattleBattle
//
//  Created by jarvis on 4/16/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class MinorScreen {
    
    internal class func pauseView(size: CGSize) -> SKSpriteNode {
        var node = SKSpriteNode(color: UIColor(white: 0, alpha: 0.4), size: size)
        
        var continueButton = ButtonNode(buttonType: .CONTINUE, scale: 1)
        var homeButton = ButtonNode(buttonType: .HOME, scale: 1)
        
        continueButton.position = CGPointMake(-70, 0)
        homeButton.position = CGPointMake(70, 0)
        
        node.addChild(continueButton)
        node.addChild(homeButton)
        
        return node
    }
}
