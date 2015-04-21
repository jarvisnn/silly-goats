//
//  BorderNode.swift
//  CattleBattle
//
//  Created by Jarvis on 4/22/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class BorderNode: SKSpriteNode {
    struct Constants {
        private static let SCALE: CGFloat = 0.4
        private static let SPEED: Double = 2.5
        internal static var IDENTIFIER = "item-border"
    }
    
    internal var index = 0

    init() {
        var _texture = SKTexture(imageNamed: "item-border.png")
        super.init(texture: _texture, color: UIColor.clearColor(), size: _texture.size() * Constants.SCALE)
        self.name = Constants.IDENTIFIER
        
        self.alpha = 0
        rotateForever(CGFloat(-M_PI), speed: Constants.SPEED)
    }
    
    internal func rotateForever(angle: CGFloat, speed: Double) {
        var action = SKAction.rotateByAngle(angle, duration: speed)
        self.runAction(SKAction.repeatActionForever(action))
    }
    
    internal func fadeIn() {
        self.alpha = 1
    }
    
    internal func fadeOut() {
        self.alpha = 0
    }
    
    override init(texture:SKTexture, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}