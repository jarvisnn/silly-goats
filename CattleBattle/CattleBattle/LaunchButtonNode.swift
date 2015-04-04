//
//  LaunchButtonNode.swift
//  CattleBattle
//
//  Created by Ding Ming on 4/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class LaunchButtonNode : SKSpriteNode {

    var originTex : SKTexture = SKTexture()
    var currentX : CGFloat = 0
    var side : GameModel.side = .left
    var index : Int = 0
    
    class func launchButton (side : GameModel.side, index : Int) -> LaunchButtonNode {
        let node = LaunchButtonNode()
        var Tex = SKTexture(imageNamed: "arrow-right.png")
        if side == .right {
            Tex = SKTexture(imageNamed: "arrow-left.png")
        }
        
        node.initStatus(Tex, side: side, index: index)
        node.size = CGSize(width: 120,height: 64)
        
        var rect = CGRectMake(node.currentX ,0, 0.2, 1)
    
        node.texture = SKTexture(rect: rect, inTexture : Tex)
        node.name = "arrow"
        node.alpha = 0.8

        return node
    }
    
    
    func initStatus(tex : SKTexture, side : GameModel.side, index : Int) {
        originTex = tex
        if self.side == .left {
            currentX = originTex.size().width * 0.8
        } else {
            currentX = 0
        }
        self.side = side
        self.index = index
    }
    
    func animateArrow() {
        if self.side == .left {
            if currentX > 0 {
                currentX -= 10
            } else {
                currentX = originTex.size().width * 0.8
            }
            var rect = CGRectMake(currentX / originTex.size().width, 0, 0.2, 1)
            self.texture = SKTexture(rect: rect, inTexture: originTex)
        } else if self.side == .right {
            if currentX < originTex.size().width * 0.8 {
                currentX += 10
            } else {
                currentX = 0
            }
            var rect = CGRectMake(currentX / originTex.size().width, 0, 0.2, 1)
            self.texture = SKTexture(rect: rect, inTexture: originTex)
        }
    }
}