//
//  CategoryNode.swift
//  CattleBattle
//
//  Created by Jarvis on 4/13/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class CategoryNode: SKSpriteNode {
    struct Constants {
        internal static var IDENTIFIER = "categoryNode"
        internal static var CATEGORY_KEYWORD = "category"
        internal static var IMAGE_EXT = ".png"
        internal static let SCALE_X: CGFloat = 0.6
        internal static let SCALE_Y: CGFloat = 0.5
        internal static let BODY_OFFSET: CGFloat = 15
        
        internal static var textures = Animal.Side.allSides.map { (side) -> SKTexture in
            return SKTexture(imageNamed: CategoryNode._getImageFileName(side))
        }
    }
    
    internal class func getTexture(side: Animal.Side) -> SKTexture {
        return Constants.textures[find(Animal.Side.allSides, side)!]
    }
    
    private class func _getImageFileName(side: Animal.Side) -> String {
        var fileName = join("-", [Constants.CATEGORY_KEYWORD, side.rawValue])
        return fileName + Constants.IMAGE_EXT
    }

    internal var side: Animal.Side!
    
    init(side: Animal.Side) {
        var texture = CategoryNode.getTexture(side)
        var size = texture.size()
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        
        self.name = Constants.IDENTIFIER
        self.side = side
        self.xScale = Constants.SCALE_X
        self.yScale = Constants.SCALE_Y
        
        var bodySize = CGSizeMake(self.size.width - Constants.BODY_OFFSET, self.size.height - Constants.BODY_OFFSET)
        physicsBody = SKPhysicsBody(rectangleOfSize: bodySize)
        
        physicsBody!.categoryBitMask = GameScene.Constants.Category
        physicsBody!.contactTestBitMask = GameScene.Constants.Item
        physicsBody!.collisionBitMask = GameScene.Constants.All
        physicsBody!.dynamic = false
        
        physicsBody!.restitution = 1
    }

    override init(texture: SKTexture, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}