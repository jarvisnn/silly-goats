//
//  Animal.swift
//  CattleBattle
//
//  Created by Ding Ming on 27/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import UIKit

class Animal {
    
    enum Size: String {
        case TINY = "1"
        case SMALL = "2"
        case MEDIUM = "3"
        case LARGE = "4"
        case HUGE = "5"
    }
    
    enum Color: String {
        case WHITE = "white"
        case BLACK = "black"
    }
    
    var color: Color
    var size: Size
    
    func getImageName() -> String {
        return "goat-" + color.rawValue + "-" + size.rawValue + ".png"
    }
    
    init(color: Color, size: Size) {
        self.color = color
        self.size = size
    }
    
    let scale1x : CGFloat = 0.030
    let scale1y : CGFloat = 0.030
    let scale2x : CGFloat = 0.025
    let scale2y : CGFloat = 0.025
    let scale3x : CGFloat = 0.020
    let scale3y : CGFloat = 0.020
    let scale4x : CGFloat = 0.015
    let scale4y : CGFloat = 0.015
    
    let mass1 : CGFloat = 7
    let mass2 : CGFloat = 5
    let mass3 : CGFloat = 3
    let mass4 : CGFloat = 1
    func getImageScale () -> (CGFloat, CGFloat) {
        return (scale1x, scale1y)
    }
    
    func getImageMass () -> CGFloat {
        return mass1
    }
    
}