//
//  LaunchButtonNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 4/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class ArrowNode: SKSpriteNode {
    
    internal var side: GameModel.Side = .LEFT
    
    internal var originTex: SKTexture = SKTexture()
    internal var index: Int = 0
    
    struct Constants {
        private static let IMAGE_EXT = ".png"
        private static let ARROW_IDENTIFIER = "arrow"
        private static let SPRITE_SHEET_LENGTH = 5
        
        internal static var arrowTextures = GameModel.Side.allSides.map() { (side) -> [SKTexture] in
            var spriteSheet = SKTexture(imageNamed: Constants.ARROW_IDENTIFIER + "-" + side.rawValue + Constants.IMAGE_EXT)
            
            var x = 1.0 / CGFloat(SPRITE_SHEET_LENGTH)
            var result = [SKTexture]()
            
            for i in 0..<SPRITE_SHEET_LENGTH {
                var rect = CGRectMake(CGFloat(i) * x, 0, x, 1)
                result.append(SKTexture(rect: rect, inTexture: spriteSheet))
            }
            return result
        }
    }
    
    class func getTextures(side: GameModel.Side) -> [SKTexture] {
        return Constants.arrowTextures[find(GameModel.Side.allSides, side)!]
    }
    
    override init(texture:SKTexture, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    init(side: GameModel.Side, index: Int) {
        super.init()
        var repeatedAction = SKAction.animateWithTextures(ArrowNode.getTextures(side), timePerFrame: 0.2)
        self.runAction(SKAction.repeatActionForever(repeatedAction))

        self.size = CGSize(width: 120, height: 64)
        self.side = side
        self.index = index
        
        self.name = Constants.ARROW_IDENTIFIER
        self.alpha = 0.8
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}