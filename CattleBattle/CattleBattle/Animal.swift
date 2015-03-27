//
//  Animal.swift
//  CattleBattle
//
//  Created by Ding Ming on 27/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

import UIKit

class Animal {
    
    
    let RedStarName = "redStar.png"
    let GreenStarName = "greenStar.png"
    let PurpleStarName = "purpleStar.png"
    let YellowStarName = "blueStar.png"
    let ErrorName = ""
    
    let scale1x : CGFloat = 0.030
    let scale1y : CGFloat = 0.040
    let scale2x : CGFloat = 0.025
    let scale2y : CGFloat = 0.040
    let scale3x : CGFloat = 0.020
    let scale3y : CGFloat = 0.040
    let scale4x : CGFloat = 0.015
    let scale4y : CGFloat = 0.040
    
    let mass1 : CGFloat = 4
    let mass2 : CGFloat = 3
    let mass3 : CGFloat = 2
    let mass4 : CGFloat = 1
    enum name {
        case size1, size2, size3, size4, empty
    }
    
    var animalType : name
    
    init(type : name) {
        self.animalType = type
        
    }
    

    
    
    func getImageName () -> String {
        switch self.animalType {
        case .size1: return YellowStarName
        case .size2: return RedStarName
        case .size3: return PurpleStarName
        case .size4: return GreenStarName
        default: return ErrorName
        }
    }
    
    func getImageScale () -> (CGFloat, CGFloat) {
        switch self.animalType {
        case .size1: return (scale1x, scale1y)
        case .size2: return (scale2x, scale2y)
        case .size3: return (scale3x, scale3y)
        case .size4: return (scale4x, scale4y)
        default: return (-1, -1)
        }
    }
    
    func getImageMass () -> CGFloat {
        switch self.animalType {
        case .size1: return mass1
        case .size2: return mass2
        case .size3: return mass3
        case .size4: return mass4
        default: return -1
        }
    }
    
    
}