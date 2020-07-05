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
        fileprivate static var GENERATE_ITEM_KEY = "generateItem"
        
        fileprivate static var LAUNCH_X: [CGFloat]!
        fileprivate static let LAUNCH_Y_TOP: CGFloat = 560
        fileprivate static let LAUNCH_Y_GAP: CGFloat = 100
        fileprivate static let LABEL_FONT = "Chalkduster"
        fileprivate static let INFINITE: CGFloat = 1000000000
        
        fileprivate static let ITEM_VELOCITY: CGFloat = 300
        fileprivate static let ITEM_INIT_VELOCITY = CGVector(dx: 20, dy: 0)
        
        fileprivate static let ITEM_SHOW_TIME: Double = 5
        
        fileprivate static let Z_INDEX_ITEM: CGFloat = 1000000
        fileprivate static let Z_INDEX_CATEGORY: CGFloat = Z_INDEX_ITEM - 1
        fileprivate static let Z_INDEX_SCREEN: CGFloat = Z_INDEX_ITEM + 1
        fileprivate static let Z_INDEX_FRONT: CGFloat = INFINITE
        
        internal static let None: UInt32 = 0
        internal static let All: UInt32 = UInt32.max
        internal static let Goat: UInt32 = 0b1 //1
        internal static let Item: UInt32 = 0b10 //2
        internal static let Category: UInt32 = 0b100 //3
        
        internal static let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
        internal static let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
        
        fileprivate static let ROUND_TIME = 90
        
        fileprivate static let PAN_GESTURE_WIDTH = 3
        fileprivate static let PAN_GESTURE_HEIGHT = 2
    }
    
    fileprivate let GAME_VIEW_RIGHT_BOUNDARY: CGFloat = 1100
    fileprivate let GAME_VIEW_LEFT_BOUNDARY: CGFloat = -100
    
    fileprivate var scoreNode: [ScoreNode] = Animal.Side.allSides.map({ (side) -> ScoreNode in
        return ScoreNode(side: side)
    })
    
    fileprivate var arrows = [[ArrowNode]](repeating: [ArrowNode](repeating: ArrowNode(), count: Animal.Size.allSizes.count), count: GameModel.Constants.NUMBER_OF_BRIDGES)
    fileprivate var loadingButton: [[LoadingNode]] = []
    fileprivate var loadingBorder: [[BorderNode]] = []
    
    fileprivate var pauseScreen: PauseScene!
    fileprivate var gameOverScreen: GameOverScene!
    
    fileprivate var categories = [CategoryNode](repeating: CategoryNode(), count: 2)
    fileprivate var zIndex: CGFloat = 0
    fileprivate var timerNode: SKLabelNode!
    
    fileprivate var item_velocity: CGVector = Constants.ITEM_INIT_VELOCITY
    
    fileprivate var frameCount: Int = 0
    
    fileprivate var gameModel: GameModel!

    fileprivate var _tapGesture: UITapGestureRecognizer!
    fileprivate var _panGesture = [[UIPanGestureRecognizer]]()

    internal func setupGame(_ mode: GameModel.GameMode) {
        gameModel = GameModel(gameMode: mode)
    }
    
    fileprivate func _setupRecognizer() {
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapHandler(_:)))
        self.view!.addGestureRecognizer(_tapGesture)

        for i in 0..<Constants.PAN_GESTURE_WIDTH {
            _panGesture.append([])
            for j in 0..<Constants.PAN_GESTURE_HEIGHT {
                _panGesture[i].append(UIPanGestureRecognizer(target: self, action: #selector(GameScene.panHandler(_:))))
                self.view!.addGestureRecognizer(_panGesture[i][j])
                _panGesture[i][j].maximumNumberOfTouches = 1
            }
        }
        
        for recognizer in self.view!.gestureRecognizers! {
            (recognizer ).delegate = self
        }
    }
    
    fileprivate func _setupTiming() {
        timerNode = SKLabelNode(fontNamed: Constants.LABEL_FONT)
        timerNode.fontSize = 25
        timerNode.position = CGPoint(x: frame.width/2, y: 650);
        
        var timesecond = Constants.ROUND_TIME + 1
        let actionwait = SKAction.wait(forDuration: 1)
        let actionrun = SKAction.run({
            if timesecond - 1 == -1 {
                self._gameOver()
            } else if timesecond >= 0 {
                timesecond -= 1
                self.timerNode.text = "\(timesecond/60):\(timesecond%60)"
            }
        })
        
        timerNode.run(SKAction.repeatForever(SKAction.sequence([actionrun, actionwait])))
        self.addChild(timerNode)
    }
    
    fileprivate func _setupLoadingButton() {
        loadingButton = Animal.Side.allSides.map { (side) -> [LoadingNode] in
            return (0..<GameModel.Constants.NUMBER_OF_RESERVED).map( { (index) -> LoadingNode in
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
        for i in 0..<Animal.Side.allSides.count {
            loadingBorder.append([])
            for j in 0..<GameModel.Constants.NUMBER_OF_RESERVED {
                var node = BorderNode()
                node.position = loadingButton[i][j].position
                node.zPosition = -1
                self.addChild(node)
                loadingBorder[i].append(node)
            }
        }
        
        updateLoadingBorder(.LEFT)
        updateLoadingBorder(.RIGHT)
    }
    
    fileprivate func _setupPauseButton() {
        MenuButtonNode.Constants.reactions = [_pauseGame, _restartGame, _backToHome, _continueGame]

        let pauseButton = MenuButtonNode(buttonType: .PAUSE, scale: 1)
        pauseButton.position = CGPoint(x: frame.width / 2, y: frame.height - pauseButton.size.height / 2)
        self.addChild(pauseButton)
    }
    
    fileprivate func _setupMinorScreen() {
        pauseScreen = PauseScene(size: self.frame.size)
        pauseScreen.zPosition = Constants.Z_INDEX_SCREEN
        pauseScreen.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        gameOverScreen = GameOverScene(size: self.frame.size)
        gameOverScreen.zPosition = Constants.Z_INDEX_SCREEN
        gameOverScreen.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    fileprivate func _setupScore() {
        for side in Animal.Side.allSides {
            scoreNode[side.index].score = 0
            self.addChild(scoreNode[side.index])
        }
    }
    
    fileprivate func _setupArrow() {
        for i in 0..<GameModel.Constants.NUMBER_OF_BRIDGES {
            let y = CGFloat(Constants.LAUNCH_Y_TOP - Constants.LAUNCH_Y_GAP * CGFloat(i))
            for side in Animal.Side.allSides {
                arrows[i][side.index] = ArrowNode(side: side, index: i)
                arrows[i][side.index].position = CGPoint(x: side == .LEFT ? 50 : frame.width-50, y: y)
                arrows[i][side.index].zPosition = -Constants.INFINITE
                self.addChild(arrows[i][side.index])
            }
        }
    }
    
    fileprivate func _setupItem() {
        if gameModel.gameMode == .MULTIPLAYER {
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addItem),
                    SKAction.wait(forDuration: Constants.ITEM_SHOW_TIME)
                ])
            ), withKey: Constants.GENERATE_ITEM_KEY)
        } else if gameModel.gameMode == .ITEM_MODE {
            generateItem()
        }
    }
    
    fileprivate func addItem() {
        let item = PowerUpNode(type: .FREEZE)
        item.randomPower()
        item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        item.zPosition = Constants.Z_INDEX_ITEM
        
        let x = Double(item_velocity.dx)
        let y = Double(item_velocity.dy)
        let a = M_PI/6
        item_velocity.dx = CGFloat(x * cos(a) - y * sin(a))
        item_velocity.dy = CGFloat(x * sin(a) + y * cos(a))
        
        item.showUp()
        self.addChild(item)
        item.physicsBody!.velocity = item_velocity
    }
    
    fileprivate func randomNumber(_ from: Int, to: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(to-from+1))) + CGFloat(from)
    }
    
    fileprivate func generateItem() {
        let _actionPack1 = SKAction.run({
            let item = PowerUpNode(type: .UPGRADE)
            item.randomPower()
            item.position = CGPoint(x: self.size.width/2 + self.randomNumber(-400, to: 400),
                y: self.size.height/2 + self.randomNumber(-300, to: 300))
            item.zPosition = Constants.Z_INDEX_ITEM
            item.physicsBody!.velocity.dx = self.randomNumber(-30, to: 30)
            item.physicsBody!.velocity.dy = self.randomNumber(-30, to: 30)
            
            item.showUp()
            self.addChild(item)
        })
        let action1_1 = SKAction.sequence([_actionPack1, SKAction.wait(forDuration: 1.5)])
        let action1_2 = SKAction.sequence([_actionPack1, SKAction.wait(forDuration: 1.0)])
        let action1_3 = SKAction.sequence([_actionPack1, SKAction.wait(forDuration: 0.75)])
        let action1_4 = SKAction.sequence([_actionPack1, SKAction.wait(forDuration: 0.5)])
        
        var item_velocity = CGVector(dx: 300, dy: 0)
        let _actionPack2 = SKAction.run({
            let item = PowerUpNode(type: .UPGRADE)
            item.randomPower()
            item.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            item.zPosition = Constants.Z_INDEX_ITEM
            
            let x = Double(item_velocity.dx)
            let y = Double(item_velocity.dy)
            let a = M_PI/6
            item_velocity.dx = CGFloat(x * cos(a) - y * sin(a))
            item_velocity.dy = CGFloat(x * sin(a) + y * cos(a))
            
            item.physicsBody!.velocity = item_velocity
            item.showUp()
            self.addChild(item)
        })
        let action2_1 = SKAction.sequence([_actionPack2, SKAction.wait(forDuration: 0.5)])
        let action2_2 = SKAction.sequence([_actionPack2, SKAction.wait(forDuration: 0.3)])
        let action2_3 = SKAction.sequence([_actionPack2, SKAction.wait(forDuration: 0.1)])
        
        self.run(SKAction.sequence([
            SKAction.repeat(action1_1, count: 10),
            SKAction.repeat(action1_2, count: 10),
            SKAction.repeat(action1_3, count: 10),
            SKAction.repeat(action1_4, count: 10),
            SKAction.repeat(action2_1, count: 40),
            SKAction.repeat(action2_2, count: 50),
            SKAction.repeat(action2_3, count: 200)
        ]), withKey: Constants.GENERATE_ITEM_KEY)
    }
    
    
    fileprivate func _setupCategory() {
        for side in Animal.Side.allSides {
            categories[side.index] = CategoryNode(side: side)
            let y = categories[side.index].size.height / 2
            var x = categories[side.index].size.width / 2
            x = (side == .LEFT) ? x : frame.width - x
            categories[side.index].position = CGPoint(x: x, y: y)
            categories[side.index].zPosition = Constants.Z_INDEX_CATEGORY
            self.addChild(categories[side.index])
        }
    }
    
    fileprivate func _hideUncessaryNode() {
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
                for j in 0..<2 {
                    arrows[i][j].removeFromParent()
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        Constants.LAUNCH_X = [self.frame.minX, self.frame.maxX]
        
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
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
    
    fileprivate func goatDidCollideWithAnother(_ goats: [AnimalNode]) {
        for goat in goats {
            if goat.animal.status == .DEPLOYED {
                goat.updateAnimalStatus(.BUMPING)
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
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
    
    @objc internal func tapHandler(_ recognizer: UITapGestureRecognizer) {
        let location = self.convertPoint(fromView: recognizer.location(in: recognizer.view))
        let node = self.atPoint(location)
        
        if node.name == LoadingNode.Constants.IDENTIFIER {
            _selectButton(node as! LoadingNode)
            
        } else if node.name == ArrowNode.Constants.IDENTIFIER {
            _deploy(node as! ArrowNode)
            
        }  else if node is MenuButtonNode {
            (node as! MenuButtonNode).clicked()
        }
    }
    
    @objc internal func panHandler(_ recognizer: UIPanGestureRecognizer) {
        var end = recognizer.location(in: recognizer.view)
        var translation = recognizer.translation(in: recognizer.view!)
        var start = CGPoint(x: end.x - translation.x, y: end.y - translation.y)
        
        start = self.convertPoint(fromView: start)
        end = self.convertPoint(fromView: end)
        
        var node = self.atPoint(start)
        if recognizer.state == .began {
            if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                var itemNode = node as! PowerUpNode
                var side = itemNode.side
                var index = categories[side.index].items.index(of: itemNode)
                gameModel.categorySelectedItem[side.index] = index
                itemNode.updateItemStatus(.SELECTED)
            }
            
        } else if recognizer.state == .changed {
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                if start != end {
                    node.position = end
                    recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
                }
                
            } else if node.name == PowerUpNode.Constants.IDENTIFIER_STORED {
                Animation.draggingPowerUp((node as! PowerUpNode).powerUpItem.powerType, scene: self, position: end)
            }
            
        } else if recognizer.state == .ended {
            if node.name == PowerUpNode.Constants.IDENTIFIER {
                var speed = self.convertPoint(fromView: recognizer.velocity(in: recognizer.view))
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
    
    fileprivate func _isItemValid(_ itemNode: PowerUpNode, animalNode: AnimalNode) -> Bool {
        if itemNode.powerUpItem.powerType == .FREEZE {
            return true
        }
        return (itemNode.side == animalNode.animal.side) == PowerUp.PowerType.targetFriendly(itemNode.powerUpItem.powerType)
    }
    
    fileprivate func _isAnimalRemoved(_ node: AnimalNode) -> Bool {
        if node.isPaused {
            return true
        }
        if let body = node.physicsBody {
            if !body.isDynamic {
                return true
            }
        } else {
            return true
        }
        return false
    }
        
    fileprivate func _findNearestAnimal(_ itemNode: PowerUpNode, effect: SKEmitterNode) -> AnimalNode? {
        var result: AnimalNode?
        for node in self.children {
            if var animalNode = node as? AnimalNode {
                var range = CGPoint(x: effect.particlePositionRange.dx, y: effect.particlePositionRange.dy)
                var size = range * 2.0
                var origin = effect.position - range
                var effectFrame = CGRect(origin: origin, size: CGSize(width: size.x, height: size.y))
                
                var isOver = effectFrame.intersection(animalNode.frame).size != CGSize.zero
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
        
    fileprivate func _applyPowerUp(_ item: PowerUpNode, target: AnimalNode) {
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
    
    override func update(_ currentTime: TimeInterval) {
        frameCount = (frameCount + 1) % 45
        for i in self.children {
            let node = i 
            
            if node.name == AnimalNode.Constants.IDENTIFIER {
                let sideIndex = (node as! AnimalNode).animal.side.index
                let x = node.position.x
                if x < GAME_VIEW_LEFT_BOUNDARY || x > GAME_VIEW_RIGHT_BOUNDARY {
                    let point = (node as! AnimalNode).animal.getPoint()
                    let side = (node as! AnimalNode).animal.side
                    if (x < GAME_VIEW_LEFT_BOUNDARY && side == .RIGHT) || (x > GAME_VIEW_RIGHT_BOUNDARY && side == .LEFT) {
                        scoreNode[sideIndex].score += point
                    }
                    node.removeFromParent()
                } else {
                    let factor: CGFloat = (sideIndex == 0) ? 1 : -1
                    if (node as! AnimalNode).physicsBody != nil {
                        (node as! AnimalNode).physicsBody!.velocity.dx = AnimalNode.Constants.VELOCITY * factor
                    }
                }
            }
        }
        
        if let AI = gameModel.AI {
            let launchPair = AI.autoLaunch()
            if launchPair.0 > -1 && frameCount == 1{
                self.launchSheepForAI(launchPair.0, trackIndex: launchPair.1)
            }
        }
    }
        
    fileprivate func _continueGame() {
        pauseScreen.removeFromParent()
        gameOverScreen.removeFromParent()
        self.view!.isPaused = false
        self.isPaused = false
    }
    
    fileprivate func _backToHome() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.BACK_HOME_MESS), object: nil)
    }
    
    fileprivate func _pauseGame() {
        _moveToScreen(pauseScreen)
    }
    
    fileprivate func _gameOver() {
        gameOverScreen.update()
        _moveToScreen(gameOverScreen)
    }
    
    fileprivate func _restartGame() {
        _continueGame()
        
        for node in self.children {
            if node is AnimalNode || node is PowerUpNode || node is LoadingNode || node is SKLabelNode {
                node.removeFromParent()
            }
        }
        
        for side in Animal.Side.allSides {
            for node in categories[side.index].items {
                categories[side.index].remove(node)
            }
        }
        
        self.removeAction(forKey: Constants.GENERATE_ITEM_KEY)
        
        setupGame(gameModel.gameMode)
        
        _setupTiming()
        _setupScore()
        _setupItem()
        if gameModel.gameMode != .ITEM_MODE {
            _setupLoadingButton()
        }
    }
    
    fileprivate func _moveToScreen(_ screen: SKSpriteNode) {
        self.run(SKAction.run({
            self.addChild(screen)
        }), completion: {
            self.view!.isPaused = true
            self.isPaused = true
        })
    }
    
    fileprivate func _applyVelocity(_ node: SKNode, x: CGFloat, y: CGFloat) {
        let le = CGPoint(x: x, y: y).getDistance()
        
        node.physicsBody!.isDynamic = true
        if le != 0 {
            node.physicsBody!.velocity = CGVector(dx: x / le * Constants.ITEM_VELOCITY, dy: y / le * Constants.ITEM_VELOCITY)
        }
    }
    
    fileprivate func _deploy(_ arrow: ArrowNode) {
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
        sprite.zPosition = zIndex + 1
        self.addChild(sprite)
        
        var button = loadingButton[side.index][selectedButton]
        button.change()
        button.fadeAnimation(side, index: selectedButton)
        updateLoadingBorder(arrow.side)
    }
    
    
    fileprivate func _selectButton(_ node: LoadingNode) {
        gameModel.selectForSide(node.animal.side, index: node.index)
        updateLoadingBorder(node.animal.side)
    }
    
    fileprivate func updateLoadingBorder(_ side: Animal.Side) {
        if side == .RIGHT && gameModel.gameMode == .SINGLE_PLAYER {
            return
        }
        if gameModel.gameMode == .ITEM_MODE {
            return
        }
        var j = gameModel.selectedGoat[Animal.Side.allSides.index(of: side)!]
        for z in 0..<3 {
            if gameModel.isCattleReady(side, index: (j+z) % 3) {
                gameModel.selectForSide(side, index: (j+z) % 3)
                break
            }
        }
        
        var node = loadingBorder[side.index][gameModel.selectedGoat[side.index]]
        if node.alpha == 0 {
            for z in 0..<3 {
                loadingBorder[side.index][z].alpha = 0
            }
            node.fadeIn()
        }
    }
    
    fileprivate func launchSheepForAI(_ readyIndex: Int, trackIndex: Int) {
        gameModel.selectForSide(.RIGHT, index: readyIndex)
        _deploy(arrows[trackIndex][1])
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == _tapGesture {
            return true
        }
        
        var x = Double(touch.location(in: self.view).x) / Double(self.view!.frame.width)
        var y = Double(touch.location(in: self.view).y) / Double(self.view!.frame.height)
        x *= Double(Constants.PAN_GESTURE_WIDTH)
        y *= Double(Constants.PAN_GESTURE_HEIGHT)
        x = min(floor(x), Double(Constants.PAN_GESTURE_WIDTH - 1))
        y = min(floor(y), Double(Constants.PAN_GESTURE_HEIGHT - 1))
        return gestureRecognizer == _panGesture[Int(x)][Int(y)]
    }
}
