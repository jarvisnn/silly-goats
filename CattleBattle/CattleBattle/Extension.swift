//
//  SKNodeExtension.swift
//  CattleBattle
//
//  Created by Duong Dat on 4/5/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import SpriteKit


extension SKNode {
    class func unarchiveFromFile(file: String) -> SKNode? {
        if var path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKEmitterNode {
    class func getEmitterFromFile(filename: String) -> SKEmitterNode {
        let resource = NSBundle.mainBundle().pathForResource(filename, ofType: "sks")
        return NSKeyedUnarchiver.unarchiveObjectWithFile(resource!) as! SKEmitterNode
    }
}

extension CGPoint {
    func distanceTo(toPoint: CGPoint) -> CGFloat {
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
