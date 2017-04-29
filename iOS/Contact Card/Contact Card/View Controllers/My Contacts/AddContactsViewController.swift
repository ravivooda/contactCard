//
//  AddContactsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class AddContactsViewController: UITableViewController {
    var cards:[AddContactCardCommand] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add All", style: .done, target: self, action: #selector(addAllContacts(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(deleteAllContacts(sender:)))
        self.title = "New Contacts"
    }
    
    func addAllContacts(sender:UIBarButtonItem) -> Void {
        for card in cards {
            card.execute(completed: nil)
        }
    }
    
    func deleteAllContacts(sender:UIBarButtonItem) -> Void {
        for card in cards {
            card.deleteContact(completed: nil)
        }
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
