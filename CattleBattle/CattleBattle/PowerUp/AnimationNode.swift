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
        private static let IDENTIFIER = "animationNode"
        private static let IMAGE_EXT = ".png"
        private static let ROTATION_SPEED: Double = 1
        internal static let BLACKHOLE_IMAGE = "animation-blackHole"
    }
    
    internal var side: Animal.Side = .LEFT
    
    init(imageName: String, scale: CGFloat, parentScale: CGFloat) {
        var _texture = SKTexture(imageNamed: imageName + Constants.IMAGE_EXT)
        var _size = _texture.size()
        super.init(texture: _texture, color: UIColor.clearColor(), size: _size * parentScale)
        
        self.name = Constants.IDENTIFIER
        self.texture = _texture
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