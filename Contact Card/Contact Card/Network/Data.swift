//
//  Data.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Alamofire

class Data: NSObject {
    
    typealias Success = ([String: AnyObject]) -> Void
    typealias Fail = ([String: AnyObject], Response<AnyObject, NSError>) -> Void
    
    static func api(_ method:String, url:String, parameters:[String: AnyObject]?, viewController:UIViewController?, success:Success, fail:Fail) -> Void {
        if isEmpty(method) || isEmpty(url) {
            print("Invalid API call: method:\(method)\nurl:\(url)\nparameters:\(parameters)\nviewController:\(viewController)")
            let response = Response<AnyObject, NSError>(
                request: nil,
                response: nil,
                data: nil,
                result: Result.Failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: ["method": getStringValue(method, defaultValue: "Empty METHOD"), "url": getStringValue(url, defaultValue: "Empty URL"), "parameters":])),
                timeline: Timeline()
            )
            fail([:], response)
            return
        }
    }
    
}
