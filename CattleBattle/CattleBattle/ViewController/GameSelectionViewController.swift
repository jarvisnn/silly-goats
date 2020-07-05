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
    
    fileprivate var gameMode: GameModel.GameMode!

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "moveToGameArea") {
            let gameplay = segue.destination as! GameViewController;
            gameplay.setupGame(gameMode)
        }
    }
    
    @IBAction func singlePlayerModeSelected(_ sender: AnyObject) {
        gameMode = .SINGLE_PLAYER
        performSegue(withIdentifier: "moveToGameArea", sender: nil)
    }
    
    @IBAction func multiplayerModeSelected(_ sender: AnyObject) {
        gameMode = .MULTIPLAYER
        performSegue(withIdentifier: "moveToGameArea", sender: nil)
    }
    
    @IBAction func itemModeSelected(_ sender: AnyObject) {
        gameMode = .ITEM_MODE
        performSegue(withIdentifier: "moveToGameArea", sender: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
