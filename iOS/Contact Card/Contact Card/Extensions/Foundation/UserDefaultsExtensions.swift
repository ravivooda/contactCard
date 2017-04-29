//
//  UserDefaultsExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/29/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let autoSyncIdentifier = "autoUpdateContact"
    static var isAutoSyncEnabled:Bool {
        get {
            if let _ = UserDefaults.standard.object(forKey: autoSyncIdentifier) {
                return UserDefaults.standard.bool(forKey: autoSyncIdentifier)
            }
            return true
        }
    }
    
}
