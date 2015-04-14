//
//  AnimationNode.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/14/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class AnimationNode: SKSpriteNode {
    struct Constants {
        internal static var IDENTIFIER = "animationNode"
        internal static var ROTATION_SPEED: Double = 1
    }
    
    internal var side: GameModel.Side = .LEFT
    
    init(imageName: String, scale: CGFloat) {
        var _texture = SKTexture(imageNamed: imageName+".png")
        var _size = _texture.size()
        super.init(texture: _texture, color: UIColor.clearColor(), size: _size)
        
        self.name = Constants.IDENTIFIER
        self.xScale = scale
        self.yScale = scale
    }
    
    internal func makeRotation() {
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: Constants.ROTATION_SPEED)
        self.runAction(SKAction.repeatActionForever(action))
    }
    
    override init(texture:SKTexture, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}