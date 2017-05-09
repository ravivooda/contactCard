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

class CCMyCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var editingCardCommand:EditContactCardCommand?
    private var addNewCardCommand:NewContactCardCommand?
    private var sharingCardCommand:ShareContactCommand?
    private var deleteCardCommand:DeleteCardCommand?
    
    @IBAction func addNewCard(_ sender: Any) {
        self.addNewCardCommand = NewContactCardCommand(viewController: self, returningCommand: nil)
        self.addNewCardCommand!.execute {
            self.refreshData()
        }
        //NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: NSNotification.Name(rawValue: LoginCommand.AuthenticationChangedNotificationKey), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.myCardsViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            refreshData()
        }
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func refreshData() {
        Manager.defaultManager().refreshCards(callingViewController: self, success: { (records) in
            self.reloadTableView()
        }, fail: { (message, error) in
            self.showRetryAlertMessage(message: message, retryHandler: { (action) in
                self.refreshData()
            })
            print("Message: \(message), error: \(error)")
        })
    }
    
    //MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.defaultManager().cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCellIdentifier", for: indexPath)
        if let cardCell = cell as? CCCardTableViewCell {
            cardCell.card = Manager.defaultManager().cards[indexPath.row]
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ShowContactCommand(contact: Manager.defaultManager().cards[indexPath.row].contact, viewController: self, returningCommand: nil).execute(completed: nil)
        let viewController = CNContactViewController(for: Manager.defaultManager().cards[indexPath.row].contact)
        viewController.allowsEditing = false
        viewController.allowsActions = false
        viewController.delegate = self
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
        shareAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPatch) in
            self.deleteCardCommand = DeleteCardCommand(card: Manager.defaultManager().cards[indexPath.row], viewController: self, returningCommand: nil)
            self.deleteCardCommand?.execute(completed: {
                self.refreshData()
            })
        }
        
        return [editAction, shareAction, deleteAction]
    }
}
