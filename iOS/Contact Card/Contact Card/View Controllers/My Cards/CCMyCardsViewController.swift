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
    private var editingCardCommand:EditContactCardCommand?
    private var addNewCardCommand:NewContactCardCommand?
    private var sharingCardCommand:ShareContactCommand?
    
    @IBAction func addNewCard(_ sender: Any) {
        self.addNewCardCommand = NewContactCardCommand(viewController: self, returningCommand: nil)
        self.addNewCardCommand!.execute {
            self.refreshData()
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: NSNotification.Name(rawValue: LoginCommand.AuthenticationChangedNotificationKey), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            refreshData()
        }
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
            self.editingCardCommand =  EditContactCardCommand(card: Manager.defaultManager().cards[indexPath.row], viewController: self, returningCommand: nil)
            self.editingCardCommand!.execute(completed: {
                self.refreshData()
            })
        }
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath) in
            self.sharingCardCommand = ShareContactCommand(withRecord: Manager.defaultManager().cards[indexPath.row].record, database: Manager.contactsContainer.privateCloudDatabase, viewController: self, returningCommand: nil)
            self.sharingCardCommand?.execute(completed: nil)
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
    
    //MARK: - UICloudSharingControllerDelegate -
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Sharing contact"
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
