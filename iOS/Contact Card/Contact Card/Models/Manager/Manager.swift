//
//  Manager.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Alamofire

class Manager: NSObject {
    
    fileprivate override init() {
        super.init()
    }
    
    static func defaultManager() -> Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
    
    func addNewCard(card:CCCard, success:Data.Success, fail:Data.Fail) -> Void {
        cards.append(card)
        success([:])
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
}
