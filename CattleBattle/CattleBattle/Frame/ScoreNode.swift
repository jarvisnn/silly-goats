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
        private static let LABEL_FONT = "Chalkduster"
        private static let FONT_SIZE: CGFloat = 40
        private static let POS_Y: CGFloat = 710
        private static let POS_X: [CGFloat] = [420, 604]
    }
    
    internal var side: Animal.Side!
    
    internal var score: Int {
        get {
            return GameModel.Constants.gameModel.score[side.index]
        }
        set {
            GameModel.Constants.gameModel.score[side.index] = newValue
            self.text = String(newValue)
        }
    }
    
    init(side: Animal.Side) {
        super.init(fontNamed: Constants.LABEL_FONT)
        self.side = side
        self.fontSize = Constants.FONT_SIZE;
        self.position = CGPoint(x: Constants.POS_X[side.index], y: Constants.POS_Y);
    }
    
    override init(fontNamed fontName: String!) {
        super.init(fontNamed: fontName)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
