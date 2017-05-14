//
//  QRShareViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/13/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit
import QRCode

class QRShareViewController: UIViewController {
    var code:QRCode!
    var command:Command?
    var activity:UIActivity?

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.code.size = self.imageView.frame.size
        self.imageView.image = self.code.image
    }

    @IBAction func dismissQRCode(_ sender: Any) {
        command?.finished()
        activity?.activityDidFinish(true)
        self.dismiss(animated: true, completion: nil)
    }
}
