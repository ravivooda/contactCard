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
        print("Requesting API \(api) with method \(method) and parameters \(parameters ?? [:])")
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
                print(error)
                viewController?.hideLoading(error.localizedDescription)
                fail?([:], response)
            }
        }
    }
    
    static func apiPerform(_ query:CKQuery, inZoneWith zoneID:CKRecordZoneID?, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        apiPerform(query, inZoneWith:nil, database: Manager.contactsContainer.privateCloudDatabase, viewController: viewController, success: success, fail: fail)
    }
    
    static func apiPerform(_ query:CKQuery, inZoneWith zoneID:CKRecordZoneID?, database:CKDatabase, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        database.perform(query, inZoneWith: zoneID) { (records, error) in
            apiResponse(records, error: error, viewController: viewController, success: success, fail: fail)
        }
    }
    
    static private func apiResponse(_ records:[CKRecord]?, error:Error?, viewController:UIViewController?, success:newSuccess?, fail:newFail?) {
        if let error = error {
            reportError(error: error, fail: fail)
        } else {
            reportSuccess(success: success, records: records ?? [])
        }
    }
    
    static func reportError(error:Error, fail:newFail?) {
        DispatchQueue.main.async {
            fail?(error.localizedDescription, error)
        }
    }
    
    static func reportSuccess(success:newSuccess?, records:[CKRecord]) {
        DispatchQueue.main.async {
            success?(records)
        }
    }
    
    static func apiSave(_ record:CKRecord, viewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        apiSave(record, database: Manager.contactsContainer.privateCloudDatabase, viewController: viewController, success: success, fail: fail)
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
