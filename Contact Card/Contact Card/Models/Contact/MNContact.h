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
#import "Contact.h"

@interface MNContact : NSObject <NSSecureCoding, UIActivityItemSource, NSCopying>

// Identifier of the card
@property (nonatomic, readonly) int contactID;

// Images
@property (strong, nonatomic, readonly) UIImage *imageOfPerson;
@property (strong, nonatomic, readonly) UIImage *backgroundImage;

// Identification i.e. Name
@property (strong, nonatomic, readonly) NSString *prefixName;
@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *middleName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSString *suffixName;
@property (strong, nonatomic, readonly) NSString *nickName;

// Maybe they want to show different details on the card
@property (strong, nonatomic, readonly) NSString *firstTitle;
@property (strong, nonatomic, readonly) NSString *secondaryTitle;

// Work Details
@property (strong, nonatomic, readonly) NSString *jobTitle;
@property (strong, nonatomic, readonly) NSString *companyName;
@property (strong, nonatomic, readonly) NSString *departmentName;

// Phone Number
@property (strong, readonly, nonatomic) NSArray *phoneNumbers;

// Email
@property (strong, nonatomic, readonly) NSArray *emails;

#warning Some Social Networking links Need to add more or remove
// Social Networking links
@property (strong, nonatomic, readonly) NSString *facebookUserName;
@property (strong, nonatomic, readonly) NSString *linkedInUserName;
@property (strong, nonatomic, readonly) NSString *twitterUserName;

// Website
@property (strong, nonatomic, readonly) NSString *website;

// Addresses
@property (strong, nonatomic, readonly) MNAddress *address;

// Notes
@property (strong, nonatomic, readonly) NSString *notesOfContact;

- (MNContact*) initWithContactCard:(NSDictionary*) dictionary;

- (MNContact*) initWithRecordReference:(ABRecordRef)ref;

- (ABRecordRef) convertToRecordRef;

-(id) initWithContact:(Contact*)contact;

+ (NSArray*) getContactCardsFromReference:(ABRecordRef)ref;

-(NSDictionary*) dictionaryOfContactCard;

@end
