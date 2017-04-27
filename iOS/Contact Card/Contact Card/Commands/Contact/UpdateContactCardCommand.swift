//
//  UpdateContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import Contacts
import UIKit

class UpdateContactCardCommand: Command {
    let updateRecord:CKRecord
    let updatingContact:CCContact
    private var observers = [ContactUpdateDelegate]()
    
    init(contact:CCContact, record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.updatingContact = contact
        self.updateRecord = record
        super.init(viewController: viewController, returningCommand: nil)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        self.fetchAsset(shouldFetchDataIfNotAvailableReadily: true)
    }
    
    private func fetchAsset(shouldFetchDataIfNotAvailableReadily:Bool) {
        guard let asset = updateRecord[CNContact.ImageKey] as? CKAsset else {
            self.completeUpdate(imageData: nil)
            return
        }
        
        if let data = NSData(contentsOf: asset.fileURL) as Foundation.Data?, let _ = UIImage(data: data) {
            self.completeUpdate(imageData: data)
            return
        }
        
        if !shouldFetchDataIfNotAvailableReadily {
            self.completeUpdate(imageData: nil)
            return
        }
        
        // Updates are always fetched from share cloud database
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.updateRecord.recordID, completionHandler: { (record, error) in
            DispatchQueue.main.async {
                guard error != nil else {
                    for observer in self.observers {
                        observer.contactUpdateError(error: error!)
                    }
                    return
                }
                
                guard record != nil else {
                    for observer in self.observers {
                        observer.contactUpdateError(error: UpdateContactError(message: "Unknown error occurred while fetching the contact information. Please make sure the device is connected to internet"))
                    }
                    return
                }
                
                self.fetchAsset(shouldFetchDataIfNotAvailableReadily: false)
            }
        })
    }
    
    private func completeUpdate(imageData:Foundation.Data?) -> Void {
        if let mutableContact = updatingContact.contact.mutableCopy() as? CNMutableContact, let payload = updateRecord[CNContact.CardJSONKey] as? String, let data = convertToDictionary(text: payload) {
            mutableContact.parse(payload: data)
            mutableContact.imageData = imageData
            
            // Save the contact
            let saveRequest = CNSaveRequest()
            saveRequest.update(mutableContact)
            do {
                try CNContactStore().execute(saveRequest)
            } catch let error as NSError {
                print("Error occurred in saving contact update \(error)")
            }
        }
    }
    
    func addObserver(_ observer:ContactUpdateDelegate) -> Void {
        DispatchQueue.main.async {
            for _observer in self.observers {
                if observer === _observer {
                    return
                }
            }
            self.observers.append(observer)
        }
    }
    
    func removeObserver(_ observer:ContactUpdateDelegate) -> Void {
        DispatchQueue.main.async {
            var _observers = [ContactUpdateDelegate]()
            for _observer in self.observers {
                if observer !== _observer {
                    _observers.append(_observer)
                }
            }
            self.observers = _observers
        }
    }
}
