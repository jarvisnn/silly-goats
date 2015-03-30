//
//  GameScene.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameModel : GameModel = GameModel() // should be constant. not implemented due to non-nullable class GameModel
    var leftPlayerScoreNode = SKLabelNode()
    var rightPlayerScoreNode  = SKLabelNode()
    let READY_BUTTON_NAME = "READY_BUTTON"
    
    var dir = 1
    var leftReadyButton :[SKNode] = []
    var rightReadyButton : [SKNode] = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Set up the left/right ready button
        for i in 0...2 {
            var node = LoadingCattleNode.loadingCattle(CGPoint(x: 100 + i * 100, y : 650), animalIndex : 1)

            node.name = READY_BUTTON_NAME
            self.addChild(node)
            self.leftReadyButton.append(node)
        }
        
        for i in 0...2 {
            var node = LoadingCattleNode.loadingCattle(CGPoint(x: (Int)(self.frame.width) - 100 - i * 100, y : 650), animalIndex : 1)

            node.name = READY_BUTTON_NAME
            self.addChild(node)
            self.rightReadyButton.append(node)
        }
        
        let vsLabel = SKLabelNode(fontNamed:"Chalkduster")
        vsLabel.text = "VS";
        vsLabel.fontSize = 40;
        vsLabel.position = CGPoint(x: 512, y : 650);
        
        self.addChild(vsLabel)
        
        leftPlayerScoreNode = SKLabelNode(fontNamed:"Chalkduster")
        leftPlayerScoreNode.text = "000";
        leftPlayerScoreNode.fontSize = 40;
        leftPlayerScoreNode.position = CGPoint(x: 420, y : 650);
        
        self.addChild(leftPlayerScoreNode)
        
        rightPlayerScoreNode = SKLabelNode(fontNamed:"Chalkduster")
        rightPlayerScoreNode.text = "999";
        rightPlayerScoreNode.fontSize = 40;
        rightPlayerScoreNode.position = CGPoint(x: 604, y : 650);
        
        self.addChild(rightPlayerScoreNode)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch in touches {
            var node = self.nodeAtPoint(touch.locationInNode(self))
           
            if node.name != nil && node.name! == READY_BUTTON_NAME {
                self.receiveReadyButtonClick(node)
                
            }
            
          }
    }
    
   
   
    override func update(currentTime: CFTimeInterval) {

        for i in self.children {
            var node = i as SKNode
            
            if node.name != nil && node.name == "leftRunning" {
                var runningNode = node as StarNode
                var animal = Animal(type: runningNode.animalType)
                runningNode.physicsBody!.velocity.dx = -300 * animal.getImageMass() / 10
                if node.position.x < Constant.GAME_VIEW_LEFT_BOUNDARY || node.position.x > Constant.GAME_VIEW_RIGHT_BOUNDARY {
                    node.removeFromParent()
                }
            }
            if node.name != nil && node.name == "rightRunning" {
                var runningNode = node as StarNode
                var animal = Animal(type: runningNode.animalType)
                runningNode.physicsBody!.velocity.dx = 300 * animal.getImageMass() / 10
                if node.position.x < Constant.GAME_VIEW_LEFT_BOUNDARY || node.position.x > Constant.GAME_VIEW_RIGHT_BOUNDARY  {
                    node.removeFromParent()
                }
            }
        }
    }
    
    func addObject(location : CGPoint, direction : Int, type : Animal.name) {
        let sprite = StarNode.getAnimal(location, direction: direction, type : type)
        self.addChild(sprite)
    }
    
    
    // called when click on ready button, send the click to game model 
    // and check whether animal is ready.
    // return yes when animal is ready, no otherwise.
    func receiveReadyButtonClick(node : SKNode) -> Bool {
        // get the index of node
        var side : GameModel.side = .left
        var index : Int = -1
        for i in 0...2 {
            if self.leftReadyButton[i] == node {
                index = i
            } else if self.rightReadyButton[i] == node {
                index  = i
                side = .right
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
    
    func replaceReadyButton(side : GameModel.side, index: Int) {
        if side == .left {
            var tmpNode = self.leftReadyButton[index] as LoadingCattleNode
            tmpNode.generateRandomAnimal()
            tmpNode.fadeAnimation(self.gameModel, side: side, index: index)
        } else if side == .right {
            var tmpNode = self.rightReadyButton[index] as LoadingCattleNode
            tmpNode.generateRandomAnimal()
            tmpNode.fadeAnimation(self.gameModel, side: side, index: index)
        }
    }
    
}
