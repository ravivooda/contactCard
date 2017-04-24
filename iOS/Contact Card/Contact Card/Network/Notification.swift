//
//  Notification.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/18/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

typealias SubscriptionSuceess = ([String: CKSubscription]) -> Void

extension Data {
    static func fetchSubscriptions(callingViewController:UIViewController?, success:SubscriptionSuceess?, fail:newFail?) -> Void {
        let fetchSubscriptionsOperation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()
        fetchSubscriptionsOperation.fetchSubscriptionCompletionBlock = {
            subs, error in
            if let e = error {
                fail?(e.localizedDescription, e)
                return
            }
            success?(subs ?? [:])
        }
        Manager.contactsContainer.sharedCloudDatabase.add(fetchSubscriptionsOperation)
    }
    
    struct RecordShareError:Error{
        let message:String
        init(errorMessage:String) {
            self.message = errorMessage
        }
        
        var localizedDescription: String {
            return message
        }
    }
    
    static func sendUpdateNotification(forRecord record:CKRecord, message:String, viewController:UIViewController?, success:newSuccess?, fail:newFail?) {
        if let s = record.share {
            // let participants = share.participants
            Manager.contactsContainer.privateCloudDatabase.fetch(withRecordID: s.recordID, completionHandler: { (shareRecord, error) in
                if let share = shareRecord as? CKShare {
                    var participantUserIDs = [String]()
                    for participant in share.participants {
                        if let userID = participant.userIdentity.userRecordID?.recordName {
                            participantUserIDs.append(userID)
                        }
                    }
                    let parameters = ["users" : participantUserIDs.joined(separator: ","),
                                      "message": message]
                    api(.post, api: "notify", parameters: parameters, viewController: nil, success: { (response) in
                        print("Succefully sent update to users \(participantUserIDs) for record \(record)")
                        self.reportSuccess(success: success, records: [])
                    }, fail: { (errorResponse, HTTPResponse) in
                        print("Error occurred in sending update to the users response \(errorResponse)")
                        self.reportError(error: RecordShareError(errorMessage: ""), fail: fail)
                    })
                }
            })
        } else {
            self.reportError(error: RecordShareError(errorMessage: "No share setup for this record"), fail: fail)
        }
    }
}
