//
//  CCMyCardsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CloudKit

class CCMyCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate, UICloudSharingControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var editingCard:CCCard?
    
    @IBAction func addNewCard(_ sender: Any) {
        let newCardViewController = CNContactViewController(forNewContact: nil)
        newCardViewController.contactStore = CNContactStore()
        newCardViewController.delegate = self
        self.present(UINavigationController(rootViewController: newCardViewController), animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            
        }
        refreshData()
    }
    
    //MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.defaultManager().cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCellIdentifier", for: indexPath) as! CCCardTableViewCell
        cell.updateViewWithCard(card: Manager.defaultManager().cards[indexPath.row])
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CNContactViewController(for: Manager.defaultManager().cards[indexPath.row].contact)
        viewController.allowsEditing = false
        viewController.allowsActions = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editingCard = Manager.defaultManager().cards[indexPath.row]
            if let mutableContact = self.editingCard?.contact.mutableCopy() as? CNMutableContact {
                print("Editing Card: \(mutableContact)")
                let editCardViewController = CNContactViewController(forNewContact: mutableContact)
                editCardViewController.contactStore = CNContactStore()
                editCardViewController.title = "Edit Card"
                editCardViewController.delegate = self
                self.present(UINavigationController(rootViewController: editCardViewController), animated: true, completion: nil)
            }
        }
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath) in
            let sharingCard = Manager.defaultManager().cards[indexPath.row];
            //let share = CKShare(rootRecord: sharingCard.record)
            //share.publicPermission = .readOnly
            
            let shareController = UICloudSharingController(preparationHandler: { (controller, preparationCompletionHandler) in
                let share = CKShare(rootRecord: sharingCard.record)
                share[CKShareTitleKey] = " My First Share" as CKRecordValue
                share.publicPermission = .readOnly
                
                let modifyRecordsOperation = CKModifyRecordsOperation(
                    recordsToSave: [sharingCard.record, share],
                    recordIDsToDelete: nil)
                
                modifyRecordsOperation.timeoutIntervalForRequest = 10
                modifyRecordsOperation.timeoutIntervalForResource = 10
                
                modifyRecordsOperation.modifyRecordsCompletionBlock = { records,
                    recordIDs, error in
                    if error != nil {
                        print(error)
                        print(error?.localizedDescription ?? "")
                    }
                    print(share.url)
                    preparationCompletionHandler(share, Manager.contactsContainer, error)
                }
                Manager.contactsContainer.privateCloudDatabase.add(modifyRecordsOperation)
            })
            
            shareController.delegate = self
            shareController.availablePermissions = [.allowReadOnly]
            self.present(shareController, animated: true, completion: { 
                //print("share URL: \(share.url)")
            })
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPatch) in
            let confirmDeleteAction = UIAlertController(title: "Do you really want to delete this card?", message: "Everyone with this card will loose important contact updates from you", preferredStyle: .actionSheet)
            confirmDeleteAction.addAction(UIAlertAction(title: "Delete (Informing card holders)", style: .default, handler: { (action) in
                print("Should delete the card updating the card holders")
            }))
            confirmDeleteAction.addAction(UIAlertAction(title: "Delete (Without informing card holders)", style: .destructive, handler: { (action) in
                print("Should delete the card without updating the card holders")
            }))
            confirmDeleteAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(confirmDeleteAction, animated: true, completion: nil)
        }
        
        return [editAction, shareAction, deleteAction]
    }
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        print("Completed adding card \(contact)")
        viewController.dismiss(animated: true) {
            
            if let _contact = contact?.mutableCopy() as? CNMutableContact{
                // Deleting the contact first
                let deleteRequest = CNSaveRequest()
                deleteRequest.delete(_contact)
                
                do {
                    try Manager.contactsStore.execute(deleteRequest)
                } catch let error as NSError {
                    print(error)
                    return
                }
                
                if self.editingCard != nil {
                    self.saveContact(card: self.editingCard!, contact: contact!)
                    self.editingCard = nil
                } else {
                    self.addContact(contact: contact!)
                }
            }
        }
    }
    
    //MARK: - UICloudSharingControllerDelegate -
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Sharing contact"
    }
    
    func saveContact(card:CCCard, contact:CNContact) {
        Manager.defaultManager().editCard(card: card, contact: contact, callingViewController: self, success: { (data) in
            print("Successfully edited card: \(contact)")
            self.refreshData()
        }) { (data, response) in
            print("Failed to edit card: \(contact)")
        }
    }
    
    func addContact(contact:CNContact) {
        Manager.defaultManager().addNewCard(name: "", card: contact, callingViewController: self, success: { (records) in
            print("Added card successfully: \(contact)")
            self.reloadTableView()
        }, fail: { (errorMessage, error) in
            print("Failed to add card: \(contact)")
        })
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func refreshData() {
        Manager.defaultManager().refreshCards(callingViewController: self, success: { (records) in
            self.reloadTableView()
        }, fail: { (message, error) in
            print("Message: \(message), error: \(error)")
        })
    }
}
