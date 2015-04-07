//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class GameModel {

    
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
        }
        leftScore = 0
        rightScore = 0
    }
    
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
    internal class func isCattleReady(side: GameModel.Side, index: Int) -> Bool {
        return Constants.readyList[side.index][index]
    }
    
    internal class func selectForSide(side: GameModel.Side, index: Int) -> Bool {
        if isCattleReady(side, index: index) {
            Constants.selected[side.index] = index
            return true
        }
        return false
    }
    
    // to set the status of ready cattle
    internal class func setCattleStatus(side : GameModel.Side, index : Int, status : Bool ) {
        Constants.readyList[side.index][index] = status
    }
    
    
    internal class func generateRandomAnimal() -> Animal.Size {
        var total = Animal.Size.probability.reduce(0, combine: +)
        var rand = Double(arc4random()) / Double(UINT32_MAX) * Double(total)
        for i in 0..<Animal.Size.allSizes.count {
            var prob = Double(Animal.Size.probability[i])
            if rand < prob {
                return Animal.Size.allSizes[i]
            } else {
                rand -= prob
            }
        }
        return .TINY
    }
    
    // this function is to calculate incremental score for both players base on the input on each line
    // the input is the x-axis value of the hitting point of both side
    // if a line is on battle, leftX = rightX
    // if a line is not on battle but both side have sheeps. leftX > 0 rightX > 0
    // if a line is only with left sheep. leftX > 0, rightX = 0
    // if a line is empty, leftX = rightX = 0
    internal func calculateScore(leftX : CGFloat, rightX : CGFloat) {
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