//
//  AddContactTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/27/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class AddContactTableViewCell: UITableViewCell, ContactUpdateDelegate {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var progressView: ContactProgressView!
    
    var addContactCardCommand:AddContactCardCommand! {
        didSet {
            addContactCardCommand.contactAddingDelegate = self
            self.progressView.showProgress(float: addContactCardCommand.progress)
            
            self.contactNameLabel.text = addContactCardCommand.record.getContactName()
        }
    }

    @IBAction func addContactClicked(_ sender: UIButton) {
        addContactCardCommand.execute(completed: nil)
    }
    
    @IBAction func deleteContactClicked(_ sender: UIButton) {
        if let controller = self.viewController() {
            let alertDeleteController = UIAlertController(title: "Contact Card", message: "Are you sure you want to delete \(addContactCardCommand.record.getContactName())", preferredStyle: .alert)
            alertDeleteController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertDeleteController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.addContactCardCommand.deleteContact(completed: { 
                    
                })
            }))
            controller.present(alertDeleteController, animated: true, completion: nil)
        }
    }
    
    // MARK: - ContactUpdateDelegate -
    func contactUpdateProgress(value: Float) {
        self.progressView.showProgress(float: value)
    }
    
    func contactUpdateError(error: Error) {
        if let controller = self.viewController() {
            controller.showAlertMessage(message: error.localizedDescription)
        }
    }
}
