//
//  VersionUnsupportedViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class VersionUnsupportedViewController: UIViewController {
    
    var appStoreURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func openAppStoreClicked(_ sender: AnyObject) {
        if !isEmpty(appStoreURL) {
            if let url = URL(string: appStoreURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
