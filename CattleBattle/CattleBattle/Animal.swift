//
//  Animal.swift
//  CattleBattle
//
//  Created by Ding Ming on 27/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

class Animal {
    
    
    let RedStarName = "redStar.png"
    let GreenStarName = "greenStar.png"
    let PurpleStarName = "purpleStar.png"
    let YellowStarName = "yellowStar.png"
    let ErrorName = ""
    
    
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
}