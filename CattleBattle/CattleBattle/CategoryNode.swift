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
        internal static let IDENTIFIER = "categoryNode"
        internal static let CATEGORY_KEYWORD = "category"
        private static let IMAGE_EXT = ".png"
        private static let SCALE_X: CGFloat = 0.6
        private static let SCALE_Y: CGFloat = 0.5
        private static let BODY_OFFSET: CGFloat = 15
        private static let ITEM_GAP: CGFloat = 5
 
        private static let MAX_POWERUP: Int = 4
        
        private static let ADD_DURATION: Double = 0.5
        private static let REMOVE_DURATION: Double = 0.2
        
        private static var _textures = Animal.Side.allSides.map { (side) -> SKTexture in
            return SKTexture(imageNamed: CategoryNode._getImageFileName(side))
        }
    }
    
    internal class func getTexture(side: Animal.Side) -> SKTexture {
        return Constants._textures[find(Animal.Side.allSides, side)!]
    }
    
    private class func _getImageFileName(side: Animal.Side) -> String {
        var fileName = join("-", [Constants.CATEGORY_KEYWORD, side.rawValue])
        return fileName + Constants.IMAGE_EXT
    }

    internal var side: Animal.Side!
    internal var items = [PowerUpNode]()
    
    init(side: Animal.Side) {
        var texture = CategoryNode.getTexture(side)
        var size = texture.size()
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSizeMake(size.width * Constants.SCALE_X, size.height * Constants.SCALE_Y))
        
        self.name = Constants.IDENTIFIER
        self.side = side
        
        var bodySize = CGSizeMake(self.size.width - Constants.BODY_OFFSET, self.size.height - Constants.BODY_OFFSET)
        physicsBody = SKPhysicsBody(rectangleOfSize: bodySize)
        
        physicsBody!.categoryBitMask = GameScene.Constants.Category
        physicsBody!.contactTestBitMask = GameScene.Constants.Item
        physicsBody!.collisionBitMask = GameScene.Constants.All
        physicsBody!.dynamic = false
        
        physicsBody!.restitution = 1
    }
    
    internal func _getPosition(item: PowerUpNode, index: Int) -> CGPoint {
        var offset = (Constants.ITEM_GAP + item.size.width) * CGFloat(index) + item.size.width / 2
        var x = self.side == .LEFT ? offset : self.parent!.frame.width - offset
        var y = self.size.height / 2
        return CGPointMake(x, y)
    }
    
    private func _moveItem(item: PowerUpNode, index: Int) {
        var moveAction = (SKAction.moveTo(_getPosition(item, index: index), duration: Constants.ADD_DURATION))
        item.runAction(moveAction, completion: { () -> Void in
            item.position = item.parent!.convertPoint(item.position, toNode: self)
            item.removeFromParent()
            self.addChild(item)
        })
    }
    
    internal func add(item: PowerUpNode) {
        if items.count >= Constants.MAX_POWERUP {
            return
        }
        
        item.side = self.side
        item.name = PowerUpNode.Constants.IDENTIFIER_STORED
        
        item.physicsBody = nil
        
        items.append(item)
        
        _moveItem(item, index: items.count - 1)
    }

    internal func remove(removedItem: PowerUpNode) {
        let index = removedItem.side.index
        
        GameModel.Constants.gameModel.categorySelectedItem[index] = nil
        items.removeAtIndex(find(items, removedItem)!)
        removedItem.removeFromParent()
        
        for (index, item) in enumerate(items) {
            item.removeFromParent()
            item.position = self.parent!.convertPoint(item.position, fromNode: self)
            self.parent!.addChild(item)
            _moveItem(item, index: index)
        }
    }

    override init(texture: SKTexture, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}