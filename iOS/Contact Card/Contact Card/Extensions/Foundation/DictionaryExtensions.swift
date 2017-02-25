//
//  DictionaryExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import Foundation

func isEmpty(_ object:[String: AnyObject]?) -> Bool {
    return object == nil || object!.count == 0
}

extension Dictionary {
    var json: String {
        let invalidJson = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
