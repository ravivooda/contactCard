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
    typealias Fail = ([String: AnyObject], DataResponse<Any>) -> Void
    
    static func api(_ method:HTTPMethod, url:String, parameters:[String: AnyObject]?, viewController:UIViewController?, success:Success) -> Void {
        viewController?.showLoading()
        request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("Response: \(response)")
            switch response.result {
            case .success(let value):
                viewController?.hideLoading(nil)
                print("Value: \(value)")
            case .failure(let error):
                viewController?.hideLoading(error.localizedDescription)
            }
        }
    }
}
