//
//  MNUpgradeHelper.h
//  Contact Card
//
//  Created by Ravi Vooda on 20/07/14.
//  Copyright (c) 2014 Ravi Vooda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

UIKIT_EXTERN NSString *const MNHelperUpgradePurchasedNotification;

@interface MNUpgradeHelper : NSObject

+(MNUpgradeHelper*) sharedInstance;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
