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
        internal static let BACK_HOME_MESS = "backToPreviousScene"
        private static var GENERATE_ITEM_KEY = "generateItem"
        
        private static var LAUNCH_X: [CGFloat]!
        private static let LAUNCH_Y_TOP: CGFloat = 560
        private static let LAUNCH_Y_GAP: CGFloat = 100
        private static let LABEL_FONT = "Chalkduster"
        private static let INFINITE: CGFloat = 1000000000
        
        private static let ITEM_VELOCITY: CGFloat = 300
        private static let ITEM_INIT_VELOCITY = CGVectorMake(20, 0)
        
        private static let ITEM_GAP: CGFloat = 5
        private static let ITEM_SHOW_TIME: Double = 5
        
        private static let Z_INDEX_ITEM: CGFloat = 1000000
        private static let Z_INDEX_CATEGORY: CGFloat = Z_INDEX_ITEM - 1
        private static let Z_INDEX_SCREEN: CGFloat = Z_INDEX_ITEM + 1
        private static let Z_INDEX_FRONT: CGFloat = INFINITE
        
        internal static let None: UInt32 = 0
        internal static let All: UInt32 = UInt32.max
        internal static let Goat: UInt32 = 0b1 //1
        internal static let Item: UInt32 = 0b10 //2
        internal static let Category: UInt32 = 0b100 //3
        
        internal static let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
        internal static let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
        
        private static let ROUND_TIME = 90
    }
    
    private let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
    private let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
    
    private var playerScoreNode: [ScoreNode] = Animal.Side.allSides.map({ (side) -> ScoreNode in
        return ScoreNode(side: side)
    })
    
    private var arrows = [[ArrowNode]](count: GameModel.Constants.NUMBER_OF_BRIDGES, repeatedValue: [ArrowNode](count: Animal.Size.allSizes.count, repeatedValue: ArrowNode()))
    private var loadingButton: [[LoadingNode]] = []
    private var pauseButton: MenuButtonNode!
    private var pauseScreen: PauseScene!
    private var gameOverScreen: [SKSpriteNode] = []
    private var categories = [CategoryNode](count: 2, repeatedValue: CategoryNode())
    private var categoryBound: [CGFloat] = [0, 0]
    private var zIndex: CGFloat = 0
    private var timerNode: SKLabelNode!
    
    private var item_velocity: CGVector = Constants.ITEM_INIT_VELOCITY
    
    private var frameCount: Int = 0    // this is use to delay actions in update function
    
    private var gameModel: GameModel!
    
    internal func setupGame(mode: GameModel.GameMode) {
        gameModel = GameModel(gameMode: mode)
    }
    
    private func _setupTiming() {
        timerNode = SKLabelNode(fontNamed: Constants.LABEL_FONT)
        timerNode.fontSize = 25
        timerNode.position = CGPoint(x: frame.width/2, y: 650);
        
        var timesecond = Constants.ROUND_TIME + 1
        var actionwait = SKAction.waitForDuration(1)
        var actionrun = SKAction.runBlock({
            if --timesecond == -1 {
                self._gameOver()
            } else if timesecond >= 0 {
                self.timerNode.text = "\(timesecond/60):\(timesecond%60)"
            }
        })
        
        timerNode.runAction(SKAction.repeatActionForever(SKAction.sequence([actionrun, actionwait])))
        self.addChild(timerNode)
    }
    
    private func _setupLoadingButton() {
        loadingButton = Animal.Side.allSides.map { (side) -> [LoadingNode] in
            return map(0..<GameModel.Constants.NUMBER_OF_RESERVED, { (index) -> LoadingNode in
                var location: CGPoint
                var node = LoadingNode(side: side, index: index)
                if side == .LEFT {
                    location = CGPoint(x: 50 + index * 80, y: 725)
                } else {
                    location = CGPoint(x: (Int)(self.frame.width) - 50 - index * 80, y: 725)
                }
                node.position = location
                self.addChild(node)
                return node
            })
        }
    }
    
    private func _setupPauseButton() {
        pauseButton = MenuButtonNode(buttonType: .PAUSE, scale: 1)
        pauseButton.position = CGPointMake(frame.width/2, frame.height-pauseButton.size.height/2)
        self.addChild(pauseButton)
    }
    
    private func _setupMinorScreen() {
        pauseScreen = PauseScene(size: self.frame.size, pauseFunc: _pauseGame, continueFunc: _continueGame, restartFunc: _restartGame, homeFunc: _backToHome)
        pauseScreen.zPosition = Constants.Z_INDEX_SCREEN
        pauseScreen.position = CGPointMake(frame.width / 2, frame.height / 2)
        
        for i in 0...2 {
            gameOverScreen.append(MinorScreen.gameOverView(self.frame.size, winner: i))
            gameOverScreen[i].zPosition = Constants.Z_INDEX_SCREEN
            gameOverScreen[i].position = CGPointMake(frame.width / 2, frame.height / 2)
        }
    }
    
    private func _setupScore() {
        for side in Animal.Side.allSides {
            playerScoreNode[side.index].score = 0
            self.addChild(playerScoreNode[side.index])
        }
    }
    
    private func _setupArrow() {
        for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
            var y = CGFloat(Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(i))
            for side in Animal.Side.allSides {
                arrows[i][side.index] = ArrowNode(side: side, index: i)
                arrows[i][side.index].position = CGPointMake(side == .LEFT ? 50 : frame.width-50, y)
                arrows[i][side.index].zPosition = -Constants.INFINITE
                self.addChild(arrows[i][side.index])
            }
        }
    }
    
    private func _setupItem() {
        if gameModel.gameMode == .MULTIPLAYER {
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock(addItem),
                    SKAction.waitForDuration(Constants.ITEM_SHOW_TIME)
                ])
            ), withKey: Constants.GENERATE_ITEM_KEY)
        } else if gameModel.gameMode == .ITEM_MODE {
            generateItem()
        }
    }
    
    private func addItem() {
        var item = PowerUpNode(type: .UPGRADE)
        item.randomPower()
        item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        item.zPosition = Constants.Z_INDEX_ITEM
        
        var x = Double(item_velocity.dx)
        var y = Double(item_velocity.dy)
        var a = M_PI/6
        item_velocity.dx = CGFloat(x * cos(a) - y * sin(a))
        item_velocity.dy = CGFloat(x * sin(a) + y * cos(a))
        
        item.showUp()
        self.addChild(item)
        item.physicsBody!.velocity = item_velocity
    }
    
    private func randomNumber(from: Int, to: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(to-from+1))) + CGFloat(from)
    }
    
    private func generateItem() {
        var _actionPack1 = SKAction.runBlock({
            var item = PowerUpNode(type: .UPGRADE)
            item.randomPower()
            item.position = CGPoint(x: self.size.width/2 + self.randomNumber(-400, to: 400),
                y: self.size.height/2 + self.randomNumber(-300, to: 300))
            item.zPosition = Constants.Z_INDEX_ITEM
            item.physicsBody!.velocity.dx = self.randomNumber(-30, to: 30)
            item.physicsBody!.velocity.dy = self.randomNumber(-30, to: 30)
            
            item.showUp()
            self.addChild(item)
        })
        var action1_1 = SKAction.sequence([_actionPack1, SKAction.waitForDuration(1.5)])
        var action1_2 = SKAction.sequence([_actionPack1, SKAction.waitForDuration(1.0)])
        var action1_3 = SKAction.sequence([_actionPack1, SKAction.waitForDuration(0.75)])
        var action1_4 = SKAction.sequence([_actionPack1, SKAction.waitForDuration(0.5)])
        
        var item_velocity = CGVectorMake(300, 0)
        var _actionPack2 = SKAction.runBlock({
            var item = PowerUpNode(type: .UPGRADE)
            item.randomPower()
            item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            item.zPosition = Constants.Z_INDEX_ITEM
            
            var x = Double(item_velocity.dx)
            var y = Double(item_velocity.dy)
            var a = M_PI/6
            item_velocity.dx = CGFloat(x * cos(a) - y * sin(a))
            item_velocity.dy = CGFloat(x * sin(a) + y * cos(a))
            
            item.physicsBody!.velocity = item_velocity
            item.showUp()
            self.addChild(item)
        })
        var action2_1 = SKAction.sequence([_actionPack2, SKAction.waitForDuration(0.5)])
        var action2_2 = SKAction.sequence([_actionPack2, SKAction.waitForDuration(0.3)])
        var action2_3 = SKAction.sequence([_actionPack2, SKAction.waitForDuration(0.1)])
        
        self.runAction(SKAction.sequence([
            SKAction.repeatAction(action1_1, count: 10),
            SKAction.repeatAction(action1_2, count: 10),
            SKAction.repeatAction(action1_3, count: 10),
            SKAction.repeatAction(action1_4, count: 10),
            SKAction.repeatAction(action2_1, count: 40),
            SKAction.repeatAction(action2_2, count: 50),
            SKAction.repeatAction(action2_3, count: 200)
        ]), withKey: Constants.GENERATE_ITEM_KEY)
    }
    
    
    private func _setupCategory() {
        for side in Animal.Side.allSides {
            categories[side.index] = CategoryNode(side: side)
            if side == .LEFT {
                categories[side.index].position = CGPointMake(categories[side.index].size.width/2, categories[side.index].size.height/2)
            } else {
                categories[side.index].position = CGPointMake(frame.width - categories[side.index].size.width/2, categories[side.index].size.height/2)
            }
            categories[side.index].zPosition = Constants.Z_INDEX_CATEGORY
            self.addChild(categories[side.index])
        }
    }
    
    private func _hideUncessaryNode() {
        if gameModel.gameMode == .SINGLE_PLAYER {
            for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
                arrows[i][1].removeFromParent()
            }
            for node in categories {
                node.removeFromParent()
            }
        } else if gameModel.gameMode == .ITEM_MODE {
            for nodeArray in loadingButton {
                for node in nodeArray {
                    node.removeFromParent()
                }
            }
            for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
                arrows[i][1].removeFromParent()
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        Constants.LAUNCH_X = [self.frame.minX, self.frame.maxX]
        
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        _setupTiming()
        _setupLoadingButton()
        _setupPauseButton()
        _setupMinorScreen()
        _setupScore()
        _setupArrow()
        _setupItem()
        _setupCategory()
        _hideUncessaryNode()
    }
    
    private func goatDidCollideWithAnother(goats: [AnimalNode]) {
        for goat in goats {
            if goat.animal.status == .DEPLOYED {
                goat.updateAnimalStatus(.BUMPING)
            }
        }
    }
    
    private func itemDidCollideWithCategory(item: PowerUpNode, category: CategoryNode) {
        if gameModel.gameMode == .ITEM_MODE {
            item.removeFromParent()
            playerScoreNode[category.side.index].score += 10
        } else {
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
                item.runAction(moveAction, completion: { () -> Void in
                    item.position = item.parent!.convertPoint(item.position, toNode: category)
                    item.removeFromParent()
                    category.addChild(item)
                })
            }
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
                for item in gameModel.categorySelectedItem {
                    _applyPowerUp(item, target: node as? AnimalNode)
                }
            } else if node is MenuButtonNode {
                pauseScreen.buttonClicked((node as! MenuButtonNode).button.buttonType)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        frameCount = (frameCount + 1) % 45  // The AI will launch a sheep every 45 frame
        for i in self.children {
            var node = i as! SKNode
            
            if node.name == AnimalNode.Constants.IDENTIFIER {
                var sideIndex = (node as! AnimalNode).animal.side.index
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    if (sideIndex == 0 && node.position.x > GAME_VIEW_RIGHT_BOUNDARY) || (sideIndex == 1 && node.position.x < GAME_VIEW_LEFT_BOUNDARY){
                        playerScoreNode[sideIndex].score += (node as! AnimalNode).animal.getPoint()
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
        
        if var AI = gameModel.AI {
            var launchPair = AI.autoLaunch()
            if launchPair.0 > -1 && frameCount == 1{
                self.launchSheepForAI(launchPair.0, trackIndex: launchPair.1)
            }
        }
    }
        
    private func _continueGame() {
        pauseScreen.removeFromParent()
        self.view!.paused = false
        self.paused = false
    }
    
    private func _backToHome() {
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.BACK_HOME_MESS, object: nil)
    }
    
    private func _pauseGame() {
        _moveToScreen(pauseScreen)
    }
    
    private func _restartGame() {
        _continueGame()
        
        for node in self.children {
            if node is AnimalNode || node is PowerUpNode || node is LoadingNode || node is SKLabelNode {
                node.removeFromParent()
            }
        }
        self.removeActionForKey(Constants.GENERATE_ITEM_KEY)
        
        _setupTiming()
        _setupScore()
        _setupItem()
        if gameModel.gameMode != .ITEM_MODE {
            _setupLoadingButton()
        }
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
        
        _moveToScreen(gameOverScreen[index])
    }
    
    private func _moveToScreen(screen: SKSpriteNode) {
        self.runAction(SKAction.runBlock({
            self.addChild(screen)
        }), completion: {
            self.view!.paused = true
            self.paused = true
        })
    }
    
    private func _selectItem(item: PowerUpNode) {
        let index = item.side.index
        if var currentSelectedItem = gameModel.categorySelectedItem[index] {
            currentSelectedItem.updateItemStatus(.WAITING)
        }
        
        gameModel.categorySelectedItem[index] = item
        item.updateItemStatus(.SELECTED)
        
        if item.powerUpItem.getImplementationType() {
            Animation.applyPowerUp(item, targets: [nil], scene: self, removeItemFunc: removeFromCategory)
        }
    }
    
    private func _applyPowerUp(item: PowerUpNode?, target: AnimalNode?) {
        if item != nil && item!.powerUpItem.powerType == .FREEZE && target != nil {
            var targets = [target]
            for i in self.children {
                if var node = i as? AnimalNode {
                    if target!.position.y - 50 < node.position.y && node.position.y < target!.position.y + 50 && node != target {
                        targets.append(node)
                    }
                }
            }
            Animation.applyPowerUp(item, targets: targets, scene: self, removeItemFunc: removeFromCategory)
        } else {
            Animation.applyPowerUp(item, targets: [target], scene: self, removeItemFunc: removeFromCategory)
        }
    }
    
    private func removeFromCategory(item: PowerUpNode) {
        let index = item.side.index
        
        var x = item.position.x
        var y = item.position.y
        var value = index == 0 ? item.size.width+Constants.ITEM_GAP : -item.size.width-Constants.ITEM_GAP
        
        categoryBound[index] -= item.size.width + Constants.ITEM_GAP
        gameModel.categorySelectedItem[index] = nil
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
            node.physicsBody!.velocity = CGVector(dx: x / le * Constants.ITEM_VELOCITY, dy: y / le * Constants.ITEM_VELOCITY)
        }
    }
    
    private func _deploy(arrow: ArrowNode) {
        var side = arrow.side
        var selectedButton = gameModel.selectedGoat[side.index]
        var selectedRow = arrow.index
        if !gameModel.isCattleReady(side, index: selectedButton) {
            return
        }
        
        gameModel.setCattleStatus(side, index: selectedButton, status: false)
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
        gameModel.selectForSide(node.animal.side, index: node.index)
    }
    
    private func launchSheepForAI(readyIndex: Int, trackIndex: Int) {
        gameModel.selectForSide(.RIGHT, index: readyIndex)
        _deploy(arrows[trackIndex][1])
    }
    
}
