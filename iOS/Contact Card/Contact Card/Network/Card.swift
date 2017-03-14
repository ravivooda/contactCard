//
//  Card.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/12/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    static func addCard(data:[String: Any], callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        api(.put, api: "card", parameters: [ "data" : data.json ], viewController: callingViewController, success: success, fail: fail)
    }
    
    static func myCards(callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        api(.get, api: "card", parameters: nil, viewController: nil, success: success, fail: fail)
    }
    
    static func editCard(data:[String: Any], callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        api(.post, api: "card", parameters: [ "data" : data.json ], viewController: callingViewController, success: success, fail: fail)
    }
}
