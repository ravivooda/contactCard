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
    let cnController:CCContactViewController
    
    
    init(contact:CNContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        self.cnController = CCContactViewController(for: self.contact)
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        cnController.allowsEditing = false
        cnController.allowsActions = false
        cnController.delegate = self
        cnController.command = self
        if let navigationController = presentingViewController.navigationController {
            navigationController.pushViewController(cnController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: cnController)
            cnController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismiss(sender:)))
            presentingViewController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    @objc func dismiss(sender:Any) -> Void {
        print("Dismissing shown controller")
        cnController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CNContactViewControllerDelegate -
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
}
