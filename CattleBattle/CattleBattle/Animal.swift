//
//  Animal.swift
//  CattleBattle
//
//  Created by Ding Ming on 27/3/15.
//  Copyright (c) 2015 Ding Ming. All rights deployed.
//

import SpriteKit

class Animal {
    
    enum Color: String {
        case WHITE = "white"
        case BLACK = "black"
        
        internal static let allColors = [WHITE, BLACK]
    }
    
    enum Size: String {
        case TINY = "1"
        case SMALL = "2"
        case MEDIUM = "3"
        case LARGE = "4"
        case HUGE = "5"
        
        internal static let allSizes = [TINY, SMALL, MEDIUM, LARGE, HUGE]
    }
    
    enum Status: String {
        case DEPLOYED = "goat"
        case ENGAGED = "engaged"
        case BUTTON = "button"

        internal static let allStatuses = [DEPLOYED, ENGAGED, BUTTON]
    }
    
    struct Constants {
        internal static var goatTextures = Color.allColors.map() { (color) -> [SKTexture] in
            return Size.allSizes.map() { (size) -> SKTexture in
                return SKTexture(imageNamed: Animal.getImageName(color, size))
            }
        }
        internal static var buttonTextures = Color.allColors.map() { (color) -> [SKTexture] in
            return Size.allSizes.map() { (size) -> SKTexture in
                return SKTexture(imageNamed: Animal.getImageName(color, size))
            }
        }
    }
    
    internal var color: Color
    internal var size: Size
    internal var status: Status
    
    func getImageFileName() -> String {
        return status.rawValue + "-" + color.rawValue + "-" + size.rawValue + ".png"
    }
    
    func getTexture() -> SKTexture {
        if status == .BUTTON {
            return Constants.buttonTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
        } else {
            return Constants.goatTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
        }
    }
    
    class func getImageName(color: Color, _ size: Size) -> String {
        return "goat-" + color.rawValue + "-" + size.rawValue + ".png"
    }
    
    /*To be removed----------------------------------------------------*/
    func getImageName() -> String {
        return Animal.getImageName(color, size)
    }
    /*-----------------------------------------------------------------*/
    
    init(color: Color, size: Size) {
        self.color = color
        self.size = size
        self.status = .DEPLOYED
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

