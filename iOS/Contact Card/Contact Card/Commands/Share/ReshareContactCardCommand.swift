//
//  ReshareContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/30/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class ReshareContactCardCommand: Command {
    let contact:CCContact
    
    init(contact:CCContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        if let share = self.contact.record?.share {
			self.fetchShareDetails(shareReference: share)
        } else {
            // This should never be executed.
            self.reportError(message: "Apologies. This contact cannot be shared")
        }
    }
    
    func fetchShareDetails(shareReference:CKReference) {
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: shareReference.recordID) { (record, error) in
            guard error == nil, let url = (record as? CKShare)?.url else {
                return self.reportError(message: error?.localizedDescription ?? "An error occurred in fetching share details for contact \(self.contact.displayName())")
            }
            
            DispatchQueue.main.async {
                let name = "Sharing contact \(self.contact.displayName())"
                let activityViewController = UIActivityViewController(activityItems: [name, url], applicationActivities: [QRCodeActivity(storyBoard: self.presentingViewController.storyboard!)])
                self.presentingViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
