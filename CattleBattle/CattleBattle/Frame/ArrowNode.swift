//
//  LaunchMenuButtonNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 4/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class ArrowNode: SKSpriteNode {
    
    internal var side: Animal.Side = .LEFT
    
    internal var originTex: SKTexture = SKTexture()
    internal var index: Int = 0
    
    struct Constants {
        fileprivate static let IMAGE_EXT = ".png"
        
        fileprivate static let SPRITE_SHEET_LENGTH = 5
        
        fileprivate static let ARROW_WIDTH: CGFloat = 120.0
        fileprivate static let ARROW_HEIGHT: CGFloat = 64.0
        fileprivate static let ANIMATION_TIME = 0.2
        fileprivate static let ALPHA: CGFloat = 0.4
        
        internal static let IDENTIFIER = "arrow"

        fileprivate static var _textures = Animal.Side.allSides.map() { (side) -> [SKTexture] in
            var spriteSheet = SKTexture(imageNamed: Constants.IDENTIFIER + "-" + side.rawValue + Constants.IMAGE_EXT)
            
            var x = 1.0 / CGFloat(SPRITE_SHEET_LENGTH)
            var result = [SKTexture]()
            
            for i in 0..<SPRITE_SHEET_LENGTH {
                var rect = CGRect(x: CGFloat(i) * x, y: 0, width: x, height: 1)
                result.append(SKTexture(rect: rect, in: spriteSheet))
            }
            return result
        }
    }
    
    internal class func getTextures(_ side: Animal.Side) -> [SKTexture] {
        return Constants._textures[side.index]
    }
    
    init(side: Animal.Side, index: Int) {
        let _texture = ArrowNode.getTextures(side).first
        let _size = CGSize(width: Constants.ARROW_WIDTH, height: Constants.ARROW_HEIGHT)
        super.init(texture: _texture, color: UIColor.clear, size: _size)
        self.name = Constants.IDENTIFIER
        self.alpha = Constants.ALPHA

        self.side = side
        self.index = index
        
        let repeatedAction = SKAction.animate(with: ArrowNode.getTextures(side), timePerFrame: Constants.ANIMATION_TIME)
        self.run(SKAction.repeatForever(repeatedAction))
    }

    override init(texture:SKTexture?, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
