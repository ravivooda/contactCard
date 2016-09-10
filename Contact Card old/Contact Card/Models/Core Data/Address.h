//
//  Address.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Ravi Vooda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) Contact *contactInfo;

@end
