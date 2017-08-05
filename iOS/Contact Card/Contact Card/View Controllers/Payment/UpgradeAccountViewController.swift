//
//  UpgradeAccountViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 7/29/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class UpgradeAccountViewController: UIViewController {
    
    var command:PurchaseAdditionalCardsCommand!

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func restoreClicked(_ sender: UIButton) {
        command.restore()
    }
    
    @IBAction func buyClicked(_ sender: UIButton) {
        command.buy()
    }
}
