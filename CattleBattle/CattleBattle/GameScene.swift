//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum GameMode: String {
        case TIMING = "timing"
        case SCORING = "scoring"
    }
    
    struct Constants {
        private static var LAUNCH_X: [CGFloat]!
        private static let LAUNCH_Y_TOP: CGFloat = 560
        private static let LAUNCH_Y_GAP: CGFloat = 100
        private static let LABEL_FONT = "Chalkduster"
        private static let INFINITE = 1000000000
        private static let VELOCITY_COEFFICIENT: CGFloat = 300
        
        private static let ITEM_GAP: CGFloat = 5
        
        private static let Z_INDEX_CATEGORY: CGFloat = 999999
        private static let Z_INDEX_ITEM: CGFloat = 1000000
        private static let Z_INDEX_SCREEN: CGFloat = 1000001
        private static let Z_INDEX_FRONT: CGFloat = 1000000000
        
        internal static let None: UInt32 = 0
        internal static let All: UInt32 = UInt32.max
        internal static let Goat: UInt32 = 0b1 //1
        internal static let Item: UInt32 = 0b10 //2
        internal static let Category: UInt32 = 0b100 //3
        
        internal static let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
        internal static let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
    }
    
    private let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
    private let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
    
    var playerScoreNode: [SKLabelNode] = GameModel.Side.allSides.map({ (side) -> SKLabelNode in
        SKLabelNode()
    })
    
    private var gameMode: GameMode = .TIMING
    private var loadingButton: [[LoadingNode]] = []
    private var pauseButton: ButtonNode!
    private var pauseScreen: SKSpriteNode!
    private var gameOverScreen: [SKSpriteNode] = []
    private var categoryBound: [CGFloat] = [0, 0]
    private var zIndex: CGFloat = 0
    private var gameInfo: SKLabelNode!
    private var isAI : Bool = true
    private var AI : EasyAI = EasyAI()
    private var frameCount : Int = 0    // this is use to delay actions in update function
    
    private func _setupGame() {
        gameInfo = SKLabelNode(fontNamed: Constants.LABEL_FONT)
        gameInfo.fontSize = 25
        gameInfo.position = CGPoint(x: frame.width/2, y : 650);
        
        if gameMode == .TIMING {
            var timesecond = 61
            var actionwait = SKAction.waitForDuration(1)
            var actionrun = SKAction.runBlock({
                if --timesecond == -1 {
                    self._gameOver()
                } else if timesecond >= 0 {
                    self.gameInfo.text = "\(timesecond/60):\(timesecond%60)"
                }
            })
            
            gameInfo.runAction(SKAction.repeatActionForever(SKAction.sequence([actionrun, actionwait])))
            self.addChild(gameInfo)
            
        } else if gameMode == .SCORING {
            gameInfo.text = "2000"
            self.addChild(gameInfo)
        }
    }
    
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
    
    private func _setupPauseButton() {
        pauseButton = ButtonNode(buttonType: .PAUSE, scale: 1)
        pauseButton.position = CGPointMake(frame.width/2, frame.height-pauseButton.size.height/2)
        self.addChild(pauseButton)
    }
    
    private func _setupMinorScreen() {
        pauseScreen = MinorScreen.pauseView(self.frame.size)
        pauseScreen.zPosition = Constants.Z_INDEX_SCREEN
        pauseScreen.position = CGPointMake(frame.width / 2, frame.height / 2)
        
        for i in 0...2 {
            gameOverScreen.append(MinorScreen.gameOverView(self.frame.size, winner: i))
            gameOverScreen[i].zPosition = Constants.Z_INDEX_SCREEN
            gameOverScreen[i].position = CGPointMake(frame.width / 2, frame.height / 2)
        }
    }
    
    private func _setupLabel() {
        for side in GameModel.Side.allSides {
            playerScoreNode[side.index] = SKLabelNode(fontNamed: Constants.LABEL_FONT)
            playerScoreNode[side.index].text = "000";
            playerScoreNode[side.index].fontSize = 40;
            playerScoreNode[side.index].position = CGPoint(x: side == .LEFT ? 420 : 604, y : 710);
            self.addChild(playerScoreNode[side.index])
        }
    }
    
    private func _setupArrow() {
        for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
            var y = CGFloat(Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(i))
            for side in GameModel.Side.allSides {
                var tmpNode = ArrowNode(side: side, index: i)
                tmpNode.position = CGPointMake(side == .LEFT ? 50 : frame.width-50, y)
                tmpNode.zPosition = -CGFloat(Constants.INFINITE)
                self.addChild(tmpNode)
            }
        }
    }
    
    private func _setupItem() {
        if isAI {
            return
        }
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addItem),
                SKAction.waitForDuration(Double(Constants.ITEM_GAP))
            ])
        ))
    }
    
    private func addItem() {
        var item = PowerUpNode(type: .UPGRADE)
        item.randomPower()
        item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        item.zPosition = Constants.Z_INDEX_ITEM
        item.showUp()
        self.addChild(item)
    }
    
    private func _setupCategory() {
        for side in GameModel.Side.allSides {
            var node = CategoryNode(side: side)
            if side == .LEFT {
                node.position = CGPointMake(node.size.width/2, node.size.height/2)
            } else {
                node.position = CGPointMake(frame.width - node.size.width/2, node.size.height/2)
            }
            node.zPosition = Constants.Z_INDEX_CATEGORY
            self.addChild(node)
        }
    }
    
    override func didMoveToView(view: SKView) {
        Constants.LAUNCH_X = [self.frame.minX, self.frame.maxX]
        
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        _setupGame()
        _setupLoadingButton()
        _setupPauseButton()
        _setupMinorScreen()
        _setupLabel()
        _setupArrow()
        _setupItem()
        _setupCategory()
    }
    
    private func goatDidCollideWithAnother(goats: [AnimalNode]) {
        for goat in goats {
            if goat.animal.status == .DEPLOYED {
                goat.updateAnimalStatus(.BUMPING)
            }
        }
    }
    
    private func itemDidCollideWithCategory(item: PowerUpNode, category: CategoryNode) {
        if categoryBound[category.side.index] + item.size.width + Constants.ITEM_GAP >= category.size.width {
            return
        } else {
            let xx = categoryBound[category.side.index] + Constants.ITEM_GAP + item.size.width / 2
            let x = category.side == .LEFT ? xx : frame.width - xx
            let y = category.size.height / 2
            
            categoryBound[category.side.index] += Constants.ITEM_GAP + item.size.width
            
            item.side = category.side
            item.name = PowerUpNode.Constants.IDENTIFIER_STORED
            
            item.physicsBody!.contactTestBitMask = GameScene.Constants.None
            item.physicsBody!.collisionBitMask = GameScene.Constants.None
            item.physicsBody!.dynamic = false
            
            let moveAction = (SKAction.moveTo(CGPointMake(x, y), duration:0.5))
            item.runAction(moveAction)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody = contact.bodyA
        var secondBody: SKPhysicsBody = contact.bodyB
        
        //check if both are goats
        if ((firstBody.categoryBitMask & GameScene.Constants.Goat) != 0 && (secondBody.categoryBitMask & GameScene.Constants.Goat) != 0) {
           goatDidCollideWithAnother([firstBody.node as! AnimalNode, secondBody.node as! AnimalNode])
        } else if ((firstBody.categoryBitMask == GameScene.Constants.Category && secondBody.categoryBitMask == GameScene.Constants.Item)
            || (firstBody.categoryBitMask == GameScene.Constants.Item && secondBody.categoryBitMask == GameScene.Constants.Category)) {
                if firstBody.node!.name == CategoryNode.Constants.IDENTIFIER {
                    swap(&firstBody, &secondBody)
                }
                itemDidCollideWithCategory(firstBody.node as! PowerUpNode, category: secondBody.node as! CategoryNode)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            var _touch = touch as! UITouch
            var node = self.nodeAtPoint(_touch.locationInNode(self))
           
            if node.name == LoadingNode.Constants.IDENTIFIER {
                _selectButton(node as! LoadingNode)
                
            } else if node.name == ArrowNode.Constants.IDENTIFIER {
                _deploy(node as! ArrowNode)
                
            } else if node.name == PowerUpNode.Constants.IDENTIFIER {
                node.physicsBody!.velocity = CGVector.zeroVector
                node.physicsBody!.dynamic = false
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            var _touch = touch as! UITouch
            var position = _touch.locationInNode(self)
            var previous = _touch.previousLocationInNode(self)
            var node = nodeAtPoint(previous)
            
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                node.position = position
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            var _touch = touch as! UITouch
            var position = _touch.locationInNode(self)
            var previous = _touch.previousLocationInNode(self)
            var node = nodeAtPoint(previous)
            
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                _applyVelocity(node, position: position, previous: previous)
            } else if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                _selectItem(node as! PowerUpNode)
            } else if (node is AnimalNode) {
                for item in GameModel.Constants.categorySelectedItem {
                    _applyPowerUp(item, target: node as? AnimalNode)
                }
            } else if node is ButtonNode && (node as! ButtonNode).button.buttonType == .PAUSE {
                _pauseGame()
            } else if node is ButtonNode && (node as! ButtonNode).button.buttonType == .CONTINUE {
                _continueGame()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        frameCount = (frameCount + 1) % 10  // The AI will launch a sheep every 10 frame
        for i in self.children {
            var node = i as! SKNode
            
            if node.name == AnimalNode.Constants.IDENTIFIER {
                var sideIndex = ((node as! AnimalNode).animal.color == .WHITE) ? 0 : 1
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    if (sideIndex == 0 && node.position.x > GAME_VIEW_RIGHT_BOUNDARY)
                            || (sideIndex == 1 && node.position.x < GAME_VIEW_LEFT_BOUNDARY){
                        _addScore(sideIndex, point: (node as! AnimalNode).animal.getPoint())
                    }
                    node.removeFromParent()
                } else {
                    if sideIndex == 0 {
                        (node as! AnimalNode).physicsBody!.velocity.dx = AnimalNode.Constants.VELOCITY
                    } else {
                        (node as! AnimalNode).physicsBody!.velocity.dx = -AnimalNode.Constants.VELOCITY
                    }
                }
            }
        }
        
        if isAI == true {
            var launchPair = AI.autoLaunch()
            if launchPair.0 > -1 && frameCount == 1{
                self.launchSheepForAI(launchPair.0, trackIndex: launchPair.1)
            }
        }
    }
    
    private func _addScore(side: Int, point: Int) {
        let newScore = playerScoreNode[side].text.toInt()!+point
        playerScoreNode[side].text = (newScore as NSNumber).stringValue
        if gameMode == .SCORING && newScore >= gameInfo.text.toInt()! {
            _gameOver()
        }
    }
    
    private func _pauseGame() {
        self.runAction(SKAction.runBlock({
            self.addChild(self.pauseScreen)
        }), completion: {
            self.view!.paused = true
            self.paused = true
        })
    }
    
    private func _continueGame() {
        pauseScreen.removeFromParent()
        self.view!.paused = false
        self.paused = false
    }
    
    private func _gameOver() {
        var leftScore = playerScoreNode[0].text.toInt()!
        var rightScore = playerScoreNode[1].text.toInt()!
        var index: Int!
        
        if leftScore > rightScore {
            index = 0
        } else if leftScore < rightScore {
            index = 1
        } else {
            index = 2
        }
        
        self.runAction(SKAction.runBlock({
            self.addChild(self.gameOverScreen[index])
        }), completion: {
            self.view!.paused = true
            self.paused = true
        })
    }
    
    private func _selectItem(item: PowerUpNode) {
        let index = item.side.index
        if let currentSelectedItem = GameModel.Constants.categorySelectedItem[index] {
            currentSelectedItem.updateItemStatus(.WAITING)
        }
        
        GameModel.Constants.categorySelectedItem[index] = item
        item.updateItemStatus(.SELECTED)
        
        if item.powerUpItem.getImplementationType() {
            _applyPowerUp(item, target: nil)
        }
    }
    
    private func _applyPowerUp(powerUpItem: PowerUpNode?, target: AnimalNode?) {
        if let item = powerUpItem {
            if item.powerUpItem.powerType == .BLACK_HOLE {
                if let animal = target {
                    if (item.side == .LEFT && animal.animal.color == .WHITE)
                        || (item.side == .RIGHT && animal.animal.color == .BLACK) {
                            return
                    } else {
                        Animation.applyBlackHole(self, node: animal)
                        removeFromCategory(item)
                    }
                }
            } else if item.powerUpItem.powerType == .FREEZE {
                if let animal = target {
                    if (item.side == .LEFT && animal.animal.color == .WHITE)
                        || (item.side == .RIGHT && animal.animal.color == .BLACK) {
                            return
                    } else {
                        Animation.applyFreezing(self, node: animal)
                        removeFromCategory(item)
                    }
                }
            } else if item.powerUpItem.powerType == .FIRE {
                if let animal = target {
                    if (item.side == .LEFT && animal.animal.color == .WHITE)
                        || (item.side == .RIGHT && animal.animal.color == .BLACK) {
                            return
                    } else {
                        Animation.applyFiring(self, node: animal)
                        removeFromCategory(item)
                    }
                }
            } else if item.powerUpItem.powerType == .UPGRADE {
                if let animal = target {
                    if (item.side == .LEFT && animal.animal.color == .BLACK)
                        || (item.side == .RIGHT && animal.animal.color == .WHITE) {
                            return
                    } else {
                        Animation.applyUpgrading(self, node: animal)
                        removeFromCategory(item)
                    }
                }
            }
        }
    }

    private func removeFromCategory(item: PowerUpNode) {
        let index = item.side.index
        
        var x = item.position.x
        var y = item.position.y
        var value = index == 0 ? item.size.width+Constants.ITEM_GAP : -item.size.width-Constants.ITEM_GAP
        
        categoryBound[index] -= item.size.width + Constants.ITEM_GAP
        GameModel.Constants.categorySelectedItem[index] = nil
        item.removeFromParent()
        
        var node = nodeAtPoint(CGPointMake(x+value, y))
        while node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
            let moveAction = (SKAction.moveTo(CGPointMake(x, y), duration:0.2))
            node.runAction(moveAction)
            
            x += value
            node = nodeAtPoint(CGPointMake(x+value, y))
        }
    }
    
    private func _applyVelocity(node: SKNode, position: CGPoint, previous: CGPoint) {
        var x = position.x - previous.x
        var y = position.y - previous.y
        var le = sqrt(x * x + y * y)
        
        node.physicsBody!.dynamic = true
        if previous != position {
            node.physicsBody!.velocity = CGVector(dx: x / le * Constants.VELOCITY_COEFFICIENT, dy: y / le * Constants.VELOCITY_COEFFICIENT)
        }
    }
    
    private func _deploy(arrow: ArrowNode) {
        var side = arrow.side
        var selectedButton = GameModel.Constants.selectedGoat[side.index]
        var selectedRow = arrow.index
        if !GameModel.isCattleReady(side, index: selectedButton) {
            return
        }
        
        GameModel.setCattleStatus(side, index: selectedButton, status: false)
        var currentSize = loadingButton[side.index][selectedButton].animal.size
        var y = Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(selectedRow)

        var sprite = AnimalNode(size: currentSize, side: side)
        sprite.position.x = Constants.LAUNCH_X[side.index]
        sprite.position.y = y
        sprite.zPosition = ++zIndex
        self.addChild(sprite)
        
        var button = loadingButton[side.index][selectedButton]
        button.change()
        button.fadeAnimation(side, index: selectedButton)
    }
    
    
    private func _selectButton(node: LoadingNode) {
        var side: GameModel.Side = (node.animal.color == .WHITE) ? .LEFT : .RIGHT
        GameModel.selectForSide(side, index: node.index)
    }
    
    private func launchSheepForAI(readyIndex : Int, trackIndex : Int) {
        self.enumerateChildNodesWithName(ArrowNode.Constants.IDENTIFIER, usingBlock: { (node, stop) -> Void in
            var arrowNode : ArrowNode = node as! ArrowNode
            if arrowNode.side == .RIGHT && arrowNode.index == trackIndex {
                GameModel.selectForSide(.RIGHT, index: readyIndex)
                self._deploy(arrowNode)
            }
        })
    }
    
}
