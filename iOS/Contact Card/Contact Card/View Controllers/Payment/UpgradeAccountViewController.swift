//
//  UpgradeAccountViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 7/29/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import SwiftHEXColors

class UpgradeAccountViewController: UIViewController {
    
    var command:PurchaseAdditionalCardsCommand!

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addBackgroundGradient(startColor: UIColor(hexString: "1fd1c7")!, endColor: UIColor(hexString: "1faee9")!)
    }

    @IBAction func restoreClicked(_ sender: UIButton) {
        command.restore()
    }
    
    @IBAction func buyClicked(_ sender: UIButton) {
        command.buy()
    }
}
