//
//  GameViewController.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    private let RIGHT_LAUNCH_X : CGFloat = 1024
    private let LEFT_LAUNCH_X : CGFloat = 0
    private let LAUNCH_Y_TOP : CGFloat = 500
    private let LAUNCH_Y_GAP : CGFloat = 80
    
    let gameModel = GameModel()

   
    var sheepScene : GameScene!
    var sheepView : UIView!
    var gameMode: GameScene.GameMode!
    
    internal func setupGame(mode: GameScene.GameMode) {
        gameMode = mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backToPreviousScene:", name: GameScene.Constants.BACK_HOME_MESS, object: nil)

        self.sheepView = SKView(frame: CGRectMake(0, 0, self.view!.frame.width, self.view!.frame.height))

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            scene.setupGame(gameMode)
            let skView = self.sheepView as! SKView
            self.sheepScene = scene
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .AspectFill

            self.view!.addSubview(skView)
            self.view!.bringSubviewToFront(skView)
            
            skView.allowsTransparency = true
            scene.backgroundColor = UIColor.clearColor()
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    func backToPreviousScene(sender: NSNotification) {
        navigationController?.popViewControllerAnimated(true)
    }
}
