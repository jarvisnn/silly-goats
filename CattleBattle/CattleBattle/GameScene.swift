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
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
       
        for touch in (touches as! Set<UITouch>) {
            var node = self.nodeAtPoint(touch.locationInNode(self))
           
            if node.name != nil && node.name! == READY_BUTTON_NAME {
                self.receiveReadyButtonClick(node)
                
            }
            
          }
    }
    
   
   
    override func update(currentTime: CFTimeInterval) {
        for i in self.children {
            var node = i as! SKSpriteNode
            if node.name != nil && node.name == "leftRunning" {
                var runningNode = node as! StarNode
                var animal = Animal(type: runningNode.animalType)
                runningNode.physicsBody!.velocity.dx = -300 * animal.getImageMass() / 10
            }
            if node.name != nil && node.name == "rightRunning" {
                var runningNode = node as! StarNode
                var animal = Animal(type: runningNode.animalType)
                runningNode.physicsBody!.velocity.dx = 300 * animal.getImageMass() / 10
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
        
        self.gameModel.setReady(side, index: index)
        
        return true
    }
    
    func setGameModel (model : GameModel) {
        self.gameModel = model
    }
    
    func replaceReadyButton(side : GameModel.side, index: Int) {
        if side == .left {
            var tmpNode = self.leftReadyButton[index] as! LoadingCattleNode
            tmpNode.generateRandomAnimal()
        } else if side == .right {
            var tmpNode = self.rightReadyButton[index] as! LoadingCattleNode
            tmpNode.generateRandomAnimal()
        }
    }
    
}
