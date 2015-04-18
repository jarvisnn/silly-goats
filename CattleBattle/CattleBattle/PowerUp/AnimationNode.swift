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
        internal static let IDENTIFIER = "animationNode"
        internal static let ROTATION_SPEED: Double = 1
        internal static let BLACKHOLE_IMAGE = "animation-blackHole"
    }
    
    internal var side: Animal.Side = .LEFT
    
    init(imageName: String, scale: CGFloat) {
        var _texture = SKTexture(imageNamed: imageName+".png")
        var _size = _texture.size()
        super.init(texture: _texture, color: UIColor.clearColor(), size: _size)
        
        self.name = Constants.IDENTIFIER
        self.texture = _texture
        self.size = _size
        self.xScale = scale
        self.yScale = scale
    }
    
    internal func rotateForever(angle: CGFloat, speed: Double) {
        var action = SKAction.rotateByAngle(angle, duration: speed)
        self.runAction(SKAction.repeatActionForever(action))
    }
    
    override init(texture:SKTexture, color:SKColor, size:CGSize) {
        super.init(texture:texture, color:color, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}