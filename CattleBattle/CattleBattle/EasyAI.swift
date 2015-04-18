//
//  EasyAI.swift
//  CattleBattle
//
//  Created by Ding Ming on 16/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit


class EasyAI {
    
    internal var side: Animal.Side
    
    
    init() {
        self.side = .RIGHT
    }
    
    func isExistReadyGoat() -> Int {
        for i in 0...2 {
            if GameModel.Constants.gameModel.isCattleReady(side, index: i) {
                return i
            }
        }
        return -1
    }
    
    
    
    func calcutateTrackToLaunch() -> Int {
        // Easy AI use random way to select the track
        var rand: CGFloat = (CGFloat)(Float(arc4random()) / Float(UINT32_MAX))
        return (Int)(rand*5)
    }
    
    func autoLaunch() -> (Int, Int) {
        if isExistReadyGoat() != -1 {
            return (isExistReadyGoat(), calcutateTrackToLaunch())
        }
        return (-1, -1)
    }
}