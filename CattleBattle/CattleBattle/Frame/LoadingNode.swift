//
//  LoadingNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class LoadingNode: SKSpriteNode {
    struct Constants {
        fileprivate static let SCALE: CGFloat = 0.35
        internal static var IDENTIFIER = "loadingButton"
    }
    
    internal var index = 0
    internal var animal: Animal = Animal(side: .LEFT, size: .TINY, status: .BUTTON) {
        didSet {
            self.texture = animal.getTexture()
            self.resize()
        }
    }
    
    init(side: Animal.Side, index: Int) {
        super.init(texture: animal.getTexture(), color: UIColor.clear, size: animal.getTexture().size())
        self.index = index
        self.name = Constants.IDENTIFIER
        self.animal.side = side
        change()
    }
    
    internal func resize() {
        self.xScale = 1
        self.yScale = 1
        self.size = self.texture!.size()
        self.xScale = Constants.SCALE
        self.yScale = Constants.SCALE
    }
    
    internal func change() {
        self.animal.size = Animal.Size.generateRandomAnimal()
        self.texture = animal.getTexture()
        self.resize()
    }
    
    internal func fadeAnimation(_ side: Animal.Side, index: Int) {
        self.alpha = 0
        let action1 = SKAction.fadeAlpha(to: 0.5, duration: 3) //fadeInWithDuration(3)
        let action2 = SKAction.scale(by: 1.2, duration: 0.3)
        let action3 = action2.reversed()
        let action4 = SKAction.fadeIn(withDuration: 0)
        let actionList = SKAction.sequence([action1, action2 ,action3, action4])
        self.run(actionList, completion: { () -> Void in
            GameModel.Constants.gameModel.setCattleStatus(side, index: index, status: true)
        })
    }

    override init(texture:SKTexture?, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
