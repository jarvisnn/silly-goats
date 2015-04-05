//
//  LaunchButtonNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 4/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class ArrowNode : SKSpriteNode {
    
    internal var side: GameModel.Side = .LEFT
    internal var originTex: SKTexture = SKTexture()
    internal var currentX: CGFloat = 0
    internal var index: Int = 0
    
    struct Constants {
        private static let IMAGE_EXT = ".png"
        private static let ARROW_IDENTIFIER = "arrow"
    }
    
    
    class func launchButton (side: GameModel.Side, index: Int) -> ArrowNode {

        let node = ArrowNode()
        var Tex = SKTexture(imageNamed: Constants.ARROW_IDENTIFIER + "-" + side.rawValue + Constants.IMAGE_EXT)
        
        node.initStatus(Tex, side: side, index: index)
        node.size = CGSize(width: 120,height: 64)
        
        var rect = CGRectMake(node.currentX, 0, 0.2, 1)
    
        node.texture = SKTexture(rect: rect, inTexture : Tex)
        node.name = Constants.ARROW_IDENTIFIER
        node.alpha = 0.8

        return node
    }
    
    
    func initStatus(tex : SKTexture, side : GameModel.Side, index : Int) {
        originTex = tex
        currentX = 0
        self.side = side
        self.index = index
    }
    
    func animateArrow() {
        if currentX < originTex.size().width * 0.8 {
            currentX += originTex.size().width*0.2
        } else {
            currentX = 0
        }
        var rect = CGRectMake(currentX / originTex.size().width, 0, 0.2, 1)
        self.texture = SKTexture(rect: rect, inTexture: originTex)
    
    }
}