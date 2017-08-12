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
    private var addNewCardCommand:NewContactCardCommand?
    private var sharingCardCommand:ShareCardCommand?
    private var deleteCardCommand:DeleteCardCommand?
    
    @IBAction func addNewCard(_ sender: Any) {
        self.addNewCardCommand = NewContactCardCommand(viewController: self, returningCommand: nil)
        self.addNewCardCommand!.execute {
            self.reloadTableView()
        }
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
        print("Refreshing Data")
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)
        footerView.backgroundColor = tableView.separatorColor
        return footerView
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShowCardCommand(card: Manager.defaultManager().cards[indexPath.row], viewController: self, returningCommand: nil).execute(completed: nil)
        //ShowContactCommand(contact: Manager.defaultManager().cards[indexPath.row].contact, viewController: self, returningCommand: nil).execute(completed: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath) in
            self.sharingCardCommand = ShareCardCommand(withCard: Manager.defaultManager().cards[indexPath.row], database: Manager.contactsContainer.privateCloudDatabase, viewController: self, returningCommand: nil)
            self.sharingCardCommand?.execute(completed: nil)
        })
        shareAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPatch) in
            self.deleteCardCommand = DeleteCardCommand(card: Manager.defaultManager().cards[indexPath.row], viewController: self, returningCommand: nil)
            self.deleteCardCommand?.execute(completed: {
                self.refreshData()
            })
        }
        
        return [shareAction, deleteAction]
    }
}
