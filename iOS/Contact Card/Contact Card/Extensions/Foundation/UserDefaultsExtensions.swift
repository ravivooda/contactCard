//
//  UserDefaultsExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/29/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var isAutoSyncEnabled:Bool {
        get {
            if let _ = UserDefaults.standard.object(forKey: "autoUpdateContact") {
                return UserDefaults.standard.bool(forKey: "autoUpdateContact")
            }
            return true
        }
    }
    
}
