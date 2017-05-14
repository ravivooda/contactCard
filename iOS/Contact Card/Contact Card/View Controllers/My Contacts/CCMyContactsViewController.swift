//
//  CCMyContactsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CloudKit

class CCMyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var contacts:[CCContact] = []
    var newContacts:[AddContactCardCommand] = []
    
    var newContactCellsCount: Int {
        return newContacts.count > 0 ? 1 : 0;
    }
    
    var shareCommand:ShareCardCommand? = nil
    var reshareCommand:ReshareContactCardCommand? = nil
    var deleteCommand:DeleteContactCommand? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.myContactsViewController = self
        
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: LoginCommand.AuthenticationChangedNotificationKey, object: nil)
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: CNContactStore.ContactsChangedNotification, object: nil)
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(contactUpdateChangedNotification(notification:)), name: CNContactStore.ContactsChangedNotification, object: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(readQR(sender:)))
    }
    
    func contactUpdateChangedNotification(notification:Notification) {
        self.updateBarBadge()
        for contact in self.contacts {
            if let updateCommand = contact.updateContactCommand, updateCommand.progress != 1 {
                return
            }
        }
        
        self.syncLocalContactsWithRemoteUpdates(nil)
    }
    
    func readQR(sender:UIBarButtonItem) {
        ReadContactQRCommand(viewController: self, returningCommand: nil).execute(completed: nil)
    }
    
    private func updateBarBadge() {
        var updateCount = 0;
        for contact in self.contacts {
            if let updateCommand = contact.updateContactCommand, updateCommand.progress != 1 {
                updateCount += 1
            }
        }
        
        self.navigationItem.rightBarButtonItem = updateCount > 0 ? UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateAllCallback(sender:))) : nil
        let tabCount = updateCount + newContacts.count;
        
        if let tabBarItem = self.tabBarController?.tabBar.items?[0], tabCount > 0 {
            tabBarItem.badgeValue = "\(tabCount)"
            tabBarItem.badgeColor = .red
        } else {
            tabBarItem.badgeValue = ""
        }
        UIApplication.shared.applicationIconBadgeNumber = tabCount
        print("Update count - \(updateCount), Tab count - \(tabCount)")
    }
    
    func updateAllCallback(sender:UIBarButtonItem) {
        for contact in self.contacts {
            contact.updateContactCommand?.execute(completed: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            syncLocalContactsWithRemoteUpdates(nil)
        }
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func reloadLocalContactsAndDisplay(store: CNContactStore) {
        do {
            try self.contacts = store.fetchAllContacts()
        } catch let error {
            self.contacts = []
            self.showAlertMessage(message: "An error occurred while reading your contacts - \(error.localizedDescription).\nPlease note, we never use your contact data for any other purpose")
        }
        
        self.tableView.reloadData()
        
        print("Reloaded contacts on UI")
    }
    
    private var isSyncing = false
    func syncLocalContactsWithRemoteUpdates(_ notification:NSNotification?) -> Void {
        if isSyncing {
            print("Currently syncing")
            return
        }
        isSyncing = true
        let store = Manager.contactsStore
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (authorized, error) in
                DispatchQueue.main.async {
                    self.isSyncing = false
                    self.syncLocalContactsWithRemoteUpdates(notification)
                }
            })
            break
        case .denied, .restricted:
            showSettingsAlertMessage(message: "Apologies. We need access to your contacts for maintaining your contacts.\nPlease note, we never use your contact data for any other purpose")
            break
        case .authorized:
            if self.contacts.count == 0 {
                reloadLocalContactsAndDisplay(store: store)
            }
            Data.syncContacts(callingViewController: nil, success: { (records) in
                self.reloadLocalContactsAndDisplay(store: store)
                self.updateContacts(records: records)
                //UserDefaults.isAutoSyncEnabled ? self.reloadLocalContactsAndDisplay(store: store) : self.tableView.reloadData()
                self.tableView.reloadData()
                self.updateBarBadge()
                self.isSyncing = false
            }, fail: { (errorMessage, error) in
                self.isSyncing = false
                self.showRetryAlertMessage(message: error.localizedDescription, retryHandler: { (action) in
                    self.syncLocalContactsWithRemoteUpdates(notification)
                })
                print(error)
            })
            break
        }
    }
    
    private func updateContacts(records:[CKRecord]) {
        print("Found shared contacts : \(records.count) ")
        var contactsToRefMap = [String:CCContact]()
        for contact in self.contacts {
            if let identifier = contact.contactIdentifier {
                contactsToRefMap[identifier.remoteID] = contact
            }
        }
        
        // Updating or creating new contacts
        self.newContacts = []
        for record in records {
            let recordIdentifier = record.recordIdentifier
            if let contact = contactsToRefMap[recordIdentifier] {
                if record.recordChangeTag != contact.contactIdentifier!.version {
                    contact.updateContactCommand = UpdateContactCardCommand(contact: contact, record: record, viewController: self, returningCommand: nil)
                    if UserDefaults.isAutoSyncEnabled {
                        contact.updateContactCommand?.execute(completed: nil)
                    }
                }
            } else {
                let addCommand = AddContactCardCommand(record: record, viewController: self, returningCommand: nil)
                UserDefaults.isAutoSyncEnabled ? addCommand.execute(completed: nil) : self.newContacts.append(addCommand)
            }
        }
    }
    
    //MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count + newContactCellsCount;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newContactCellsCount > 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addContactTableViewCellIdentifier", for: indexPath) as! NewContactsAvailableTableViewCell
            cell.newContacts = newContacts
            return cell
        }
        let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier", for: indexPath) as! CCContactTableViewCell
        cell.contact = contacts[indexPath.row - self.newContactCellsCount]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var retArray = [UITableViewRowAction]()
        let index = indexPath.row - self.newContactCellsCount
        if index >= 0 {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                let contact = self.contacts[indexPath.row - self.newContactCellsCount]
                self.deleteCommand = DeleteContactCommand(contact: contact, viewController: self, returningCommand: nil)
                self.deleteCommand?.execute(completed: nil)
            })
            if let _ = self.contacts[indexPath.row - self.newContactCellsCount].contactIdentifier {
                let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath) in
                    self.reshareCommand = ReshareContactCardCommand(contact: self.contacts[indexPath.row - self.newContactCellsCount], viewController: self, returningCommand: nil)
                    self.reshareCommand?.execute(completed: nil)
                })
                retArray.append(shareAction)
            }
            retArray.append(deleteAction)
        }
        return retArray
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newContactCellsCount > 0, indexPath.row == 0 {
            if let addContactsViewController = self.storyboard?.instantiateViewController(withIdentifier: "addContactsViewController") as? AddContactsViewController {
                let navigationController = UINavigationController(rootViewController: addContactsViewController)
                addContactsViewController.cards = self.newContacts
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        ShowContactCommand(contact: contacts[indexPath.row - self.newContactCellsCount].contact, viewController: self, returningCommand: nil).execute(completed: nil)
    }
}
