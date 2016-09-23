//
//  StringExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import Foundation

func isEmpty(object:String?) -> Bool {
    return object == nil || object!.trim().characters.count == 0
}

func getStringValue(object:AnyObject?, defaultValue:String = "") -> String {
    if object == nil || (object as? String) == nil {
        return defaultValue
    }
    return object as! String
}

extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
