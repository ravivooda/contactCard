//
//  CCMyContactsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts

class CCMyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	var contacts:[CCContact] = []
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		reloadContacts()
	}

	func reloadContacts() {
		let store = CNContactStore()
		
		if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
			store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
				if authorized {
					self.retrieveContactsWithStore(store: store)
				}
			} as! (Bool, Error?) -> Void)
		} else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
			self.retrieveContactsWithStore(store: store)
		}
	}
	
	func retrieveContactsWithStore(store: CNContactStore) {
		do {
			let groups = try store.groups(matching: nil)
			let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
			//let predicate = CNContact.predicateForContactsMatchingName("John")
			let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
			
			var contacts:[CCContact] = []
			
			let retrievedContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
			for contact in retrievedContacts {
				contacts.append(CCContact(contact: contact))
			}
			
			self.contacts = contacts
			DispatchQueue.main.sync {
				self.tableView.reloadData()
			}
		} catch {
			print(error)
		}
	}
	
	//MARK: - UITableViewDataSource -
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as! CCContactTableViewCell
		cell.setContact(contact: contacts[indexPath.row])
		return cell
	}
	
	//MARK: - UITableViewDelegate -
}
