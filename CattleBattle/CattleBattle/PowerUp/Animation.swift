//
//  Animation.swift
//  CattleBattle
//
//  Created by kunn on 4/15/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Animation {
    
    struct Constants {
        internal static let POWERUP_KEYWORD = "item"
        internal static let IMAGE_EXT = ".png"
        internal static let IMAGE_SCALE: CGFloat = 0.3
        
        internal static let Z_INDEX_FRONT: CGFloat = 1000000
    }
    
    internal class func applyBlackHole(scene: SKScene, node: AnimalNode) {
        let freezingResource = NSBundle.mainBundle().pathForResource("freezing", ofType: "sks")
        let freezing : SKEmitterNode! = NSKeyedUnarchiver.unarchiveObjectWithFile(freezingResource!) as! SKEmitterNode
        
        let fogResource = NSBundle.mainBundle().pathForResource("ice-fog", ofType: "sks")
        let fog : SKEmitterNode! = NSKeyedUnarchiver.unarchiveObjectWithFile(fogResource!) as! SKEmitterNode
        
        freezing.position = CGPointMake(scene.frame.width/2, scene.frame.height)
        freezing.particleLifetime = (scene.frame.height - node.position.y) / freezing.particleSpeed
        
        fog.position = CGPointMake(scene.frame.width/2, node.position.y)
        
        scene.addChild(freezing)
        scene.addChild(fog)
        
    }
    
    internal class func applyFreezing(scene: SKScene, node: AnimalNode) {
        let freezingResource = NSBundle.mainBundle().pathForResource("freezing", ofType: "sks")
        let freezing : SKEmitterNode! = NSKeyedUnarchiver.unarchiveObjectWithFile(freezingResource!) as! SKEmitterNode
        
        let fogResource = NSBundle.mainBundle().pathForResource("ice-fog", ofType: "sks")
        let fog : SKEmitterNode! = NSKeyedUnarchiver.unarchiveObjectWithFile(fogResource!) as! SKEmitterNode
        
        freezing.position = CGPointMake(scene.frame.width/2, scene.frame.height)
        freezing.particleLifetime = (scene.frame.height - node.position.y) / freezing.particleSpeed
        freezing.zPosition = Constants.Z_INDEX_FRONT
        
        fog.position = CGPointMake(scene.frame.width/2, node.position.y)
        fog.zPosition = Constants.Z_INDEX_FRONT + 1
        
        scene.addChild(freezing)
        scene.addChild(fog)
    }
    
    
}
