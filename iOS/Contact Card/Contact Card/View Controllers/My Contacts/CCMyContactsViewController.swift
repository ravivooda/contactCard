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
		let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
		                   CNContactImageDataKey,
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
		print("Reloaded contacts")
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
}
