//
//  StringExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import Foundation

func isEmpty(_ object:String?) -> Bool {
    return object == nil || object!.trim().characters.count == 0
}

func getStringValue(_ object:Any?, defaultValue:String = "") -> String {
    if object == nil || (object as? String) == nil {
        return defaultValue
    }
    return object as! String
}

func getIntValue(_ object:Any?, defaultValue:Int) -> Int {
    if object == nil || (object as? NSNumber) == nil {
        return defaultValue
    }
    return Int(object as! NSNumber)
}

func getBoolValue(_ object: Any?, defaultValue:Bool) -> Bool {
    if object == nil || (object as? Bool) == nil {
        return defaultValue
    }
    
    return object as! Bool
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
