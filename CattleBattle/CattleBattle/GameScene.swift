//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    struct Constants {
        private static let NUMBER_OF_BRIDGES = 5
        private static let NUMBER_OF_RESERVED = 3
    }
    
    private let GAME_VIEW_RIGHT_BOUNDARY : CGFloat = 2048
    private let GAME_VIEW_LEFT_BOUNDARY : CGFloat = -1024
    private let LABEL_FONT_NAME = "Chalkduster"
    
    var gameModel: GameModel = GameModel() // should be constant. not implemented due to non-nullable class GameModel
    var leftPlayerScoreNode = SKLabelNode()
    var rightPlayerScoreNode  = SKLabelNode()
    let READY_BUTTON_NAME = "READY_BUTTON"
    
    var dir = 1
    var leftReadyButton: [SKNode] = []
    var rightReadyButton: [SKNode] = []
    
    private let RIGHT_LAUNCH_X : CGFloat = 1024
    private let LEFT_LAUNCH_X : CGFloat = 0
    private let LAUNCH_Y_TOP : CGFloat = 550
    private let LAUNCH_Y_GAP : CGFloat = 100
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Set up the left/right ready button
        for i in 0..<Constants.NUMBER_OF_RESERVED {
            for side in GameModel.Side.allSides {
                var node: LoadingNode
                if side == .LEFT {
                    node = LoadingNode.loadingCattle(CGPoint(x: 50 + i * 80, y : 725), animalIndex : 1, side : .LEFT)
                    self.leftReadyButton.append(node)
                } else {
                    node = LoadingNode.loadingCattle(CGPoint(x: (Int)(self.frame.width) - 50 - i * 80, y : 725), animalIndex : 1, side : .RIGHT)
                    self.rightReadyButton.append(node)
                }
                node.name = READY_BUTTON_NAME

                self.addChild(node)
            }

        }
        
        let vsLabel = SKLabelNode(fontNamed: LABEL_FONT_NAME)
        vsLabel.text = "VS";
        vsLabel.fontSize = 40;
        vsLabel.position = CGPoint(x: 512, y : 650);
        
        self.addChild(vsLabel)
        
        leftPlayerScoreNode = SKLabelNode(fontNamed: LABEL_FONT_NAME)
        leftPlayerScoreNode.text = "000"; //should be changed
        leftPlayerScoreNode.fontSize = 40;
        leftPlayerScoreNode.position = CGPoint(x: 420, y : 710);
        
        self.addChild(leftPlayerScoreNode)
        
        rightPlayerScoreNode = SKLabelNode(fontNamed: LABEL_FONT_NAME)
        rightPlayerScoreNode.text = "999"; //should be changed
        rightPlayerScoreNode.fontSize = 40;
        rightPlayerScoreNode.position = CGPoint(x: 604, y : 710);
        
        self.addChild(rightPlayerScoreNode)
        

        for i in 0..<Constants.NUMBER_OF_BRIDGES {
            var y = (CGFloat)(LAUNCH_Y_TOP - LAUNCH_Y_GAP * CGFloat(i))
            for side in GameModel.Side.allSides {
                var tmpNode = ArrowNode(side: side, index: i)
                if side == .LEFT {
                    tmpNode.position = CGPointMake(60, y)
                } else {
                    tmpNode.position = CGPointMake(self.frame.width - 60, y)
                }
                self.addChild(tmpNode)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch in touches {
            var node = self.nodeAtPoint(touch.locationInNode(self))
           
            if node.name != nil && node.name! == READY_BUTTON_NAME {
                print ("click")
                self.receiveReadyButtonClick(node)
                
            }
            if node.name != nil && node.name! == "arrow" {
                var arrow = node as ArrowNode
                if arrow.side == .LEFT {
                    if self.gameModel.leftSelectedCattleIndex != -1 {
                        var tmpType = (self.leftReadyButton[self.gameModel.leftSelectedCattleIndex] as LoadingNode).currentType
                        if self.gameModel.isCattleReady(.LEFT, index: gameModel.leftSelectedCattleIndex) {
                            var tmp : CGFloat = (CGFloat)(arrow.index)
                            var y = (CGFloat)(LAUNCH_Y_TOP - LAUNCH_Y_GAP * tmp)
                            self.addObject(CGPoint(x: LEFT_LAUNCH_X , y: y), direction: 1, size: tmpType, side : .LEFT)
                            gameModel.launchCattle(.LEFT, index: self.gameModel.leftSelectedCattleIndex)
                            self.replaceReadyButton(.LEFT, index: self.gameModel.leftSelectedCattleIndex)
                            self.gameModel.clearLeftReadyIndex()
                            
                        }
                        
                    }
                } else if arrow.side == .RIGHT {
                    if self.gameModel.rightSelectedCattleIndex != -1 {
                        var tmpType = (self.rightReadyButton[self.gameModel.rightSelectedCattleIndex] as LoadingNode).currentType
                        if self.gameModel.isCattleReady(.RIGHT, index: gameModel.rightSelectedCattleIndex) {
                            var tmp : CGFloat = (CGFloat)(arrow.index)
                            var y = (CGFloat)(LAUNCH_Y_TOP - LAUNCH_Y_GAP * tmp)
                            self.addObject(CGPoint(x: RIGHT_LAUNCH_X , y: y), direction: -1, size: tmpType, side : .RIGHT)
                            gameModel.launchCattle(.RIGHT, index: self.gameModel.rightSelectedCattleIndex)
                            self.replaceReadyButton(.RIGHT, index: self.gameModel.rightSelectedCattleIndex)
                            self.gameModel.clearRightReadyIndex()
                        }
                        
                    }
                }
            }
            
        }
    }
    
   
   
    override func update(currentTime: CFTimeInterval) {
        for i in self.children {
            var node = i as SKNode
            
            if node.name != nil && node.name == "leftRunning" {
                var runningNode = node as AnimalNode
                var animal = Animal(color: Animal.Color.WHITE, size: runningNode.animalSize, status: .DEPLOYED)
                runningNode.physicsBody!.velocity.dx = -300 * animal.getImageMass() / 10
                
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    node.removeFromParent()
                }
            }
            if node.name != nil && node.name == "rightRunning" {
                var runningNode = node as AnimalNode
                var animal = Animal(color: Animal.Color.WHITE, size: runningNode.animalSize, status: .DEPLOYED)
                runningNode.physicsBody!.velocity.dx = 300 * animal.getImageMass() / 10
                
                if node.position.x < GAME_VIEW_LEFT_BOUNDARY  || node.position.x > GAME_VIEW_RIGHT_BOUNDARY {
                    node.removeFromParent()
                }
            }
        }
    }
    
    func addObject(location : CGPoint, direction : Int, size : Animal.Size, side : GameModel.Side) {
        let sprite = AnimalNode.getAnimal(location, direction: direction, size : size, side : side)
        self.addChild(sprite)
    }
    
    
    // called when click on ready button, send the click to game model 
    // and check whether animal is ready.
    // return yes when animal is ready, no otherwise.
    func receiveReadyButtonClick(node : SKNode) -> Bool {
        // get the index of node
        var side : GameModel.Side = .LEFT
        var index : Int = -1
        for i in 0...2 {
            if self.leftReadyButton[i] == node {
                index = i
            } else if self.rightReadyButton[i] == node {
                index  = i
                side = .RIGHT
            }
        }
        if index == -1 {
            println("ERROR: No ready button is clicked")
            return false
        }

        if self.gameModel.isCattleReady(side, index: index) {
            self.gameModel.setReady(side, index: index)
        }
        
        return true
    }
    
    func setGameModel (model : GameModel) {
        self.gameModel = model
    }
    
    func replaceReadyButton(side : GameModel.Side, index: Int) {
        if side == .LEFT {
            var tmpNode = self.leftReadyButton[index] as LoadingNode
            tmpNode.generateRandomAnimal(side)
            tmpNode.fadeAnimation(self.gameModel, side: side, index: index)
        } else if side == .RIGHT {
            var tmpNode = self.rightReadyButton[index] as LoadingNode
            tmpNode.generateRandomAnimal(side)
            tmpNode.fadeAnimation(self.gameModel, side: side, index: index)
        }
    }
    
}
