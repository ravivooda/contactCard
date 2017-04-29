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

class CCMyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate, ContactUpdateDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var contacts:[CCContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: NSNotification.Name(rawValue: LoginCommand.AuthenticationChangedNotificationKey), object: nil)
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
                self.reloadLocalContactsAndDisplay(store: store)
            }, fail: { (errorMessage, error) in
                print(error)
            })
            break
        }
    }
    
    private func updateContacts(records:[CKRecord]) {
        var contactsToRefMap = [String:CCContact]()
        for contact in self.contacts {
            if !isEmpty(contact.remoteID) {
                contactsToRefMap[contact.remoteID] = contact
            }
        }
        
        // Updating or creating new contacts
        var addContactCommands = [AddContactCardCommand]()
        for record in records {
            let recordIdentifier = record.recordIdentifier
            if let contact = contactsToRefMap[recordIdentifier] {
                contact.updateRecord = record
            } else {
                addContactCommands.append(AddContactCardCommand(record: record, viewController: self, returningCommand: nil))
            }
        }
        
        //FIXME: Fix with settings
        if addContactCommands.count > 0 {
            if UserDefaults.isAutoSyncEnabled {
                for addContactCommand in addContactCommands {
                    addContactCommand.contactAddingDelegate = self
                    addContactCommand.execute(completed: nil)
                }
            } else if let addContactsViewController = self.storyboard?.instantiateViewController(withIdentifier: "addContactsViewController") as? AddContactsViewController {
                let navigationController = UINavigationController(rootViewController: addContactsViewController)
                addContactsViewController.cards.append(contentsOf: addContactCommands)
                self.present(navigationController, animated: true, completion: nil)
            }
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
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShowContactCommand(contact: contacts[indexPath.row].contact, viewController: self, returningCommand: nil).execute(completed: nil)
    }
    
    //MARK: - ContactUpdateDelegate -
    func contactUpdateError(error: Error) {
        showAlertMessage(message: error.localizedDescription)
    }
    
    func contactUpdateProgress(value: Float) {
        // Nothing to do
    }
}
