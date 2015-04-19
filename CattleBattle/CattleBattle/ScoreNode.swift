//
//  ScoreNode.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/20/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class ScoreNode: SKLabelNode {
    
    struct Constants {
        internal static let LABEL_FONT = "Chalkduster"
        internal static let FONT_SIZE: CGFloat = 40
        internal static let POS_Y: CGFloat = 710
        internal static let POS_X: [CGFloat] = [420, 604]
    }
    
    internal var side: Animal.Side = .LEFT
    
    internal var score: Int {
        get {
            return GameModel.Constants.gameModel.score[side.index]
        }
        set {
            GameModel.Constants.gameModel.score[side.index] = newValue
            self.text = String(newValue)
        }
    }
    
    convenience init(side: Animal.Side) {
        self.init(fontNamed: Constants.LABEL_FONT)
        self.side = side
        self.fontSize = Constants.FONT_SIZE;
        self.position = CGPoint(x: Constants.POS_X[side.index], y: Constants.POS_Y);
    }
    
}
