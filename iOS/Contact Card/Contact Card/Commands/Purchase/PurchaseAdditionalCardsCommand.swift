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
        print("Requesting product identifiers: \(productIdentifiers)")
        self.productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        super.init(viewController: viewController, returningCommand: returningCommand)
        self.productRequest.delegate = self
        
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        self.productRequest.start()
        
        let purchaseCardsController = self.presentingViewController.storyboard!.instantiateViewController(withIdentifier: "upgradeViewController") as! UpgradeAccountViewController
        purchaseCardsController.command = self
        self.presentingViewController.present(purchaseCardsController, animated: true, completion: nil)
        self.presentedViewController = purchaseCardsController
    }
    
    func buy() {
        
    }
    
    func redeem() {
        
    }
    
    //MARK: - SKProductsRequestDelegate -
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Received response: \(response)")
        print("Products: \(response.products)")
        print("Invalid products: \(response.invalidProductIdentifiers)")
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
