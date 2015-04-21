//
//  MinorScreen.swift
//  CattleBattle
//
//  Created by jarvis on 4/16/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class MinorScreen: SKSpriteNode {
    struct Constants {
        internal static var WIN_FILENAME = "win"
        internal static var LOSE_FILENAME = "lose"
        internal static var IMAGE_EXT = ".png"
        internal static var HOME_POSITION = CGPointMake(0, -70)
        internal static var RESTART_POSITION = CGPointMake(0, 70)
        internal static var TROPHY_OFFSET: CGFloat = 300
    }
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(white:0, alpha: 0.2), size: size)
        var restartButton = MenuButtonNode(buttonType: .RESTART, scale: 1)
        var homeButton = MenuButtonNode(buttonType: .HOME, scale: 1)
        restartButton.position = Constants.RESTART_POSITION
        homeButton.position = Constants.HOME_POSITION
        self.addChild(restartButton)
        self.addChild(homeButton)
        
        var score = GameModel.Constants.gameModel.score
        
        for side in Animal.Side.allSides {
            var trophy = MinorScreen._getTrophy(score[side.index], opponent: score[1 - side.index])
            var x = Constants.TROPHY_OFFSET
            trophy.position = CGPointMake((side == .LEFT) ? -x : x, 0)
            self.addChild(trophy)
        }
    }

    internal class func _getTrophy(you: Int, opponent: Int) -> SKSpriteNode {
        var fileName = (you >= opponent) ? Constants.WIN_FILENAME : Constants.LOSE_FILENAME
        return SKSpriteNode(imageNamed: fileName + Constants.IMAGE_EXT)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
