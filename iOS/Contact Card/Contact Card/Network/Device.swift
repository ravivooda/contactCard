//
//  Device.swift
//  Contact Card
//
//  Created by Ravi Vooda on 3/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    static func registerDevice(userID:String, deviceToken:String, success:@escaping Success, fail:@escaping Fail) -> Void {
        let parameters = ["device_id": deviceToken,
                          "device_type": "ios",
                          "user_id": userID]
        api(.post, api: "device", parameters: parameters, viewController: nil, success: success, fail: fail)
    }
}
