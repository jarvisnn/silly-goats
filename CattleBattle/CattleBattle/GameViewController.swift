//
//  GameViewController.swift
//  CattleBattle
//
//  Created by Ding Ming on 25/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    @IBOutlet var RGR: UIRotationGestureRecognizer!
    
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var RightButtonView: UIView!
    
    @IBOutlet weak var LeftButtonView: UIView!
    var sheepScene : GameScene!
    var sheepView : UIView!
    @IBAction func rightLaunch(sender: UIButton) {
        print ("dad")
        var button = sender as UIButton
        if self.sheepScene != nil {
            switch button.tag {
            case 1 : self.sheepScene.addObject(CGPoint(x: 840, y: 500), direction: -1)
            case 2 : self.sheepScene.addObject(CGPoint(x: 840, y: 420), direction: -1)
            case 3 : self.sheepScene.addObject(CGPoint(x: 840, y: 340), direction: -1)
            case 4 : self.sheepScene.addObject(CGPoint(x: 840, y: 260), direction: -1)
            case 5 : self.sheepScene.addObject(CGPoint(x: 840, y: 180), direction: -1)
            default : print("NO LOL")
            }
//            self.sheepScene.addObject(button.center, direction: -1)
            print(button.center)
        }
    }
    
    @IBAction func leftLaunch(sender: UIButton) {
        var button = sender as UIButton
        if self.sheepScene != nil {
            switch button.tag {
            case 1 : self.sheepScene.addObject(CGPoint(x: 110, y: 500), direction: 1)
            case 2 : self.sheepScene.addObject(CGPoint(x: 110, y: 420), direction: 1)
            case 3 : self.sheepScene.addObject(CGPoint(x: 110, y: 340), direction: 1)
            case 4 : self.sheepScene.addObject(CGPoint(x: 110, y: 260), direction: 1)
            case 5 : self.sheepScene.addObject(CGPoint(x: 110, y: 180), direction: -1)
            default : print("NO LOL")
            }
        }
    }
    
    
    
    var lastRotation = CGFloat(0.0)
    @IBAction func rotated(sender: UIRotationGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.Ended) {
            lastRotation = 0.0;
            return
        }
        
        var rotation = 0.0 - (sender.rotation - lastRotation)
        var trans = CGAffineTransformMakeRotation(rotation)
        
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initView()
        self.sheepView = SKView(frame: CGRectMake(0, 0, self.view!.frame.width, self.view!.frame.height))

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.sheepView as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            self.sheepScene = scene
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
//             Set the scale mode to scale to fit the window 
            scene.scaleMode = .AspectFill

            self.view!.addSubview(skView)
            self.view!.addSubview(trackView)
            self.view!.bringSubviewToFront(skView)
            self.view!.bringSubviewToFront(RightButtonView)
            self.view!.bringSubviewToFront(LeftButtonView)
            
            skView.allowsTransparency = true
            scene.backgroundColor = UIColor.clearColor()
            skView.presentScene(scene)
            
           
            
            
            
        }
    }
    
    func initView() {
        self.RightButtonView.backgroundColor = UIColor.clearColor()
        self.LeftButtonView.backgroundColor = UIColor.clearColor()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
//
//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.All.rawValue)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
