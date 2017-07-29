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

class CCMyContactsViewController: ContactsDisplayTableViewController, CNContactViewControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var searchResultsController:SearchResultsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.myContactsViewController = self
        
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: LoginCommand.AuthenticationChangedNotificationKey, object: nil)
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(syncLocalContactsWithRemoteUpdates(_:)), name: CNContactStore.ContactsChangedNotification, object: nil)
        NotificationCenter.contactCenter.addObserver(self, selector: #selector(contactUpdateChangedNotification(notification:)), name: CNContactStore.ContactsChangedNotification, object: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(readQR(sender:)))
        
        self.searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "searchResultsTableViewController") as! SearchResultsViewController
        self.searchResultsController.ownerDisplayViewController = self
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        definesPresentationContext = true
    }
    
    func contactUpdateChangedNotification(notification:Notification) {
        self.updateBarBadge()
        for section in self.contactSections {
            for contact in section.contacts {
                if let updateCommand = contact.updateContactCommand, updateCommand.progress != 1 {
                    return
                }
            }
        }
        
        self.syncLocalContactsWithRemoteUpdates(nil)
    }
    
    func readQR(sender:UIBarButtonItem) {
        ReadContactQRCommand(viewController: self, returningCommand: nil).execute(completed: nil)
    }
    
    private func updateBarBadge() {
        var updateCount = 0;
        for section in self.contactSections {
            for contact in section.contacts {
                if let updateCommand = contact.updateContactCommand, updateCommand.progress != 1 {
                    updateCount += 1
                }
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
        for section in self.contactSections {
            for contact in section.contacts {
                contact.updateContactCommand?.execute(completed: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = LoginCommand.user {
            syncLocalContactsWithRemoteUpdates(nil)
        }
        
        //self.openContactUpdate(userInfo: ["recordID": "_63a7116239850fe3777d08cedcd965d1.E318A8A3-2A3F-4103-A4A2-7F28903F8AFD"])
    }
    
    func reloadLocalContactsAndDisplay(store: CNContactStore) {
        do {
            let contacts = try store.fetchAllContacts()
            var sections:[String: ContactsDisplayTableViewController.ContactSection] = [:]
            
            for contact in contacts {
                var name = "#"
                if let character = contact.contact.familyName.characters.first ??
                    contact.contact.givenName.characters.first ??
                    contact.contact.fullName.characters.first {
                    name = "\(character)"
                }
                
                let sectionContact:ContactSection = sections[name] ?? ContactSection(name: name, contacts: [])
                sectionContact.contacts.append(contact)
                sections[name] = sectionContact
            }
            
            var unorderedSections:[ContactsDisplayTableViewController.ContactSection] = []
            
            for (_,section) in sections {
                unorderedSections.append(section)
            }
            unorderedSections.sort(by: { (a, b) -> Bool in
                //print("Comparing: \(a.name) : \(b.name)")
                if a.name.hasPrefix("#") {
                    return false
                } else if b.name.hasPrefix("#") {
                    return true
                } else if a.name.hasPrefix("+") {
                    return true
                } else if b.name.hasPrefix("+") {
                    return false
                }
                return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
            })
            
            self.contactSections = unorderedSections // Ordered now
        } catch let error {
            self.contactSections = []
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
            if self.contactSections.count == 0 {
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
    
    func openContactUpdate(userInfo: [AnyHashable: Any]) {
        self.navigationController?.popToRootViewController(animated: true)
        if let recordName = userInfo["recordID"] as? String {
            for (section, contactSection) in self.contactSections.enumerated() {
                for (row, contact) in contactSection.contacts.enumerated() {
                    if contact.contactIdentifier?.remoteID == recordName {
                        self.tableView.scrollToRow(at: IndexPath(row: row, section:section), at: .middle, animated: true)
                        return
                    }
                }
            }
        }
        showAlertMessage(message: "An unexpected error occurred while fetching the update. Apologies")
    }
    
    
    private func updateContacts(records:[CKRecord]) {
        print("Found shared contacts : \(records.count) ")
        var contactsToRefMap = [String:CCContact]()
        for section in self.contactSections {
            for contact in section.contacts {
                if let identifier = contact.contactIdentifier {
                    contactsToRefMap[identifier.remoteID] = contact
                }
            }
        }
        
        // Updating or creating new contacts
        self.newContacts = []
        for record in records {
            print("Record: \(record.getContactName())")
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
}
