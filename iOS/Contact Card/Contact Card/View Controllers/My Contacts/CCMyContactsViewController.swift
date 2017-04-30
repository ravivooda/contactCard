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
    
    var shareCommand:ShareContactCommand? = nil
    var reshareCommand:ReshareContactCardCommand? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: NSNotification.Name(rawValue: LoginCommand.AuthenticationChangedNotificationKey), object: nil)
    }
    
    private func updateBarBadge() {
        var count = 0;
        for contact in self.contacts {
            count += contact.updateContactCommand != nil ? 1 : 0
        }
        
        if let tabBarItem = self.tabBarController?.tabBar.items?[0], count > 0 {
            tabBarItem.badgeValue = "\(count)"
            tabBarItem.badgeColor = .red
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateAllCallback(sender:)))
        } else {
            tabBarItem.badgeValue = ""
        }
        print("Count: \(count)")
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
    }
    
    func reloadLocalContactsAndDisplay(store: CNContactStore) {
        var contacts:[CCContact] = []
        let keysToFetch = [CNContactViewController.descriptorForRequiredKeys(),
                           CNContactImageDataKey,
                           CNContactIdentifierKey,
                           CNContactNoteKey] as [Any]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                contacts.append(CCContact(contact: contact))
            })
        } catch let error {
            print(error.localizedDescription)
        }
        self.contacts = contacts
        self.tableView.reloadData()
        
        print("Reloaded contacts on UI")
    }
    
    func syncLocalContactsWithRemoteUpdates(_ notification:NSNotification?) -> Void {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (authorized, error) in
                DispatchQueue.main.async {
                    self.syncLocalContactsWithRemoteUpdates(notification)
                }
            })
            break
        case .denied, .restricted:
            showAlertMessage(message: "Apologies. We need access to your contacts for updating your contacts.\nPlease note, we never use your contact data for any other purpose")
            break
        case .authorized:
            reloadLocalContactsAndDisplay(store: store)
            Data.syncContacts(callingViewController: nil, success: { (records) in
                self.updateContacts(records: records)
                UserDefaults.isAutoSyncEnabled ? self.reloadLocalContactsAndDisplay(store: store) : self.tableView.reloadData()
                self.updateBarBadge()
            }, fail: { (errorMessage, error) in
                self.showRetryAlertMessage(message: error.localizedDescription, retryHandler: { (action) in
                    self.syncLocalContactsWithRemoteUpdates(notification)
                })
                print(error)
            })
            break
        }
    }
    
    private func updateContacts(records:[CKRecord]) {
        var contactsToRefMap = [String:CCContact]()
        for contact in self.contacts {
            if let identifier = contact.contactIdentifier {
                contactsToRefMap[identifier.remoteID] = contact
            }
        }
        
        // Updating or creating new contacts
        var addContactCommands = [AddContactCardCommand]()
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
                if UserDefaults.isAutoSyncEnabled {
                    addCommand.execute(completed: nil)
                } else {
                    addContactCommands.append(addCommand)
                }
            }
        }
        
        if addContactCommands.count > 0, let addContactsViewController = self.storyboard?.instantiateViewController(withIdentifier: "addContactsViewController") as? AddContactsViewController {
            let navigationController = UINavigationController(rootViewController: addContactsViewController)
            addContactsViewController.cards.append(contentsOf: addContactCommands)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier", for: indexPath) as! CCContactTableViewCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var retArray = [UITableViewRowAction]()
        if let _ = self.contacts[indexPath.row].contactIdentifier {
            let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: { (action, indexPath) in
                self.reshareCommand = ReshareContactCardCommand(contact: self.contacts[indexPath.row], viewController: self, returningCommand: nil)
                self.reshareCommand?.execute(completed: nil)
            })
            retArray.append(shareAction)
        }
        return retArray
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShowContactCommand(contact: contacts[indexPath.row].contact, viewController: self, returningCommand: nil).execute(completed: nil)
    }
}
