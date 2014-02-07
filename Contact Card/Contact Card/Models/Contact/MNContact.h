//
//  MNContact.h
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCompany.h"
#import "MNAddress.h"

@interface MNContact : NSObject <NSSecureCoding, UIActivityItemSource>

@property (strong, nonatomic, readonly) UIImage *imageOfPerson;

@property (strong, nonatomic, readonly) NSString *suffixName;
@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *middleName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *nickName;

@property (strong, nonatomic, readonly) NSString *firstTitle;
@property (strong, nonatomic, readonly) NSString *secondaryTitle;
@property (strong, nonatomic, readonly) NSString *jobTitle;
@property (strong, nonatomic, readonly) NSString *companyName;

#warning How many should be used, Phone numbers should be a list?
@property (strong, nonatomic, readonly) NSString *mainPhoneNumber;
@property (strong, nonatomic, readonly) NSString *homePhoneNumber;
@property (strong, nonatomic, readonly) NSString *mobileNumber;

@property (strong, nonatomic, readonly) NSString *personalEmail;
@property (strong, nonatomic, readonly) NSString *workEmail;

#warning Some Social Networking links Need to add more or remove
@property (strong, nonatomic, readonly) NSString *facebookUserName;
@property (strong, nonatomic, readonly) NSString *linkedInUserName;
@property (strong, nonatomic, readonly) NSString *twitterUserName;

#warning Address should be an array?
@property (strong, nonatomic, readonly) NSString *website;
@property (strong, nonatomic, readonly) NSString *address;
@property (strong, nonatomic, readonly) NSString *officeLocation;

@property (strong, nonatomic, readonly) NSString *notesOfContact;

- (MNContact*) initWithContactCard:(NSDictionary*) dictionary;

-(NSDictionary*) dictionaryOfContactCard;

@end
