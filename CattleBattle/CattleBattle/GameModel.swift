//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class GameModel {
    struct Constants {
        internal static let NUMBER_OF_BRIDGES = 5
        internal static let NUMBER_OF_RESERVED = 3
        
        internal static var readyList: [[Bool]] = Side.allSides.map { (_) -> [Bool] in
            map(0..<NUMBER_OF_RESERVED, { (_) -> Bool in
                return true
            })
        }
        
        internal static var selected = [0, 0]
    }
    
    
    enum Side: String {
        case LEFT = "left"
        case RIGHT = "right"
        
        internal static var allSides = [LEFT, RIGHT]
        var index: Int {
            return self == .LEFT ? 0 : 1
        }
    }
    
    // to check whether a certain cattle is ready for launch
    class func isCattleReady(side: GameModel.Side, index: Int) -> Bool {
        return Constants.readyList[side.index][index]
    }
    
    class func selectForSide(side: GameModel.Side, index: Int) -> Bool {
        if isCattleReady(side, index: index) {
            Constants.selected[side.index] = index
            return true
        }
        return false
    }
    
    // to set the status of ready cattle
    class func setCattleStatus(side : GameModel.Side, index : Int, status : Bool ) {
        Constants.readyList[side.index][index] = status
    }
    
    
    class func generateRandomAnimal() -> Animal.Size {
        var generatingType : Animal.Size
        var rand = Double(Float(arc4random()) / Float(UINT32_MAX))
        if rand < 0.2 {
            generatingType = .TINY
        } else if rand < 0.4 {
            generatingType = .SMALL
        } else if rand < 0.6 {
            generatingType = .MEDIUM
        } else if rand < 0.8 {
            generatingType = .LARGE
        } else {
            generatingType = .HUGE
        }
        return generatingType
    }
}