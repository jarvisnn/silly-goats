//
//  MinorScreen.swift
//  CattleBattle
//
//  Created by jarvis on 4/16/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameOverScene: SKSpriteNode {
    struct Constants {
        private static var WIN_FILENAME = "win"
        private static var LOSE_FILENAME = "lose"
        private static var IMAGE_EXT = ".png"
        private static var HOME_POSITION = CGPointMake(0, -70)
        private static var RESTART_POSITION = CGPointMake(0, 70)
        private static var TROPHY_OFFSET: CGFloat = 300
    }
    
    private var _trophy = [SKSpriteNode]()
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(white:0, alpha: 0.2), size: size)
        var restartButton = MenuButtonNode(buttonType: .RESTART, scale: 1)
        var homeButton = MenuButtonNode(buttonType: .HOME, scale: 1)
        restartButton.position = Constants.RESTART_POSITION
        homeButton.position = Constants.HOME_POSITION
        self.addChild(restartButton)
        self.addChild(homeButton)
        
        for side in Animal.Side.allSides {
            _trophy.append(SKSpriteNode(imageNamed: Constants.WIN_FILENAME + Constants.IMAGE_EXT))
            var x = Constants.TROPHY_OFFSET
            _trophy[side.index].position = CGPointMake((side == .LEFT) ? -x : x, 0)
            self.addChild(_trophy[side.index])
        }
        update()
    }
    
    internal func update() {
        var score = GameModel.Constants.gameModel.score
        for side in Animal.Side.allSides {
            _trophy[side.index].texture = GameOverScene._getTrophy(score[side.index], opponent: score[1 - side.index])
        }
    }

    internal class func _getTrophy(you: Int, opponent: Int) -> SKTexture {
        var fileName = (you >= opponent) ? Constants.WIN_FILENAME : Constants.LOSE_FILENAME
        return SKTexture(imageNamed: fileName + Constants.IMAGE_EXT)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
