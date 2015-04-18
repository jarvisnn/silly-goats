//
//  Animation.swift
//  CattleBattle
//
//  Created by jarvis on 4/15/15.
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
    
    private class func _applyBlackHole(scene: SKScene, node: AnimalNode) {
        var blackHole = AnimationNode(imageName: "animation-blackHole", scale: 0.1)
        blackHole.rotateForever(CGFloat(-M_PI), speed: 0.2)
        blackHole.zPosition = -1
        
        node.anchorPoint = CGPointMake(0.5, 0.5)
        node.position.y += node.size.height/2
        
        blackHole.position = CGPoint.zeroPoint
        node.addChild(blackHole)
        
        blackHole.runAction(SKAction.scaleTo(1, duration: 0.6), completion: { () -> Void in
            node.runAction(SKAction.scaleTo(0, duration: 0.3), completion: { () -> Void in
                node.removeFromParent()
            })
        })
    }
    
    private class func _applyFreezing(scene: SKScene, node: AnimalNode) {
        let freezing = getEmitterFromFile("freeze")
        let fog = getEmitterFromFile("ice-fog")
        
        freezing.position = CGPointMake(scene.frame.width/2, scene.frame.height)
        freezing.particleLifetime = (scene.frame.height - node.position.y) / freezing.particleSpeed
        freezing.zPosition = Constants.Z_INDEX_FRONT
        
        fog.position = CGPointMake(scene.frame.width/2, node.position.y)
        fog.zPosition = Constants.Z_INDEX_FRONT + 1
        
        scene.addChild(freezing)
        scene.addChild(fog)
    }
    
    private class func _applyUpgrading(scene: SKScene, node: AnimalNode) {
        let upgradeSmoke = getEmitterFromFile("upgrade")
        upgradeSmoke.zPosition = 1
        
        upgradeSmoke.particlePositionRange = CGVectorMake(node.size.width*2, node.size.height*2)
        upgradeSmoke.position = CGPointMake(0, node.size.height)
        node.addChild(upgradeSmoke)
        
        let nextSize = find(Animal.Size.allSizes, node.animal.size)! + 1
        if nextSize < Animal.Size.allSizes.count {
            node.updateAnimalType(Animal.Size.allSizes[nextSize])
        }
    }
    
    private class func _applyFiring(scene: SKScene, node: AnimalNode) {
        let fire = getEmitterFromFile("fire")
        fire.zPosition = -1
        fire.position = node.position
        fire.position.y += node.size.height*2/3
        
        node.physicsBody!.dynamic = false
        node.physicsBody!.collisionBitMask = GameScene.Constants.None
        node.physicsBody!.categoryBitMask = GameScene.Constants.None
        
        node.zPosition = Constants.Z_INDEX_FRONT
        node.xScale = -node.xScale
        
        var destination = node.animal.side == .LEFT ? GameScene.Constants.GAME_VIEW_LEFT_BOUNDARY : GameScene.Constants.GAME_VIEW_RIGHT_BOUNDARY
        
        var action = SKAction.moveToX(destination, duration: Double(abs(destination - node.position.x)) / Double(AnimalNode.Constants.VELOCITY*1.5))
        
        fire.targetNode = scene
        fire.runAction(action)
        node.runAction(action)
        
        scene.addChild(fire)
    }
    
    internal class func applyPowerUp(powerUpItem: PowerUpNode?, target: AnimalNode?, scene: GameScene, removeItemFunc: ((PowerUpNode) -> ())) {
        if var item = powerUpItem {
            if var animal = target {
                var isValid = (item.side == animal.animal.side) == PowerUp.PowerType.targetFriendly(item.powerUpItem.powerType)
                if !isValid {
                    return
                }

                if item.powerUpItem.powerType == .BLACK_HOLE {
                    Animation._applyBlackHole(scene, node: animal)
                    
                } else if item.powerUpItem.powerType == .FREEZE {
                    Animation._applyFreezing(scene, node: animal)
                    
                } else if item.powerUpItem.powerType == .FIRE {
                    Animation._applyFiring(scene, node: animal)
                    
                } else if item.powerUpItem.powerType == .UPGRADE {
                    Animation._applyUpgrading(scene, node: animal)
                }
                removeItemFunc(item)
            }
        }
    }
    
    private class func getEmitterFromFile(filename: String) -> SKEmitterNode {
        let resource = NSBundle.mainBundle().pathForResource(filename, ofType: "sks")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(resource!) as! SKEmitterNode
    }
}
