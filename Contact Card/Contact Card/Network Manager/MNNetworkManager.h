//
//  MNNetworkManager.h
//  Contact Card
//
//  Created by Ravi Vooda on 06/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCompany.h"

typedef enum{
    kAirDrop,
    kBluetooth,
    kPhoneNumber
} sharingOptions;

typedef void (^CompletionBlock)();
typedef void (^ErrorBlock)(NSError *error);

@interface MNNetworkManager : NSObject

-(void) sendContactCard:(MNContact*)contactCard viaMedium:(sharingOptions)sharingOption withCompletionBlock:(CompletionBlock)completion withErrorBlock:(ErrorBlock)error;

-(void) sendCompanyCard:(MNCompany*)companyCard viaMedium:(sharingOptions)sharingOption withCompletionBlock:(CompletionBlock)completion withErrorBlock:(ErrorBlock)error;

@end
