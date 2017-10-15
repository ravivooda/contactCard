//
//  ContactsDisplayTableViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 7/7/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class ContactsDisplayTableViewController: UITableViewController {
    
    class ContactSection: Any {
        var name:String
        var contacts:[CCContact]
        
        init(name:String, contacts:[CCContact]) {
            self.name = name
            self.contacts = contacts
        }
    }
    
    var contactSections:[ContactSection] = []
    var newContacts:[AddContactCardCommand] = []
    
    var newContactCellsCount: Int {
        return newContacts.count > 0 ? 1 : 0;
    }
    
    var ownerDisplayViewController:UIViewController? = nil
    
    
    var shareCommand:ShareCardCommand? = nil
    var reshareCommand:ReshareContactCardCommand? = nil
    var deleteCommand:DeleteContactCommand? = nil
    
    //MARK: - UITableViewDataSource -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactSections.count + newContactCellsCount;
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexes:[String] = []
        if newContactCellsCount > 0 {
            indexes.append("+")
        }
        for section in self.contactSections {
            indexes.append(section.name)
        }
        return indexes
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if newContactCellsCount > 0, section == 0 {
            return "+"
        }
        return contactSections[section - newContactCellsCount].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newContactCellsCount > 0, section == 0 {
            return 1
        }
        return contactSections[section - newContactCellsCount].contacts.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newContactCellsCount > 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addContactTableViewCellIdentifier", for: indexPath) as! NewContactsAvailableTableViewCell
            cell.newContacts = newContacts
            return cell
        }
        let cell:CCContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCellIdentifier", for: indexPath) as! CCContactTableViewCell
        cell.contact = contactSections[indexPath.section - newContactCellsCount].contacts[indexPath.row] //contacts[indexPath.row - self.newContactCellsCount]
        return cell
    }
    
    var getOwnerDisplayViewController:UIViewController {
        return self.ownerDisplayViewController ?? self
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 && newContactCellsCount != 0 {
            return []
        }
        
        var retArray:[UITableViewRowAction] = []
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            let contact = self.contactSections[indexPath.section - self.newContactCellsCount].contacts[indexPath.row]
            self.deleteCommand = DeleteContactCommand(contact: contact, viewController: self.getOwnerDisplayViewController, returningCommand: nil)
            self.deleteCommand?.execute(completed: nil)
        })
        if let _ = contactSections[indexPath.section - newContactCellsCount].contacts[indexPath.row].contactIdentifier {
            let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath) in
                let contact = self.contactSections[indexPath.section - self.newContactCellsCount].contacts[indexPath.row]
                self.reshareCommand = ReshareContactCardCommand(contact: contact, viewController: self.getOwnerDisplayViewController, returningCommand: nil)
                self.reshareCommand?.execute(completed: nil)
            })
            retArray.append(shareAction)
        }
        retArray.append(deleteAction)
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
        if newContactCellsCount > 0, indexPath.section == 0 {
            if let addContactsViewController = self.storyboard?.instantiateViewController(withIdentifier: "addContactsViewController") as? AddContactsViewController {
                let navigationController = UINavigationController(rootViewController: addContactsViewController)
                addContactsViewController.cards = self.newContacts
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        ShowContactCommand(contact: contactSections[indexPath.section - newContactCellsCount].contacts[indexPath.row].contact, viewController: self.getOwnerDisplayViewController, returningCommand: nil).execute(completed: nil)
    }
    
}
