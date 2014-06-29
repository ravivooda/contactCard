//
//  MNNetworkManager.m
//  Contact Card
//
//  Created by Ravi Vooda on 06/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNNetworkManager.h"

@interface MNNetworkManager ()

@property (strong, nonatomic) NSOperationQueue *operationsQueue;
@property (strong, nonatomic) NSMutableArray *operationsArray;

@end

@implementation MNNetworkManager

-(void) sendContactCard:(Contact *)contactCard viaMedium:(sharingOptions)sharingOption withCompletionBlock:(CompletionBlock)completion withErrorBlock:(ErrorBlock)error {
    
}

-(void) sendCompanyCard:(MNCompany *)companyCard viaMedium:(sharingOptions)sharingOption withCompletionBlock:(CompletionBlock)completion withErrorBlock:(ErrorBlock)error {
    
}

@end
