//
//  SKNodeExtension.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/5/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit


extension SKNode {
    class func unarchiveFromFile(_ file: String) -> SKNode? {
        if let path = Bundle.main.url(forResource: file, withExtension: "sks") {
            let sceneData = try! Data(contentsOf: path)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKEmitterNode {
    class func getEmitterFromFile(_ filename: String) -> SKEmitterNode {
        let resource = Bundle.main.path(forResource: filename, ofType: "sks")
        return NSKeyedUnarchiver.unarchiveObject(withFile: resource!) as! SKEmitterNode
    }
}

extension CGPoint {
    func distanceTo(_ toPoint: CGPoint) -> CGFloat {
        return (self - toPoint).getDistance()
    }
    
    func getDistance() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func *(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

func /(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
}
