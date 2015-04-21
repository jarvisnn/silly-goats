//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class GameModel {
    enum GameMode: String {
        case SINGLE_PLAYER = "single_player"
        case MULTIPLAYER = "multiplayer"
        case ITEM_MODE = "item_mode"
    }
    
    internal var AI: EasyAI?
    internal var gameMode: GameMode

    struct Constants {
        internal static let NUMBER_OF_BRIDGES = 5
        internal static let NUMBER_OF_RESERVED = 3
        
        internal static var gameModel: GameModel!
    }
    
    internal var readyList: [[Bool]] = Animal.Side.allSides.map { (_) -> [Bool] in
        map(0..<Constants.NUMBER_OF_RESERVED, { (_) -> Bool in
            return true
        })
    }
    
    internal var selectedGoat = [0, 0]
    internal var categorySelectedItem: [Int?] = [nil, nil]
    internal var score = [0, 0]
    
    init(gameMode: GameMode) {
        self.gameMode = gameMode
        if gameMode == .SINGLE_PLAYER {
            self.AI = EasyAI()
        }
        Constants.gameModel = self
    }

    internal func isCattleReady(side: Animal.Side, index: Int) -> Bool {
        return readyList[side.index][index]
    }
    
    internal func selectForSide(side: Animal.Side, index: Int) -> Bool {
        if isCattleReady(side, index: index) {
            selectedGoat[side.index] = index
            return true
        }
        return false
    }
    
    internal func setCattleStatus(side: Animal.Side, index: Int, status: Bool) {
        readyList[side.index][index] = status
    }
    
}