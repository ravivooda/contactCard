//
//  PhoneNumber.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface PhoneNumber : NSManagedObject

@property (nonatomic, retain) NSString * labelName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) Contact *contactInfo;

@end
