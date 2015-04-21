//
//  PauseScene.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/20/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class PauseScene: SKSpriteNode {
    
    private var _continueFunc: (() -> ())
    private var _restartFunc: (() -> ())
    private var _homeFunc: (() -> ())
    private var _pauseFunc: (() -> ())
    
    init(size: CGSize, pauseFunc: (() -> ()), continueFunc: (() -> ()), restartFunc: (() -> ()), homeFunc: (() -> ())) {
        self._pauseFunc = pauseFunc
        self._continueFunc = continueFunc
        self._restartFunc = restartFunc
        self._homeFunc = homeFunc

        super.init(texture: nil, color: UIColor(white: 0, alpha: 0.4), size: size)
        
        var continueButton = MenuButtonNode(buttonType: .CONTINUE, scale: 1)
        var homeButton = MenuButtonNode(buttonType: .HOME, scale: 1)
        var restartButton = MenuButtonNode(buttonType: .RESTART, scale: 1)
        
        restartButton.position = CGPointMake(-100, 0)
        continueButton.position = CGPointMake(0, 0)
        homeButton.position = CGPointMake(100, 0)
        
        self.addChild(restartButton)
        self.addChild(continueButton)
        self.addChild(homeButton)

    }
    
    internal func buttonClicked(buttonType: MenuButton.ButtonType) {
        if buttonType == .PAUSE {
            _pauseFunc()
        } else if buttonType == .CONTINUE {
            _continueFunc()
        } else if buttonType == .HOME {
            _homeFunc()
        } else if buttonType == .RESTART {
            _restartFunc()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

