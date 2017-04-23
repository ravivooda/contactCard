//
//  ShowContactCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ShowContactCommand: Command, CNContactViewControllerDelegate {
    let contact:CNContact
    
    init(contact:CNContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let viewController = CNContactViewController(for: self.contact)
        viewController.allowsEditing = false
        viewController.allowsActions = false
        viewController.delegate = self
        presentingViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
