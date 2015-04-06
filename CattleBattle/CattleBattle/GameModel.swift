//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class GameModel {
<<<<<<< HEAD
    
    let NUMBER_OF_READY_CATTLE = 3
    
    var LeftReadyList : [Bool] = []
    var LeftIsLoading : [Bool] = []
    var rightReadyList : [Bool] = []
    var RightIsLoading : [Bool] = []
    var leftSelectedCattleIndex = -1
    var rightSelectedCattleIndex = -1
    var leftScore : Int
    var rightScore : Int
    
    enum side {
        case left, right
    }
    
    init () {
        for i in 0...NUMBER_OF_READY_CATTLE-1  {
            LeftReadyList.append(true)
            LeftIsLoading.append(false)
            rightReadyList.append(true)
            LeftIsLoading.append(false)
            
=======
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
>>>>>>> fe07db184a2d43ca386df9878fff7aa033ef7276
        }
        leftScore = 0
        rightScore = 0
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
    
    // this function is to calculate incremental score for both players base on the input on each line
    // the input is the x-axis value of the hitting point of both side
    // if a line is on battle, leftX = rightX
    // if a line is not on battle but both side have sheeps. leftX > 0 rightX > 0
    // if a line is only with left sheep. leftX > 0, rightX = 0
    // if a line is empty, leftX = rightX = 0
    func calculateScore(leftX : CGFloat, rightX : CGFloat) {
        let BridgeLeftEndX = 40
        let BridgeRightEndX = 1600
        let SegmentNumber = 5
        let ScoreMultiplier = 2
        let SegmentLength : CGFloat = (CGFloat)(BridgeRightEndX - BridgeLeftEndX) / (CGFloat)(SegmentNumber)
        
        if leftX == 0 && rightX == 0 {
            return
        }
        if rightX > 0 {
            var rightSegmentOccupied = 0
            var tmp = rightX
            while tmp > 0 {
                tmp -= SegmentLength
                rightSegmentOccupied += 1
            }
            rightScore += rightSegmentOccupied * ScoreMultiplier
            return
        }
        if leftX > 0 {
            var leftSegmentOccupied = 0
            var tmp = leftX
            while tmp > 0 {
                tmp -= SegmentLength
                leftSegmentOccupied += 1
            }
            leftScore += leftSegmentOccupied * ScoreMultiplier
        }
    }
}