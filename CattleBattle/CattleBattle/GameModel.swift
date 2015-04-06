//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
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
    
    // to check whether a certain cattle is ready for launch
    func isCattleReady(side : GameModel.side, index : Int) -> Bool {
        if side == .left {
            return self.LeftReadyList[index]
        } else {
            return self.rightReadyList[index]
        }
    }
    
    func setReady(side : GameModel.side, index : Int) -> Bool {
        if isCattleReady(side, index: index) {
            if side == .left {
                self.leftSelectedCattleIndex = index
            } else if side == .right {
                self.rightSelectedCattleIndex = index
            }
            
            return true
        }
        return false
    }
    
    // to launch a cattle, reload next cattle
    func launchCattle(side : GameModel.side, index : Int) {
        if isCattleReady(side, index: index) == false {
            return
        }
        self.setCattleStatus(side, index: index, status: false)
        
//        self.reloadCattle(side , index : index)
    }
    
    // to set the status of ready cattle
    func setCattleStatus(side : GameModel.side, index : Int, status : Bool ) {
        if side == .left {
            self.LeftReadyList[index] = status
        } else {
            self.rightReadyList[index] = status
        }
    }
    
    // to reload cattle
    func reloadCattle(side : GameModel.side, index : Int) {
        self.setCattleStatus(side, index: index, status: true)
    }
    
    func clearLeftReadyIndex() {
        self.leftSelectedCattleIndex = -1
    }
    
    func clearRightReadyIndex () {
        self.rightSelectedCattleIndex = -1
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