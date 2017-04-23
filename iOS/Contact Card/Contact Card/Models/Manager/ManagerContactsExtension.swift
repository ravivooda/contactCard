//
//  ManagerContactsExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/18/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import Contacts

extension Manager {
    static let contactsStore = CNContactStore()
    
    /*func subscribeForContactsChanges() -> Void {
        // First fetch all the shared objects
        Data.syncContacts(contactIDs: [], callingViewController: nil, success: { (records) in
            // Now fetch all the subscriptions
            Data.fetchSubscriptions(callingViewController: nil, success: { (subscriptionsMap) in
                /*for record in records {
                    if let first = record["owner_first_name"] as? String, let last = record["owner_last_name"] as? String {
                        let predicate = NSPredicate(format: "owner_first_name == %@ AND owner_last_name == %@", first, last)
                        print(predicate)
                        let subscriptionIdentifier = "\(first).\(record.recordID.recordName)"
                        print(record.creatorUserRecordID?.recordName ?? "")
                        let subscription = CKDatabaseSubscription(recordType: Manager.contactsRecordType, predicate: predicate, subscriptionID: subscriptionIdentifier, options: .firesOnRecordUpdate)
                        
                        let notification = CKNotificationInfo()
                        notification.alertBody = "An update for \(first) \(last) is available"
                        notification.soundName = "default"
                        
                        subscription.notificationInfo = notification
                        
                        Manager.contactsContainer.sharedCloudDatabase.save(subscription) { result, error in
                            if let error = error {
                                print(error.localizedDescription)
                                self.scheduleSync(after: 300)
                            } else if let result = result {
                                print(result)
                                print("Subscribed to \(first) \(last)'s changes")
                            }
                        }
                    } else {
                        print("Did not find first and last name for \(record)")
                    }
                }*/
                
                // Delete previous subscriptions
                print(subscriptionsMap)
                for (_, subscription) in subscriptionsMap {
                    Manager.contactsContainer.sharedCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                        if error != nil {
                            // do your error handling here!
                            print(error!.localizedDescription)
                            self.scheduleSync(after: 300)
                        }
                    }
                }
            }, fail: { (errorMessage, error) in
                print(errorMessage)
                self.scheduleSync(after: 20)
            })
        }, fail: { (errorMessage, error) in
            print(errorMessage)
            self.scheduleSync(after: 20)
        })
    }
    
    static private var hasScheduled = false
    private func scheduleSync(after secs:Double) -> Void {
        if Manager.hasScheduled {
            print("Already scheduled, ignore")
            return
        }
        Manager.hasScheduled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + secs, execute: {
            self.subscribeForContactsChanges()
            Manager.hasScheduled = false
        })
    }*/
}
