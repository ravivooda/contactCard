//
//  CCMyCardsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CCMyCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCard(_ sender: Any) {
        let newCardViewController = CNContactViewController(forNewContact: nil)
        newCardViewController.contactStore = CNContactStore()
        newCardViewController.delegate = self
        self.present(UINavigationController(rootViewController: newCardViewController), animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDataSource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCellIdentifier", for: indexPath)
        return cell
    }
    
    //MARK: - UITableViewDelegate -
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        print("Completed adding card \(contact)")
        viewController.dismiss(animated: true) {
            if let _contact = contact?.mutableCopy() as? CNMutableContact{
                // Deleting the contact first
                let deleteRequest = CNSaveRequest()
                deleteRequest.delete(_contact)
                
                do {
                    try CNContactStore().execute(deleteRequest)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}
