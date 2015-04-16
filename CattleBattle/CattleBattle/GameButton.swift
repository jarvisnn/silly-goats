//
//  ButtonNode.swift
//  CattleBattle
//
//  Created by jarvis on 4/16/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit

class GameButton {
    
    enum ButtonType: String {
        case PAUSE = "pause"
        case RESTART = "restart"
        case HOME = "home"
        case BACK = "back"
        case CONTINUE = "continue"
        
        internal static let allTypes = [PAUSE, RESTART, HOME, BACK, CONTINUE]
    }
    
    struct Constants {
        internal static let BUTTON_KEYWORD = "button"
        internal static let IMAGE_EXT = ".png"
        
        internal static var textures = ButtonType.allTypes.map() { type -> SKTexture in
            return SKTexture(imageNamed: GameButton(type: type)._getImageFileName())
        }
    }
    
    internal var buttonType: ButtonType
    
    init(type: ButtonType) {
        self.buttonType = type
    }

    private func _getImageFileName() -> String {
        var fileName = join("-", [Constants.BUTTON_KEYWORD, buttonType.rawValue])
        return fileName + Constants.IMAGE_EXT
    }
    
    internal func getTexture() -> SKTexture {
        return Constants.textures[find(ButtonType.allTypes, buttonType)!]
    }
}