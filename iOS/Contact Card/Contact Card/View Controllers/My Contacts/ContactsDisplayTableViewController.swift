//
//  ContactsDisplayTableViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 7/7/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class ContactsDisplayTableViewController: UITableViewController {
    
    var contacts:[CCContact] = []
    var newContacts:[AddContactCardCommand] = []
    
    var newContactCellsCount: Int {
        return newContacts.count > 0 ? 1 : 0;
    }
    
    var shareCommand:ShareCardCommand? = nil
    var reshareCommand:ReshareContactCardCommand? = nil
    var deleteCommand:DeleteContactCommand? = nil

    //MARK: - UITableViewDataSource -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count + newContactCellsCount;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newContactCellsCount > 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addContactTableViewCellIdentifier", for: indexPath) as! NewContactsAvailableTableViewCell
            cell.newContacts = newContacts
            return cell
        }
        let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier", for: indexPath) as! CCContactTableViewCell
        cell.contact = contacts[indexPath.row - self.newContactCellsCount]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)
        footerView.backgroundColor = tableView.separatorColor
        return footerView
    }
    
    //MARK: - UITableViewDelegate -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
