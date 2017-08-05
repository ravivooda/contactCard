//
//  PurchaseAdditionalCardsCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/13/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import StoreKit
import SwiftKeychainWrapper

class PurchaseAdditionalCardsCommand: Command, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static var userHasPremiumAccount: Bool {
        return false //KeychainWrapper.standard.bool(forKey: userHasPremiumAccountKey) ?? false
    }
    
    static private let userHasPremiumAccountKey = "ContactCard.userHasPremiumAccount"
    
    private let productRequest:SKProductsRequest
    private var product:SKProduct?
    
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
        
        guard SKPaymentQueue.canMakePayments() else {
            return self.reportError(message: "This device or user account seems to be disabled for purchases. Maybe parental controls? Please retry later")
        }
        
        self.productRequest.start()
        
        let purchaseCardsController = self.presentingViewController.storyboard!.instantiateViewController(withIdentifier: "upgradeViewController") as! UpgradeAccountViewController
        purchaseCardsController.command = self
        self.presentingViewController.present(purchaseCardsController, animated: true, completion: nil)
        self.presentedViewController = purchaseCardsController
        self.disableUserInteraction()
        SKPaymentQueue.default().add(self)
    }
    
    func buy() {
        let payment = SKMutablePayment(product: self.product!)
        SKPaymentQueue.default().add(payment)
        self.disableUserInteraction()
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func enableUserInteraction() {
        let upgradeViewController = self.presentedViewController as! UpgradeAccountViewController
        upgradeViewController.buyButton.isEnabled = true
        upgradeViewController.restoreButton.isEnabled = true
    }
    
    func disableUserInteraction() {
        let upgradeViewController = self.presentedViewController as! UpgradeAccountViewController
        upgradeViewController.buyButton.isEnabled = false
        upgradeViewController.restoreButton.isEnabled = false
    }
    
    //MARK: - SKProductsRequestDelegate -
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Received response: \(response)")
        print("Products: \(response.products)")
        print("Invalid products: \(response.invalidProductIdentifiers)")
        let products = response.products
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
            if p.productIdentifier == AppDelegate.moreCardsPurchaseProductIdentifier,
                let purchaseCardsController = self.presentedViewController as? UpgradeAccountViewController {
                self.product = p
                self.enableUserInteraction()
                let priceFormatter = NumberFormatter()
                priceFormatter.formatterBehavior = .behavior10_4
                priceFormatter.numberStyle = .currency
                priceFormatter.locale = p.priceLocale
                purchaseCardsController.buyButton.setTitle("Buy \(priceFormatter.string(from: p.price) ?? "0.")", for: .normal)
                return
            }
        }
        
        let alertController = UIAlertController(title: "Contact Card", message: "Unable to find the product information. This incident is reported to our team. Please try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: { (action) in
            self.returningCommand = nil
            self.finished()
        }))
        self.presentedViewController!.present(alertController, animated: true, completion: nil)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error occurred in fetching products \(error.localizedDescription)")
        self.reportRetryError(message: "An error occurred in requesting product information")
    }
    
    //MARK: - SKPaymentTransactionObserver -
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Completed Transaction \(transaction)")
        SKPaymentQueue.default().finishTransaction(transaction)
        KeychainWrapper.standard.set(true, forKey: PurchaseAdditionalCardsCommand.userHasPremiumAccountKey)
        self.finished()
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {
            return self.reportError(message: "This was not expected.")
        }
        
        print("Restore Transaction - \(transaction), product - \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
        if productIdentifier == AppDelegate.moreCardsPurchaseProductIdentifier {
            KeychainWrapper.standard.set(true, forKey: PurchaseAdditionalCardsCommand.userHasPremiumAccountKey)
            self.finished()
        }
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("Failed Transaction - \(transaction)")
        self.reportError(message: transaction.error?.localizedDescription ?? "Unknown error occurred")
        
        SKPaymentQueue.default().finishTransaction(transaction)
        self.enableUserInteraction()
    }
    
    override func finished() {
        self.presentedViewController!.dismiss(animated: true) { 
            super.finished()
        }
    }
}
