//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct Constants {
        private static var LAUNCH_X: [CGFloat]!
        private static let LAUNCH_Y_TOP: CGFloat = 560
        private static let LAUNCH_Y_GAP: CGFloat = 100
        private static let LABEL_FONT = "Chalkduster"
        private static let INFINITE = 1000000000
    }
    
    private let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 2048
    private let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -1024
    
    var playerScoreNode: [SKLabelNode] = GameModel.Side.allSides.map({ (side) -> SKLabelNode in
        SKLabelNode()
    })
    var loadingButton: [[LoadingNode]] = []
    
    
    private func _setupLoadingButton() {
        loadingButton = GameModel.Side.allSides.map { (side) -> [LoadingNode] in
            return map(0..<GameModel.Constants.NUMBER_OF_RESERVED, { (index) -> LoadingNode in
                var location: CGPoint
                var node = LoadingNode(side: side, index: index)
                if side == .LEFT {
                    location = CGPoint(x: 50 + index * 80, y : 725)
                } else {
                    location = CGPoint(x: (Int)(self.frame.width) - 50 - index * 80, y : 725)
                }
                node.position = location
                self.addChild(node)
                return node
            })
        }
    }
    
    private func _setupLabel() {
        let vsLabel = SKLabelNode(fontNamed: Constants.LABEL_FONT)
        vsLabel.text = "VS";
        vsLabel.fontSize = 40;
        vsLabel.position = CGPoint(x: 512, y : 650);
        
        self.addChild(vsLabel)
        
        for side in GameModel.Side.allSides {
            playerScoreNode[side.index] = SKLabelNode(fontNamed: Constants.LABEL_FONT)
            playerScoreNode[side.index].text = "000"; //should be changed
            playerScoreNode[side.index].fontSize = 40;
            if side == .LEFT {
                playerScoreNode[side.index].position = CGPoint(x: 420, y : 710);
            } else {
                playerScoreNode[side.index].position = CGPoint(x: 604, y : 710);
            }
            self.addChild(playerScoreNode[side.index])
        }
    }
    
    private func _setupArrow() {
        for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
            var y = CGFloat(Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(i))
            for side in GameModel.Side.allSides {
                var tmpNode = ArrowNode(side: side, index: i)
                if side == .LEFT {
                    tmpNode.position = CGPointMake(50, y)
                } else {
                    tmpNode.position = CGPointMake(self.frame.width - 50, y)
                }
                tmpNode.zPosition = CGFloat(Constants.INFINITE)
                self.addChild(tmpNode)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        Constants.LAUNCH_X = [self.frame.minX, self.frame.maxX]
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)

        _setupLoadingButton()
        _setupLabel()
        _setupArrow()
    }
    
    func goatDidCollisionWithAnother(goats: [AnimalNode]) {
        for goat in goats {
            println(goat.physicsBody!.velocity.dx)
            if goat.animal.status == .DEPLOYED {
                goat.updateAnimalStatus(.BUMPING)
                var repeatedAction = SKAction.animateWithTextures(goat.animal.getBumpingTexture(), timePerFrame: 0.2)
                goat.runAction(SKAction.repeatActionForever(repeatedAction))
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody = contact.bodyA
        var secondBody: SKPhysicsBody = contact.bodyB
        
        //check if both are goats
        if ((firstBody.categoryBitMask & AnimalNode.PhysicsCategory.Goat) != 0 && (secondBody.categoryBitMask & AnimalNode.PhysicsCategory.Goat) != 0) {
           goatDidCollisionWithAnother([firstBody.node as AnimalNode, secondBody.node as AnimalNode])
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            var node = self.nodeAtPoint(touch.locationInNode(self))
           
            if node.name != nil && node.name! == LoadingNode.Constants.IDENTIFIER {
                self._selectButton(node as LoadingNode)
            }
            
            if node.name != nil && node.name! == ArrowNode.Constants.IDENTIFIER {
                var arrow = node as ArrowNode
                var currentSelected = GameModel.Constants.selected[arrow.side.index]
                if GameModel.isCattleReady(arrow.side, index: currentSelected) {
                    _deploy(arrow.side, selectedButton: currentSelected, selectedRow: arrow.index)
                }
            }
        }
    }
    
   
   
    override func update(currentTime: CFTimeInterval) {
        for i in self.children {
            var node = i as SKNode
            
            if node.name != nil && node.name == "leftRunning" {
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    node.removeFromParent()
                }
            }
            if node.name != nil && node.name == "rightRunning" {
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY  || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    node.removeFromParent()
                }
            }
        }
    }
    
    private var zCount = CGFloat(0)
    private func _deploy(side: GameModel.Side, selectedButton: Int, selectedRow: Int) {
        GameModel.setCattleStatus(side, index: selectedButton, status: false)
        var currentSize = loadingButton[side.index][selectedButton].animal.size
        var y = Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(selectedRow)

        var sprite = AnimalNode(size: currentSize, side: side)
        sprite.position.x = Constants.LAUNCH_X[side.index]
        sprite.position.y = y + sprite.size.height / 2.0
        sprite.zPosition = ++zCount
        self.addChild(sprite)
        
        var button = loadingButton[side.index][selectedButton]
        button.change()
        button.fadeAnimation(side, index: selectedButton)
    }
    
    
    private func _selectButton(node: LoadingNode) {
        var side: GameModel.Side = (node.animal.color == .WHITE) ? .LEFT : .RIGHT
        GameModel.selectForSide(side, index: node.index)
    }
    
}
