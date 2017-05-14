//
//  ShareCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit
import QRCode

class ShareCardCommand: Command, UICloudSharingControllerDelegate {
    let card:CCCard
    let database:CKDatabase
    
    var activity:UIActivity?
    
    init(withCard card:CCCard, database:CKDatabase, viewController:UIViewController, returningCommand: Command?) {
        self.database = database
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        let shareAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        shareAlertController.addAction(UIAlertAction(title: "QR Code", style: .default, handler: { (action) in
            self.showQRCode()
        }))
        shareAlertController.addAction(UIAlertAction(title: "Other", style: .default, handler: { (action) in
            self.showShareController()
        }))
        shareAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentingViewController.present(shareAlertController, animated: true, completion: nil)
    }
    
    override func reportError(message: String) {
        super.reportError(message: message)
        self.activity?.activityDidFinish(false)
    }
    
    override func reportRetryError(message: String) {
        super.reportRetryError(message: message)
        self.activity?.activityDidFinish(false)
    }
    
    private func showShareController() {
        let shareController = UICloudSharingController(preparationHandler: { (controller, preparationCompletionHandler) in
            guard let shareRef = self.card.record.share else {
                return self.reportError(message: "An unexpected error occurred while setting up the share.")
            }
            
            self.database.fetch(withRecordID: shareRef.recordID, completionHandler: { (shareRecord, error) in
                self.completePreparationForSharing(share: shareRecord as? CKShare, error: error, preparationCompletionHandler: preparationCompletionHandler)
            })
        })
        
        shareController.delegate = self
        shareController.availablePermissions = [.allowReadOnly,.allowPublic]
        self.presentingViewController.present(shareController, animated: true, completion: nil)
    }
    
    private func showQRCode(){
        guard let shareRef = self.card.record.share else {
            return self.presentingViewController.showAlertMessage(message: "Apologies. This cannot be shared")
        }
        
        self.database.fetch(withRecordID: shareRef.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil, let share = record as? CKShare else {
                    print("\(error?.localizedDescription ?? "No error occurred")")
                    return self.reportError(message: "An error occurred in fetching the share details. Please ensure that the device has active internet connection")
                }
                
                guard let url = share.url, let code = QRCode(url) else {
                    print("Share \(share) has no url")
                    return self.reportError(message: "Apologies. This cannot be shared")
                }
                
                let qrController = self.presentingViewController.storyboard?.instantiateViewController(withIdentifier: "qrShareViewControllerID") as! QRShareViewController
                qrController.code = code
                self.presentingViewController.present(qrController, animated: true, completion: nil)
            }
        }
    }
    
    private func completePreparationForSharing(share:CKShare?, error:Error?, preparationCompletionHandler:(CKShare?, CKContainer?, Error?) -> Swift.Void) {
        preparationCompletionHandler(share, Manager.contactsContainer, error)
    }
    
    //MARK: - UICloudSharingControllerDelegate -
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Cloud Sharing Controller did save")
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        print("Cloud Sharing controller did stop sharing")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Cloud sharing controller failed to save - \(error)")
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Sharing \(card.record[CNContact.CardNameKey] as? String ?? card.record.getContactName())"
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Foundation.Data? {
        return card.contact.thumbnailImageData
    }
}
