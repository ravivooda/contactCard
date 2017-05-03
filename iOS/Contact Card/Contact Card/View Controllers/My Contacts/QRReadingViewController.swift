//
//  QRReadingViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/30/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class QRReadingViewController: UIViewController {
    
    var qrCommand:ReadContactQRCommand!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelQRCodeReading(_ sender: UIButton) {
        self.qrCommand.cancelQRReading(sender: sender)
    }
}
