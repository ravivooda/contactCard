//
//  MNPhoneNumber.h
//  Contact Card
//
//  Created by Ravi Vooda on 22/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNPhoneNumber : NSObject <NSSecureCoding, NSCopying>

@property (strong, readonly, nonatomic) NSString *labelName;
@property (strong, readonly, nonatomic) NSString *phoneNumber;

- (MNPhoneNumber*) initWithLabelName:(NSString*)labelName andPhoneNumber:(NSString*)phoneNumber;

@end