//
//  Contact.swift
//  Contact Card
//
//  Created by Ravi Vooda on 3/25/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    static func syncContacts(contactIDs: [String], callingViewController:UIViewController?, success:@escaping Success, fail:@escaping Fail ) -> Void {
        
        api(.get, api: "contact", parameters: ["contact_ids" : contactIDs.joined(separator: ",")], viewController: callingViewController, success: success, fail: fail)
    }
}
