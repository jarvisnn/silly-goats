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
        fileprivate static let IMAGE_EXT = ".png"
        fileprivate static let SCALE_X: CGFloat = 0.6
        fileprivate static let SCALE_Y: CGFloat = 0.5
        fileprivate static let BODY_OFFSET: CGFloat = 15
        fileprivate static let ITEM_GAP: CGFloat = 5
 
        fileprivate static let MAX_POWERUP: Int = 4
        
        fileprivate static let ADD_DURATION: Double = 0.5
        fileprivate static let REMOVE_DURATION: Double = 0.2
        
        fileprivate static var _textures = Animal.Side.allSides.map { (side) -> SKTexture in
            return SKTexture(imageNamed: CategoryNode._getImageFileName(side))
        }
    }
    
    internal class func getTexture(_ side: Animal.Side) -> SKTexture {
        return Constants._textures[Animal.Side.allSides.index(of: side)!]
    }
    
    fileprivate class func _getImageFileName(_ side: Animal.Side) -> String {
        var fileName = [Constants.CATEGORY_KEYWORD, side.rawValue].joined(separator: "-")
        return fileName + Constants.IMAGE_EXT
    }

    internal var side: Animal.Side!
    internal var items = [PowerUpNode]()
    
    init(side: Animal.Side) {
        let texture = CategoryNode.getTexture(side)
        let size = texture.size()
        super.init(texture: texture, color: SKColor.clear, size: CGSize(width: size.width * Constants.SCALE_X, height: size.height * Constants.SCALE_Y))
        
        self.name = Constants.IDENTIFIER
        self.side = side
        
        let bodySize = CGSize(width: self.size.width - Constants.BODY_OFFSET, height: self.size.height - Constants.BODY_OFFSET)
        physicsBody = SKPhysicsBody(rectangleOf: bodySize)
        
        physicsBody!.categoryBitMask = GameScene.Constants.Category
        physicsBody!.contactTestBitMask = GameScene.Constants.Item
        physicsBody!.collisionBitMask = GameScene.Constants.All
        physicsBody!.isDynamic = false
        
        physicsBody!.restitution = 1
    }
    
    internal func _getPosition(_ item: PowerUpNode, index: Int) -> CGPoint {
        let offset = (Constants.ITEM_GAP + item.size.width) * CGFloat(index) + item.size.width / 2
        let x = self.side == .LEFT ? offset : self.parent!.frame.width - offset
        let y = self.size.height / 2
        return CGPoint(x: x, y: y)
    }
    
    fileprivate func _moveItem(_ item: PowerUpNode, index: Int) {
        let moveAction = (SKAction.move(to: _getPosition(item, index: index), duration: Constants.ADD_DURATION))
        item.run(moveAction, completion: { () -> Void in
            item.position = item.parent!.convert(item.position, to: self)
            item.removeFromParent()
            self.addChild(item)
        })
    }
    
    internal func add(_ item: PowerUpNode) {
        if items.count >= Constants.MAX_POWERUP {
            return
        }
        
        item.side = self.side
        item.name = PowerUpNode.Constants.IDENTIFIER_STORED
        
        item.physicsBody = nil
        
        items.append(item)
        
        _moveItem(item, index: items.count - 1)
    }

    internal func remove(_ removedItem: PowerUpNode) {
        let index = removedItem.side.index
        
        GameModel.Constants.gameModel.categorySelectedItem[index] = nil
        items.remove(at: items.index(of: removedItem)!)
        removedItem.removeFromParent()
        
        for (index, item) in items.enumerated() {
            item.removeFromParent()
            item.position = self.parent!.convert(item.position, from: self)
            self.parent!.addChild(item)
            _moveItem(item, index: index)
        }
    }

    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
