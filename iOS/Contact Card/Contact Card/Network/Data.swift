//
//  Data.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Alamofire
import CloudKit

class Data: NSObject {
    
    static let serverURL = "http://97.107.142.174:8080/api/"
    
    typealias Success = ([String: Any]) -> Void
    typealias newSuccess = ([CKRecord]) -> Void
    typealias Fail = ([String: Any], DataResponse<Any>) -> Void
    typealias newFail = (String, Error) -> Void
    
    static func api(_ method:HTTPMethod, api:String, parameters:[String: Any]?, viewController:UIViewController?, success:Success?, fail:Fail?) -> Void {
        viewController?.showLoading()
        print("Requesting API \(api) with method \(method) and parameters \(parameters)")
        request(serverURL + api, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
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
    
    static func apiPerform(_ query:CKQuery, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        apiPerform(query, database: CKContainer.default().privateCloudDatabase, viewController: viewController, success: success, fail: fail)
    }
    
    static func apiPerform(_ query:CKQuery, database:CKDatabase, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        database.perform(query, inZoneWith: nil) { (records, error) in
            apiResponse(records, error: error, viewController: viewController, success: success, fail: fail)
        }
    }
    
    static private func apiResponse(_ records:[CKRecord]?, error:Error?, viewController:UIViewController?, success:newSuccess?, fail:newFail?) {
        DispatchQueue.main.async {
            if (error != nil) {
                fail?(error!.localizedDescription, error!)
            } else {
                let data = records ?? []
                success?(data)
            }
        }
    }
    
    static func apiSave(_ record:CKRecord, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        apiSave(record, database: CKContainer.default().privateCloudDatabase, viewController: viewController, success: success, fail: fail)
    }
    
    static func apiSave(_ record:CKRecord, database:CKDatabase, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        database.save(record) { (record, error) in
            var records = [CKRecord]()
            if record != nil {
                records.append(record!)
            }
            apiResponse(records, error: error, viewController: viewController, success: success, fail: fail)
        }
    }
}
