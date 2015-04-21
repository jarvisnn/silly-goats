//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
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
        
        private static let PAN_GESTURE_WIDTH = 3
        private static let PAN_GESTURE_HEIGHT = 2
    }
    
    private let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
    private let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
    
    private var scoreNode: [ScoreNode] = Animal.Side.allSides.map({ (side) -> ScoreNode in
        return ScoreNode(side: side)
    })
    
    private var arrows = [[ArrowNode]](count: GameModel.Constants.NUMBER_OF_BRIDGES, repeatedValue: [ArrowNode](count: Animal.Size.allSizes.count, repeatedValue: ArrowNode()))
    private var loadingButton: [[LoadingNode]] = []
    
    private var pauseScreen: PauseScene!
    private var gameOverScreen: GameOverScene!
    
    private var categories = [CategoryNode](count: 2, repeatedValue: CategoryNode())
    private var zIndex: CGFloat = 0
    private var timerNode: SKLabelNode!
    
    private var item_velocity: CGVector = Constants.ITEM_INIT_VELOCITY
    
    private var frameCount: Int = 0
    
    private var gameModel: GameModel!

    private var _tapGesture: UITapGestureRecognizer!
    private var _panGesture = [[UIPanGestureRecognizer]]()

    internal func setupGame(mode: GameModel.GameMode) {
        gameModel = GameModel(gameMode: mode)
    }
    
    private func _setupRecognizer() {
        _tapGesture = UITapGestureRecognizer(target: self, action: "tapHandler:")
        self.view!.addGestureRecognizer(_tapGesture)

        for i in 0..<Constants.PAN_GESTURE_WIDTH {
            _panGesture.append([])
            for j in 0..<Constants.PAN_GESTURE_HEIGHT {
                _panGesture[i].append(UIPanGestureRecognizer(target: self, action: "panHandler:"))
                self.view!.addGestureRecognizer(_panGesture[i][j])
                _panGesture[i][j].maximumNumberOfTouches = 1
            }
        }
        
        for recognizer in self.view!.gestureRecognizers! {
            (recognizer as! UIGestureRecognizer).delegate = self
        }
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
        MenuButtonNode.Constants.reactions = [_pauseGame, _restartGame, _backToHome, _continueGame]

        var pauseButton = MenuButtonNode(buttonType: .PAUSE, scale: 1)
        pauseButton.position = CGPointMake(frame.width / 2, frame.height - pauseButton.size.height / 2)
        self.addChild(pauseButton)
    }
    
    private func _setupMinorScreen() {
        pauseScreen = PauseScene(size: self.frame.size)
        pauseScreen.zPosition = Constants.Z_INDEX_SCREEN
        pauseScreen.position = CGPointMake(frame.width / 2, frame.height / 2)
        
        gameOverScreen = GameOverScene(size: self.frame.size)
        gameOverScreen.zPosition = Constants.Z_INDEX_SCREEN
        gameOverScreen.position = CGPointMake(frame.width / 2, frame.height / 2)
    }
    
    private func _setupScore() {
        for side in Animal.Side.allSides {
            scoreNode[side.index].score = 0
            self.addChild(scoreNode[side.index])
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
        var item = PowerUpNode(type: .FREEZE)
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
            var y = categories[side.index].size.height / 2
            var x = categories[side.index].size.width / 2
            x = (side == .LEFT) ? x : frame.width - x
            categories[side.index].position = CGPointMake(x, y)
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
        
        _setupRecognizer()
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
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var bodyA: SKPhysicsBody = contact.bodyA
        var bodyB: SKPhysicsBody = contact.bodyB
        
        if ((bodyA.categoryBitMask & GameScene.Constants.Goat) != 0 && (bodyB.categoryBitMask & GameScene.Constants.Goat) != 0) {
           goatDidCollideWithAnother([bodyA.node as! AnimalNode, bodyB.node as! AnimalNode])
        } else if ((bodyA.categoryBitMask == GameScene.Constants.Category && bodyB.categoryBitMask == GameScene.Constants.Item) || (bodyA.categoryBitMask == GameScene.Constants.Item && bodyB.categoryBitMask == GameScene.Constants.Category)) {
                if bodyA.node!.name == CategoryNode.Constants.IDENTIFIER {
                    swap(&bodyA, &bodyB)
                }
                var item = bodyA.node as! PowerUpNode
                var category = bodyB.node as! CategoryNode
                if gameModel.gameMode == .ITEM_MODE {
                    item.removeFromParent()
                    scoreNode[category.side.index].score += 10
                } else {
                    category.add(item)
                }

        }
    }
    
    internal func tapHandler(recognizer: UITapGestureRecognizer) {
        var location = self.convertPointFromView(recognizer.locationInView(recognizer.view))
        var node = self.nodeAtPoint(location)
        
        if node.name == LoadingNode.Constants.IDENTIFIER {
            _selectButton(node as! LoadingNode)
            
        } else if node.name == ArrowNode.Constants.IDENTIFIER {
            _deploy(node as! ArrowNode)
            
        }  else if node is MenuButtonNode {
            (node as! MenuButtonNode).clicked()
        }
    }
    
    internal func panHandler(recognizer: UIPanGestureRecognizer) {
        var end = recognizer.locationInView(recognizer.view)
        var translation = recognizer.translationInView(recognizer.view!)
        var start = CGPointMake(end.x - translation.x, end.y - translation.y)
        
        start = self.convertPointFromView(start)
        end = self.convertPointFromView(end)
        
        var node = self.nodeAtPoint(start)
        if recognizer.state == .Began {
            if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                var itemNode = node as! PowerUpNode
                var side = itemNode.side
                var index = find(categories[side.index].items, itemNode)
                gameModel.categorySelectedItem[side.index] = index
                itemNode.updateItemStatus(.SELECTED)
            }
            
        } else if recognizer.state == .Changed {
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                if start != end {
                    node.position = end
                    recognizer.setTranslation(CGPoint.zeroPoint, inView: recognizer.view)
                }
                
            } else if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                Animation.draggingPowerUp((node as! PowerUpNode).powerUpItem.powerType, scene: self, position: end)
            }
            
        } else if recognizer.state == .Ended {
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                var speed = self.convertPointFromView(recognizer.velocityInView(recognizer.view))
                _applyVelocity(node, x: speed.x, y: speed.y)
            } else if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                var itemNode = node as! PowerUpNode
                itemNode.updateItemStatus(.WAITING)

                var effect = Animation.draggingPowerUp((node as! PowerUpNode).powerUpItem.powerType, scene: self, position: end)

                var node = _findNearestAnimal(itemNode, effect: effect)
                if node != nil {
                    _applyPowerUp(itemNode, target: node!)
                }
            }
        }
    }
    
    private func _isItemValid(itemNode: PowerUpNode, animalNode: AnimalNode) -> Bool {
        if itemNode.powerUpItem.powerType == .FREEZE {
            return true
        }
        return (itemNode.side == animalNode.animal.side) == PowerUp.PowerType.targetFriendly(itemNode.powerUpItem.powerType)
    }
    
    private func _isAnimalRemoved(node: AnimalNode) -> Bool {
        if node.paused {
            return true
        }
        if var body = node.physicsBody {
            if !body.dynamic {
                return true
            }
        } else {
            return true
        }
        return false
    }
        
    private func _findNearestAnimal(itemNode: PowerUpNode, effect: SKEmitterNode) -> AnimalNode? {
        var result: AnimalNode?
        for node in self.children {
            if var animalNode = node as? AnimalNode {
                var range = CGPoint(x: effect.particlePositionRange.dx, y: effect.particlePositionRange.dy)
                var size = range * 2.0
                var origin = effect.position - range
                var effectFrame = CGRect(origin: origin, size: CGSize(width: size.x, height: size.y))
                
                var isOver = CGRectIntersection(effectFrame, animalNode.frame).size != CGSize.zeroSize
                var isValid = _isItemValid(itemNode, animalNode: animalNode) && !_isAnimalRemoved(animalNode)
                
                if isOver && isValid {
                    if result == nil {
                        result = animalNode
                    } else {
                        if (animalNode.position - effect.position).getDistance() < (result!.position - effect.position).getDistance() {
                            result = animalNode
                        }
                    }
                }
            }
        }
        return result
    }
        
    private func _applyPowerUp(item: PowerUpNode, target: AnimalNode) {
        var targets: [AnimalNode] = [target]
        var category = item.parent as! CategoryNode
        if item.powerUpItem.powerType == .FREEZE {
            var unwrapped = self.children.filter() { (i) -> Bool in
                if var node = i as? AnimalNode {
                    return node.row == target.row && !self._isAnimalRemoved(node)
                }
                return false
            }
            targets = unwrapped.map() { (node) -> AnimalNode in
                return node as! AnimalNode
            }
        }
        Animation.applyPowerUp(item, targets: targets, scene: self, removeItemFunc: category.remove)
    }
    
    override func update(currentTime: CFTimeInterval) {
        frameCount = (frameCount + 1) % 45
        for i in self.children {
            var node = i as! SKNode
            
            if node.name == AnimalNode.Constants.IDENTIFIER {
                var sideIndex = (node as! AnimalNode).animal.side.index
                var x = node.position.x
                if x < GAME_VIEW_LEFT_BOUNDARY || x > GAME_VIEW_RIGHT_BOUNDARY {
                    scoreNode[sideIndex].score += (node as! AnimalNode).animal.getPoint()
                    node.removeFromParent()
                } else {
                    var factor: CGFloat = (sideIndex == 0) ? 1 : -1
                    if (node as! AnimalNode).physicsBody != nil {
                        (node as! AnimalNode).physicsBody!.velocity.dx = AnimalNode.Constants.VELOCITY * factor
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
        gameOverScreen.removeFromParent()
        self.view!.paused = false
        self.paused = false
    }
    
    private func _backToHome() {
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.BACK_HOME_MESS, object: nil)
    }
    
    private func _pauseGame() {
        _moveToScreen(pauseScreen)
    }
    
    private func _gameOver() {
        gameOverScreen.update()
        _moveToScreen(gameOverScreen)
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
    
    private func _moveToScreen(screen: SKSpriteNode) {
        self.runAction(SKAction.runBlock({
            self.addChild(screen)
        }), completion: {
            self.view!.paused = true
            self.paused = true
        })
    }
    
    private func _applyVelocity(node: SKNode, x: CGFloat, y: CGFloat) {
        var le = CGPoint(x: x, y: y).getDistance()
        
        node.physicsBody!.dynamic = true
        if le != 0 {
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
        
        GameSound.Constants.instance.play(.GOAT_SOUND)
        
        gameModel.setCattleStatus(side, index: selectedButton, status: false)
        var currentSize = loadingButton[side.index][selectedButton].animal.size
        var y = Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(selectedRow)

        var sprite = AnimalNode(size: currentSize, side: side, row: selectedRow)
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer == _tapGesture {
            return true
        }
        
        var x = Double(touch.locationInView(self.view).x) / Double(self.view!.frame.width)
        var y = Double(touch.locationInView(self.view).y) / Double(self.view!.frame.height)
        x *= Double(Constants.PAN_GESTURE_WIDTH)
        y *= Double(Constants.PAN_GESTURE_HEIGHT)
        x = min(floor(x), Double(Constants.PAN_GESTURE_WIDTH - 1))
        y = min(floor(y), Double(Constants.PAN_GESTURE_HEIGHT - 1))
        println("\(x) \(y) \(gestureRecognizer == _panGesture[Int(x)][Int(y)])")
        return gestureRecognizer == _panGesture[Int(x)][Int(y)]
    }
}
