//
//  GameSelectionViewController.swift
//  CattleBattle
//
//  Created by Jarvis on 4/18/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit
import SpriteKit

class GameSelectionViewController: UIViewController {
    
    private var gameMode: GameModel.GameMode!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "moveToGameArea") {
            var gameplay = segue.destinationViewController as! GameViewController;
            gameplay.setupGame(gameMode)
        }
    }
    
    @IBAction func singlePlayerModeSelected(sender: AnyObject) {
        gameMode = .SINGLE_PLAYER
        performSegueWithIdentifier("moveToGameArea", sender: nil)
    }
    
    @IBAction func multiplayerModeSelected(sender: AnyObject) {
        gameMode = .MULTIPLAYER
        performSegueWithIdentifier("moveToGameArea", sender: nil)
    }
    
    @IBAction func itemModeSelected(sender: AnyObject) {
        gameMode = .ITEM_MODE
        performSegueWithIdentifier("moveToGameArea", sender: nil)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}