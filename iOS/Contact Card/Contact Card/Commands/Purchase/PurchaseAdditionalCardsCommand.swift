//
//  PurchaseAdditionalCardsCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/13/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseAdditionalCardsCommand: Command, SKProductsRequestDelegate {
    private let productRequest:SKProductsRequest
    
    override init(viewController: UIViewController, returningCommand: Command!) {
        var productIdentifiers = Set<String>()
        productIdentifiers.insert(AppDelegate.moreCardsPurchaseProductIdentifier)
        
        self.productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        super.init(viewController: viewController, returningCommand: returningCommand)
        self.productRequest.delegate = self
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        self.productRequest.start()
    }
    
    //MARK: - SKProductsRequestDelegate -
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Received response: \(response)")
        let products = response.products
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error occurred in fetching products \(error.localizedDescription)")
        self.reportRetryError(message: "An error occurred in requesting payment")
    }
}
