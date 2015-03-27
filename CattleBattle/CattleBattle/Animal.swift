//
//  Animal.swift
//  CattleBattle
//
//  Created by Ding Ming on 27/3/15.
//  Copyright (c) 2015 Ding Ming. All rights reserved.
//

class Animal {
    enum type {
        case size1, size2, size3
    }
    
    var animalType : type
    
    init() {
        animalType = .size1
    }
    
    
}