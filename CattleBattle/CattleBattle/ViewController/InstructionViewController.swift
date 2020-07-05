//
//  InstructionViewController.swift
//  CattleBattle
//
//  Created by Tran Cong Thien on 17/4/15.
//  Copyright (c) 2015 Cattle Battle. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
}

