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

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.sheepView = SKView(frame: CGRectMake(0, 0, self.view!.frame.width, self.view!.frame.height))

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.sheepView as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            self.sheepScene = scene
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
//             Set the scale mode to scale to fit the window 
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

}
