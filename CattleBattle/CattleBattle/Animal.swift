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
        case BUMPING = "bumping"
        case BUTTON = "button"
        
        internal static let allStatuses = [DEPLOYED, BUMPING, BUTTON]
    }
    
    struct Constants {
        internal static let GOAT_KEYWORD = "goat"
        internal static let IMAGE_EXT = ".png"

        internal static let SPRITE_SHEET_ROWS = 2
        internal static let SPRITE_SHEET_COLS = 5
        
        internal static var deployedTextures = Color.allColors.map() { (color) -> [[SKTexture]] in
            return Size.allSizes.map() { (size) -> [SKTexture] in
                return Constants.getTextureList(color: color, size: size, status: .DEPLOYED)
            }
        }
        internal static var buttonTextures = Color.allColors.map() { (color) -> [SKTexture] in
            return Size.allSizes.map() { (size) -> SKTexture in
                return SKTexture(imageNamed: Animal(color: color, size: size, status: .BUTTON).getImageFileName())
            }
        }
        internal static var bumpingTextures = Color.allColors.map() { (color) -> [[SKTexture]] in
            return Size.allSizes.map() { (size) -> [SKTexture] in
                return Constants.getTextureList(color: color, size: size, status: .BUMPING)
            }
        }
        
        //get the array of textures from a texture sheet for running animation
        internal static func getTextureList(#color: Color, size: Size, status: Status) -> [SKTexture] {
            var spriteSheet = SKTexture(imageNamed:  Animal(color: color, size: size, status: status).getImageFileName())
            if status == .DEPLOYED {
                spriteSheet.filteringMode = SKTextureFilteringMode.Nearest
            }
            var result = [SKTexture]()
            var x = 1.0 / CGFloat(SPRITE_SHEET_COLS)
            var y = 1.0 / CGFloat(SPRITE_SHEET_ROWS)
            for i in 0..<SPRITE_SHEET_COLS {
                for j in 0..<SPRITE_SHEET_ROWS {
                    var rectFrame = CGRectMake(CGFloat(i) * x, CGFloat(j) * y, x, y)
                    result.append(SKTexture(rect: rectFrame, inTexture: spriteSheet))
                }
            }
            return result
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
            return Constants.buttonTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
        } else if status == .DEPLOYED {
            return Constants.deployedTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!][0]
        } else {
            return Constants.bumpingTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!][0]
        }
    }
    
    func getDeployedTexture() -> [SKTexture] {
        return Constants.deployedTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
    }
    
    func getBumpingTexture() -> [SKTexture] {
        return Constants.bumpingTextures[find(Color.allColors, color)!][find(Size.allSizes, size)!]
    }
    
    
    init(color: Color, size: Size, status: Status) {
        self.color = color
        self.size = size
        self.status = status
    }
    
    //let scale1x : CGFloat = 0.5
    //let scale1y : CGFloat = 0.5
    
    let mass1 : CGFloat = 7
    
    func getImageScale () -> (CGFloat, CGFloat) {
        switch (size) {
        case .TINY: return (0.2, 0.2)
            
        case .SMALL: return (0.35, 0.35)
    
        case .MEDIUM: return (0.4, 0.4)
        
        case .LARGE: return (0.45, 0.45)
            
        case .HUGE: return (0.6, 0.6)
        }
        //return (scale1x, scale1y)
    }
    
    func getImageMass () -> CGFloat {
        return mass1
    }
    
}
