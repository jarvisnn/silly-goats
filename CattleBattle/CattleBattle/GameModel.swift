//
//  GameModel.swift
//  CattleBattle
//
//  Created by Ding Ming on 26/3/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//


class GameModel {
    
    let NUMBER_OF_READY_CATTLE = 3
    
    var leftReadyList : [Bool] = []
    var leftIsLoading : [Bool] = []
    var rightReadyList : [Bool] = []
    var rightIsLoading : [Bool] = []
    var leftSelectedCattleIndex = -1
    var rightSelectedCattleIndex = -1
    
    enum Side: String {
        case LEFT = "left"
        case RIGHT = "right"
        
        internal static var allSides = [LEFT, RIGHT]
        var index: Int {
            return self == .LEFT ? 0 : 1
        }
    }
    
    init () {
        for i in 0...NUMBER_OF_READY_CATTLE-1  {
            leftReadyList.append(true)
            leftIsLoading.append(false)
            rightReadyList.append(true)
            leftIsLoading.append(false)
        }
    }
    
    // to check whether a certain cattle is ready for launch
    func isCattleReady(side : GameModel.Side, index : Int) -> Bool {
        if side == .LEFT {
            return self.leftReadyList[index]
        } else {
            return self.rightReadyList[index]
        }
    }
    
    func setReady(side : GameModel.Side, index : Int) -> Bool {
        if isCattleReady(side, index: index) {
            if side == .LEFT {
                self.leftSelectedCattleIndex = index
            } else if side == .RIGHT {
                self.rightSelectedCattleIndex = index
            }
            
            return true
        }
        return false
    }
    
    // to launch a cattle, reload next cattle
    func launchCattle(side : GameModel.Side, index : Int) {
        if isCattleReady(side, index: index) == false {
            return
        }
        self.setCattleStatus(side, index: index, status: false)
        
//        self.reloadCattle(side , index : index)
    }
    
    // to set the status of ready cattle
    func setCattleStatus(side : GameModel.Side, index : Int, status : Bool ) {
        if side == .LEFT {
            self.leftReadyList[index] = status
        } else {
            self.rightReadyList[index] = status
        }
    }
    
    // to reload cattle
    func reloadCattle(side : GameModel.Side, index : Int) {
        self.setCattleStatus(side, index: index, status: true)
    }
    
    func clearLeftReadyIndex() {
        self.leftSelectedCattleIndex = -1
    }
    
    func clearRightReadyIndex () {
        self.rightSelectedCattleIndex = -1
    }
}