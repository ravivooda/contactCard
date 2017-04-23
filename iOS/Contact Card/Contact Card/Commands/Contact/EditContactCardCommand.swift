//
//  EditContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import ContactsUI

class EditContactCardCommand: Command, CNContactViewControllerDelegate {
    private let card:CCCard
    
    init(card:CCCard, viewController: UIViewController, returningCommand: Command?) {
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        if let mutableContact = self.card.contact.mutableCopy() as? CNMutableContact {
            let editCardViewController = CNContactViewController(forNewContact: mutableContact)
            editCardViewController.contactStore = CNContactStore()
            editCardViewController.title = "Edit Card"
            editCardViewController.delegate = self
            self.presentingViewController.present(UINavigationController(rootViewController: editCardViewController), animated: true, completion: nil)
        }
    }
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true) {
            if let contact = contact?.mutableCopy() as? CNMutableContact{
                print("Saving new card \(contact.description)")
                // Deleting the contact first
                let deleteRequest = CNSaveRequest()
                deleteRequest.delete(contact)
                
                do {
                    try Manager.contactsStore.execute(deleteRequest)
                } catch let error {
                    self.presentingViewController.showAlertMessage(message: "An error occurred in saving your card - \(error.localizedDescription)")
                    print(error.localizedDescription)
                }
                
                self.saveContactCard(contact: contact)
            }
        }
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
}
