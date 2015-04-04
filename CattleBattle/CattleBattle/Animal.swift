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
        case DEPLOYED = "deployed"
        case ENGAGED = "engaged"
        case BUTTON = "button"

        internal static let allStatuses = [DEPLOYED, ENGAGED, BUTTON]
    }
    
    struct Constants {
        internal static let GOAT_KEYWORD = "goat"
        internal static let IMAGE_EXT = ".png"
        
        internal static var goatTextures = Color.allColors.map() { (color) -> [SKTexture] in
            return Size.allSizes.map() { (size) -> SKTexture in
                return SKTexture(imageNamed: Animal.getImageName(color, size))
            }
        }
        internal static var buttonTextures = Color.allColors.map() { (color) -> [SKTexture] in
            return Size.allSizes.map() { (size) -> SKTexture in
                return SKTexture(imageNamed: Animal.getButtonImageName(color, size))
            }
        }
    }
    
    internal var color: Color
    internal var size: Size
    internal var status: Status
    
    func getImageFileName() -> String {
        var fileName = join("-", [Constants.GOAT_KEYWORD, status.rawValue, color.rawValue, size.rawValue])
        return  fileName + ".png"
    }
    
    func getTexture() -> SKTexture {
        if status == .BUTTON {
            print ("button reach")
            return Constants.buttonTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
        } else {
            print ("other reach")
            return Constants.goatTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
        }
    }
    
    class func getImageName(color: Color, _ size: Size) -> String {
        return "goat-" + color.rawValue + "-" + size.rawValue + ".png"
    }
    
    class func getButtonImageName(color: Color, _ size: Size) -> String {
        return "button-" + color.rawValue + "-" + size.rawValue + ".png"
    }
    
    init(color: Color, size: Size) {
        self.color = color
        self.size = size
        self.status = .DEPLOYED
    }
    init(color: Color, size: Size, status : Animal.Status) {
        self.color = color
        self.size = size
        self.status = status
    }
    
    let scale1x : CGFloat = 0.030
    let scale1y : CGFloat = 0.030

    let mass1 : CGFloat = 7

    func getImageScale () -> (CGFloat, CGFloat) {
        return (scale1x, scale1y)
    }
    
    func getImageMass () -> CGFloat {
        return mass1
    }
    
}

