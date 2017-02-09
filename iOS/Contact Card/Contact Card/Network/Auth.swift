//
//  Auth.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import Foundation
import UIKit

extension Data {
	static func login(_ username:String, password:String, callingViewController:UIViewController, success:Success?, fail:Fail?) {
		//http://api/login?email=test@test.com&password=test
		api(.get, api: "login", parameters: ["email":"test@test.com", "password":"test"], viewController: callingViewController, success: success, fail: fail)
    }
}
