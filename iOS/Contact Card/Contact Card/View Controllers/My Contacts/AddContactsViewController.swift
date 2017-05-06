//
//  AddContactsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class AddContactsViewController: UITableViewController {
    var cards:[AddContactCardCommand] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.contactCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add All", style: .done, target: self, action: #selector(addAllContacts(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissClicked(sender:)))
        self.title = "New Contacts"
        
        for card in cards {
            NotificationCenter.contactCenter.addObserver(self, selector: #selector(contactUpdate(notification:)), name: card.record.getNotificationNameForRecord(), object: nil)
        }
    }
    
    func contactUpdate(notification:Notification) {
        if let record = notification.object as? CKRecord,
            let progress = notification.userInfo?[CCContact.ContactNotificationProgressInfoKey] as? Float, progress == 1 {
            for i in 0...cards.count {
                if record.recordIdentifier == cards[i].record.recordIdentifier {
                    cards.remove(at: i);
                    tableView.deleteRows(at: [IndexPath.init(row: i, section: 0)], with: .automatic)
                    
                    if cards.count == 0 {
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
            }
        }
    }
    
    func addAllContacts(sender:UIBarButtonItem) -> Void {
        for card in cards {
            card.execute(completed: nil)
        }
    }
    
    func dismissClicked(sender:UIBarButtonItem) -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDataSource -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addContactCellIdentifier", for: indexPath)
        if let addContactTableViewCell = cell as? AddContactTableViewCell {
            addContactTableViewCell.addContactCardCommand = self.cards[indexPath.row]
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
}
