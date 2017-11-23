//
//  ShowCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/12/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Crashlytics

class ShowCardCommand: Command, CNContactViewControllerDelegate {
    let card:CCCard
	var editedCard:CNContact?
    
    init(card:CCCard, viewController: UIViewController, returningCommand: Command?) {
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        let contactController = CCContactViewController(for: self.card.contact)
        contactController.command = self
        contactController.delegate = self
        contactController.allowsEditing = true
        contactController.allowsActions = false
        card.contact.note = ""
		
        let navigationController = UINavigationController(rootViewController: contactController)
        contactController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismiss(sender:)))
        presentingViewController.present(navigationController, animated: true, completion: nil)
        
        self.presentedViewController = contactController;
    }
    
    @objc func dismiss(sender:Any) -> Void {
        print("Dismissing shown controller")
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
		guard let contact = contact else {
			let errorString = "Contact View Controller didCompleteWith empty"
			Crashlytics.sharedInstance().recordError(NSError(domain:"Unexpected errors", code:101, userInfo:["Error": errorString]))
			return print(errorString)
		}
		
		print("Saving edited card \(contact.description)")
        self.saveContactCard(contact: contact)
		
		self.editedCard = contact
    }
    
    func saveContactCard(contact:CNContact) {
        Manager.defaultManager().editCard(card: card, contact: contact, callingViewController: self.presentingViewController, success: { (records) in
            print("Updated the card \(self.card)")
            self.finished()
        }, fail: { (errorMessage, error) in
            self.presentingViewController.showRetryAlertMessage(message: "Error occurred in saving your card. Please make sure you are connected to internet", retryHandler: { (action) in
                self.saveContactCard(contact: contact)
            })
        })
    }

	func deleteSavedCopy() {
		print("Checking for deleting contact")
		if let deleteContact = self.editedCard?.mutableCopy() as? CNMutableContact {
			print("Deleting contact: \(deleteContact)")
			
			let deleteRequest = CNSaveRequest()
			deleteRequest.delete(deleteContact)
			
			do {
				try Manager.contactsStore.execute(deleteRequest)
			} catch let error {
				self.presentingViewController.showAlertMessage(message: "An error occurred in saving your card - \(error.localizedDescription)")
				return print(error.localizedDescription)
			}
			
			self.editedCard = nil
		}
	}
	
	deinit {
		deleteSavedCopy()
	}
}
