//
//  CCContactTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 12/24/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import CloudKit

class CCContactTableViewCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!

	@IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var progressView: ContactProgressView!
    var contact:CCContact! {
        didSet {
            NotificationCenter.contactCenter.removeObserver(self)
            self.nameLabel.text = contact.displayName();
            
            self.rightButton.isHidden = true
            self.progressView.isHidden = true
            if let command = contact.updateContactCommand, contact.contactIdentifier != nil {
                showProgress(progress: command.progress)
            } else if contact.contactIdentifier == nil {
                showInviteUser()
            }
        }
    }
    
    private func showInviteUser() {
        self.rightButton.setTitle("Invite", for: .normal)
        self.rightButton.tintColor = self.tintColor
        self.rightButton.isHidden = false
    }
    
    private func showProgress(progress:Float){
        if progress >= 0 {
            self.rightButton.isHidden = true
            self.progressView.showProgress(float: progress, animated: false)
        } else {
            self.rightButton.isHidden = false
            self.rightButton.setTitle("Update", for: .normal)
            self.rightButton.tintColor = .red
        }
    }
    
    private func contactUpdateNotificationListener(notification:Notification) {
        if let userInfo = notification.userInfo as? [String:Any] {
            if userInfo.bool(forKey: CCContact.ContactNotificationUpdateAvailableInfoKey) {
                showProgress(progress: -1)
            }
        }
    }

	@IBAction func rightButtonClicked(_ sender: Any) {
        
	}
}

extension Dictionary where Key == String {
    func bool(forKey key:String) -> Bool {
        return self[key] as? Bool ?? false
    }
}
