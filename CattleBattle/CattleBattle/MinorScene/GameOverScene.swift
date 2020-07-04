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
        fileprivate static var WIN_FILENAME = "win"
        fileprivate static var LOSE_FILENAME = "lose"
        fileprivate static var IMAGE_EXT = ".png"
        fileprivate static var HOME_POSITION = CGPoint(x: 0, y: -70)
        fileprivate static var RESTART_POSITION = CGPoint(x: 0, y: 70)
        fileprivate static var TROPHY_OFFSET: CGFloat = 300
    }
    
    fileprivate var _trophy = [SKSpriteNode]()
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor(white:0, alpha: 0.2), size: size)
        let restartButton = MenuButtonNode(buttonType: .RESTART, scale: 1)
        let homeButton = MenuButtonNode(buttonType: .HOME, scale: 1)
        restartButton.position = Constants.RESTART_POSITION
        homeButton.position = Constants.HOME_POSITION
        self.addChild(restartButton)
        self.addChild(homeButton)
        
        for side in Animal.Side.allSides {
            _trophy.append(SKSpriteNode(imageNamed: Constants.WIN_FILENAME + Constants.IMAGE_EXT))
            let x = Constants.TROPHY_OFFSET
            _trophy[side.index].position = CGPoint(x: (side == .LEFT) ? -x : x, y: 0)
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

    internal class func _getTrophy(_ you: Int, opponent: Int) -> SKTexture {
        let fileName = (you >= opponent) ? Constants.WIN_FILENAME : Constants.LOSE_FILENAME
        return SKTexture(imageNamed: fileName + Constants.IMAGE_EXT)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
