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
    
    internal class func gameOverView(size: CGSize, winner: Int) -> SKSpriteNode {
        var node = SKSpriteNode(color: UIColor(white:0, alpha: 0.2), size: size)
        
        var restartButton = ButtonNode(buttonType: .RESTART, scale: 1)
        var homeButton = ButtonNode(buttonType: .HOME, scale: 1)
        var win = SKSpriteNode(imageNamed: "win.png")
        var lose = SKSpriteNode(imageNamed: "lose.png")
        
        restartButton.position = CGPointMake(0, -70)
        homeButton.position = CGPointMake(0, 70)
        if winner == 0 {
            win.position = CGPointMake(-300, 0)
            lose.position = CGPointMake(300, 0)
        } else if winner == 1 {
            win.position = CGPointMake(300, 0)
            lose.position = CGPointMake(-300, 0)
        } else {
            win.position = CGPointMake(300, 0)
            lose = SKSpriteNode(imageNamed: "win.png")
            lose.position = CGPointMake(-300, 0)
        }
        
        node.addChild(restartButton)
        node.addChild(homeButton)
        node.addChild(win)
        node.addChild(lose)
        
        return node
    }
}
