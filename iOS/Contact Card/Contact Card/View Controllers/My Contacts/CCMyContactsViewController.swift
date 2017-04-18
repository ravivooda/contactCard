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
        Data.syncContacts(contactIDs: [], callingViewController: nil, success: { (records) in
            self.updateContacts(records: records)
        }, fail: { (errorMessage, error) in
            print(error)
        })
    }
    
    private func updateContacts(records:[CKRecord]) {
        /*for contact in self.contacts {
            if let contact_data = contacts_data[contact.remoteID] as? [String: Any] {
                if let data = contact_data["value"] as? String {
                    if let actualDict = convertToDictionary(text: data) {
                        contact.updateContact(data: actualDict)
                    }
                }
            }
        }*/
        
        var contactsToRefMap = [String:CCContact]()
        for contact in self.contacts {
            if !isEmpty(contact.remoteID) {
                contactsToRefMap[contact.remoteID] = contact
            } else {
                
            }
        }
        
        // Updating or creating new contacts
        for record in records {
            if let createdUserID = record.creatorUserRecordID, let payloadString = record["json"] as? String, let payload = convertToDictionary(text: payloadString) {
                let recordIdentifier = "\(createdUserID.recordName).\(record.recordID.recordName)"
                if let contact = contactsToRefMap[recordIdentifier] {
                    // update the record
                    contact.updateContact(data: payload)
                } else {
                    let newContact = CNMutableContact()
                    CCCard.parseDataWithMutableContactReference(contact: newContact, payload: payload)
                    newContact.note = newContact.note.appending("\n\(CCContact.referenceKey)\(recordIdentifier)")
                    let saveRequest = CNSaveRequest()
                    saveRequest.add(newContact, toContainerWithIdentifier: nil)
                    do {
                        try Manager.contactsStore.execute(saveRequest)
                    } catch let error as NSError {
                        print("Error occurred while saving the request \(error)")
                    }
                }
            } else {
                print("No created user????")
            }
        }
        
        reloadContacts()
    }
    
    func addNewContactFromRecord(record:CKRecord) {
        
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
        viewController.allowsActions = false
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissContactViewController(sender:Any?) -> Void {
        
    }
}
