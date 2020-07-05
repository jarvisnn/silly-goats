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
        internal static let DRAGGING_KEYWORD = "dragging-"
        internal static let IMAGE_EXT = ".png"
        internal static let IMAGE_SCALE: CGFloat = 0.3
        
        internal static let Z_INDEX_FRONT: CGFloat = 1000000
    }
    
    fileprivate class func _applyBlackHole(_ scene: SKScene, node: AnimalNode) {
        let blackHole = AnimationNode(imageName: "animation-blackHole", scale: 0.1, parentScale: node.animal.getImageScale())
        blackHole.rotateForever(CGFloat(-M_PI), speed: 0.2)
        blackHole.zPosition = -1
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position.y += node.size.height/2
        
        blackHole.position = CGPoint.zero
        node.addChild(blackHole)
        
        blackHole.run(SKAction.scale(to: 1, duration: 0.6), completion: { () -> Void in
            node.run(SKAction.scale(to: 0, duration: 0.3), completion: { () -> Void in
                node.removeFromParent()
            })
        })
        GameSound.Constants.instance.play(.BLACKHOLE)
    }
    
    fileprivate class func _applyFreezing(_ scene: SKScene, nodes: [AnimalNode]) {
        let fallingIce = SKEmitterNode.getEmitterFromFile("freeze")
        let fog = SKEmitterNode.getEmitterFromFile("ice-fog")
        
        fallingIce.position = CGPoint(x: scene.frame.width/2, y: scene.frame.height)
        fallingIce.particleLifetime = (scene.frame.height - nodes[0].position.y) / fallingIce.particleSpeed
        fallingIce.zPosition = Constants.Z_INDEX_FRONT
        
        fog.position = CGPoint(x: scene.frame.width/2, y: nodes[0].position.y)
        fog.zPosition = Constants.Z_INDEX_FRONT + 1
        
        scene.addChild(fallingIce)
        scene.addChild(fog)
        
        for node in nodes {
            let freezing = AnimationNode(imageName: "animation-freezing2.png", scale: 0.4, parentScale: node.animal.getImageScale())
            freezing.alpha = 0
            freezing.anchorPoint = CGPoint(x: 0.5, y: 0.2)
            freezing.position = CGPoint.zero
            freezing.zPosition = 1
            
            node.addChild(freezing)
            
            let action1 = SKAction.run({
                node.physicsBody!.isDynamic = false
                freezing.run(SKAction.fadeIn(withDuration: 0.5), completion: {
                    node.isPaused = true
                })
            })
            let action2 = SKAction.wait(forDuration: 5)
            let action3 = SKAction.run({
                node.isPaused = false
                freezing.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                    node.physicsBody!.isDynamic = true
                    freezing.removeFromParent()
                })
            })
            
            scene.run(SKAction.sequence([action1, action2, action3]))
        }
        GameSound.Constants.instance.play(.FREEZE)
    }
    
    fileprivate class func _applyUpgrading(_ scene: SKScene, node: AnimalNode) {
        let upgradeSmoke = SKEmitterNode.getEmitterFromFile("upgrade")
        upgradeSmoke.zPosition = 1
        
        upgradeSmoke.particlePositionRange = CGVector(dx: node.size.width*2, dy: node.size.height*2)
        upgradeSmoke.position = CGPoint(x: 0, y: node.size.height)
        node.addChild(upgradeSmoke)
        
        let nextSize = Animal.Size.allSizes.index(of: node.animal.size)! + 1
        if nextSize < Animal.Size.allSizes.count {
            node.updateAnimalType(Animal.Size.allSizes[nextSize])
        }
        GameSound.Constants.instance.play(.UPGRADE)
    }
    
    fileprivate class func _applyFiring(_ scene: SKScene, node: AnimalNode) {
        let fire = SKEmitterNode.getEmitterFromFile("fire")
        fire.zPosition = -1
        fire.position = node.position
        fire.position.y += node.size.height * 5 / 9
        
        node.physicsBody = nil
        
        node.zPosition = Constants.Z_INDEX_FRONT
        node.xScale = -1
        
        let destination = node.animal.side == .LEFT ? GameScene.Constants.GAME_VIEW_LEFT_BOUNDARY : GameScene.Constants.GAME_VIEW_RIGHT_BOUNDARY
        
        let action = SKAction.moveTo(x: destination, duration: Double(abs(destination - node.position.x)) / Double(AnimalNode.Constants.VELOCITY*1.5))
        
        fire.targetNode = scene
        fire.run(action)
        node.run(action)
        
        scene.addChild(fire)
    }
    
    internal class func applyPowerUp(_ powerUpItem: PowerUpNode?, targets: [AnimalNode], scene: GameScene, removeItemFunc: ((PowerUpNode) -> ())) {
        let animal = targets[0]
        if let item = powerUpItem {
            if item.powerUpItem.powerType == .BLACK_HOLE {
                Animation._applyBlackHole(scene, node: animal)
                
            } else if item.powerUpItem.powerType == .FREEZE {
                Animation._applyFreezing(scene, nodes: targets)
                
            } else if item.powerUpItem.powerType == .FIRE {
                Animation._applyFiring(scene, node: animal)
                
            } else if item.powerUpItem.powerType == .UPGRADE {
                Animation._applyUpgrading(scene, node: animal)
            }
            removeItemFunc(item)
        }
    }
    
    internal class func draggingPowerUp(_ powerType: PowerUp.PowerType, scene: SKScene, position: CGPoint) -> SKEmitterNode {
        let fileName = Constants.DRAGGING_KEYWORD + powerType.rawValue
        let effect = SKEmitterNode.getEmitterFromFile(fileName)
        effect.zPosition = -1
        effect.position = position
        effect.targetNode = scene
        scene.addChild(effect)
        return effect
    }
}
