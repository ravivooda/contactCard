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

class CCMyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var contacts:[CCContact] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            reloadContacts()
            syncLocalContactsWithRemoteUpdates()
        }
    }
    
    func reloadContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized, error) in
                if authorized {
                    self.retrieveContactsWithStore(store: store)
                }
            })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore) {
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
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.contacts = contacts
        self.tableView.reloadData()
        
        print("Reloaded contacts on UI")
    }
    
    func syncLocalContactsWithRemoteUpdates() -> Void {
        // Syncing contacts remotely
        var contactIDs:[String] = []
        
        for contact in self.contacts {
            if !isEmpty(contact.remoteID) {
                contactIDs.append(contact.remoteID)
            }
        }
        
        Data.syncContacts(contactIDs: contactIDs, callingViewController: nil, success: { (response:[String: Any]) in
            if let contacts_data = response["contacts_data"] as? [String: Any] {
                self.updateContacts(contacts_data: contacts_data)
            }
        }) { (response: [String : Any], httpResponse) in
            print("Got error: \(response)")
            print("Got HTTP Response \(httpResponse)")
        }
    }
    
    private func updateContacts(contacts_data:[String: Any]) {
        for contact in self.contacts {
            if let contact_data = contacts_data[contact.remoteID] as? [String: Any] {
                if let data = contact_data["value"] as? String {
                    if let actualDict = convertToDictionary(text: data) {
                        contact.updateContact(data: actualDict)
                    }
                }
            }
        }
        
        reloadContacts()
    }
    
    //MARK: - UITableViewDataSource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier", for: indexPath) as! CCContactTableViewCell
        cell.setContact(contact: contacts[indexPath.row])
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CNContactViewController(for: contacts[indexPath.row].contact)
        viewController.allowsEditing = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissContactViewController(sender:Any?) -> Void {
        
    }
}
