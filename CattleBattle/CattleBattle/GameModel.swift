//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//


class GameModel {
    
    let NUMBER_OF_READY_CATTLE = 3
    
    var LeftReadyList : [Bool] = []
    var LeftIsLoading : [Bool] = []
    var rightReadyList : [Bool] = []
    var RightIsLoading : [Bool] = []
    var leftSelectedCattleIndex = -1
    var rightSelectedCattleIndex = -1
    
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
}