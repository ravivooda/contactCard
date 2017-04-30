//
//  NewContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import ContactsUI

class NewContactCardCommand: Command, CNContactViewControllerDelegate {
    private var name:String = ""
    private var contact:CNContact?
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let nameAlertController = UIAlertController(title: "Name your card", message: "Give your card a name", preferredStyle: .alert)
        nameAlertController.addTextField { (textField) in
            
        }
        nameAlertController.addAction(UIAlertAction(title: "Next", style: .default, handler: { (action) in
            if let name = nameAlertController.textFields?.first?.text, name.characters.count > 0 {
                self.name = name
                let newCardViewController = CNContactViewController(forNewContact: nil)
                newCardViewController.contactStore = CNContactStore()
                newCardViewController.delegate = self
                self.presentingViewController.present(UINavigationController(rootViewController: newCardViewController), animated: true, completion: nil)
            } else {
                self.presentingViewController.showRetryAlertMessage(message: "Your card needs a name", retryHandler: { (action) in
                    self.execute(completed: self.completed)
                })
            }
        }))
        nameAlertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.presentingViewController.present(nameAlertController, animated: true, completion: nil)
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
    
    private func saveContactCard(contact:CNMutableContact) {
        Manager.defaultManager().addNewCard(name: self.name, card: contact, callingViewController: self.presentingViewController, success: { (records) in
            print("Added card - \(self.name) - successfully")
            self.contact = contact
            self.finished()
        }, fail: { (errorMessage, error) in
            self.presentingViewController.showRetryAlertMessage(message: "Error occurred in saving your card. Please make sure you are connected to internet", retryHandler: { (action) in
                self.saveContactCard(contact: contact)
            })
        })
    }
}
