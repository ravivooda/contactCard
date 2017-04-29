//
//  ContactProgressView.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/27/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class ContactProgressView: UIView {
    
    let progressBar = UIProgressView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubviewWithOccupyingConstraints(subView: self.progressBar)
    }
    
    func showProgress(float:Float) {
        showProgress(float: float, animated: true)
    }

    func showProgress(float:Float, animated: Bool) {
        if float < 0 {
            self.alpha = 0
        } else {
            self.alpha = 1
            self.progressBar.setProgress(float, animated: animated)
        }
    }

}
