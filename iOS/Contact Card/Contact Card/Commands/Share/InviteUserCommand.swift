//
//  InviteUserCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class InviteUserCommand: Command, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    let contact:CNContact
    
    init(contact:CNContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        var waysToInvite = [UIAlertAction]()
        
        let sharingText = "Hey, checkout this cool app which maintains your contacts in a very sleak manner"
        let contactCardAppShareURL = URL(string: "http://itunes.com")!
        
        for phoneNumber in self.contact.phoneNumbers {
            waysToInvite.append(UIAlertAction(title: "\(phoneNumber.value.stringValue)", style: .default, handler: { (action) in
                if !MFMessageComposeViewController.canSendText() {
                    return self.reportRetryError(message: "Apologies. SMS service is not available")
                }
                
                let composeVC = MFMessageComposeViewController()
                composeVC.messageComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.recipients = [phoneNumber.value.stringValue]
                composeVC.body = sharingText
                
                composeVC.addAttachmentURL(contactCardAppShareURL, withAlternateFilename: "Contact Card App")
                
                // Present the view controller modally.
                self.presentingViewController.present(composeVC, animated: true, completion: nil)
            }))
        }
        
        for email in self.contact.emailAddresses {
            waysToInvite.append(UIAlertAction(title: "\(email.value)", style: .default, handler: { (action) in
                if !MFMailComposeViewController.canSendMail() {
                    return self.reportRetryError(message: "Apologies. Email service is not available")
                }
                
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                
                mailComposerVC.setToRecipients([email.value as String])
                mailComposerVC.setSubject("Cool app - Contact Card")
                mailComposerVC.setMessageBody("\(sharingText) - \(contactCardAppShareURL.absoluteString)", isHTML: false)
                
                self.presentingViewController.present(mailComposerVC, animated: true, completion: nil)
            }))
        }
        
        if waysToInvite.count > 0 {
            waysToInvite.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let inviteAlertController = UIAlertController(title: "Invite \(contact.attributedDisplayName.string)", message: "How would you like to invite them?", preferredStyle: .actionSheet)
            
            for way in waysToInvite {
                inviteAlertController.addAction(way)
            }
            
            self.presentingViewController.present(inviteAlertController, animated: true, completion: nil);
        } else {
            let activityViewController = UIActivityViewController(activityItems: [sharingText, contactCardAppShareURL], applicationActivities: [QRCodeActivity(storyBoard: self.presentingViewController.storyboard!)])
            self.presentingViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { 
            if result == .failed {
                self.reportRetryError(message: "Failed to send message")
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .failed {
                self.reportRetryError(message: "Failed to send email")
            }
        }
    }
}
