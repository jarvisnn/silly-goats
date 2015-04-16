//
//  InstructionViewController.swift
//  CattleBattle
//
//  Created by kunn on 4/12/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class Instruction1: UIViewController {
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
}

