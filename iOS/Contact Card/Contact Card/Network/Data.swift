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
	
	static let serverURL = "http://97.107.142.174:8080/api/"
    
    typealias Success = ([String: Any]) -> Void
    typealias Fail = ([String: Any], DataResponse<Any>) -> Void
    
	static func api(_ method:HTTPMethod, api:String, parameters:[String: Any]?, viewController:UIViewController?, success:Success?, fail:Fail?) -> Void {
        viewController?.showLoading()
		request(serverURL + api, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("Response: \(response)")
            switch response.result {
            case .success(let value):
                viewController?.hideLoading(nil)
                if let jsonResponse = value as? [String: Any], getBoolValue(jsonResponse["success"], defaultValue: false) {
                    success?(jsonResponse)
                } else {
                    fail?([:], response)
                }
            case .failure(let error):
                viewController?.hideLoading(error.localizedDescription)
                fail?([:], response)
            }
        }
    }
}
