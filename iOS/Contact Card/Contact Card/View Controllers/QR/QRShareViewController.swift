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
    var record:CKRecord!
    var database:CKDatabase!
    
    var command:Command?

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let shareRef = self.record.share else {
            return self.showAlertMessage(message: "Apologies. This cannot be shared")
        }
        
        self.database.fetch(withRecordID: shareRef.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil, let share = record as? CKShare else {
                    print("\(error?.localizedDescription ?? "No error occurred")")
                    return self.showAlertMessage(message: "An error occurred in fetching the share details. Please ensure that the device has active internet connection")
                }
                
                guard let url = share.url, var qrCode = QRCode(url) else {
                    print("Share \(share) has no url")
                    return self.showAlertMessage(message: "Apologies. This cannot be shared")
                }
                qrCode.size = self.imageView.frame.size
                self.imageView.image = qrCode.image
            }
        }
    }

    @IBAction func dismissQRCode(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
