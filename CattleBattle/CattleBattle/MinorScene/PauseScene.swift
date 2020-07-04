//
//  PauseScene.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/20/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class PauseScene: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(white: 0, alpha: 0.4), size: size)
        
        let continueButton = MenuButtonNode(buttonType: .CONTINUE, scale: 1)
        let homeButton = MenuButtonNode(buttonType: .HOME, scale: 1)
        let restartButton = MenuButtonNode(buttonType: .RESTART, scale: 1)
        
        restartButton.position = CGPoint(x: -100, y: 0)
        continueButton.position = CGPoint(x: 0, y: 0)
        homeButton.position = CGPoint(x: 100, y: 0)
        
        self.addChild(restartButton)
        self.addChild(continueButton)
        self.addChild(homeButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

