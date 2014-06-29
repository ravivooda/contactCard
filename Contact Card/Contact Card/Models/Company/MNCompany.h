//
//  MNCompany.h
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "MNAddress.h"

@interface MNCompany : NSObject

@property (strong, nonatomic, readonly) UIImage *imageOfCompany;
@property (strong, nonatomic, readonly) UIImage *backgroundImage;

@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;

@property (strong, nonatomic, readonly) NSString *brandName;
#warning need to rename realName
@property (strong, nonatomic, readonly) NSString *companyName;
@property (strong, nonatomic, readonly) NSString *tagLine;

@property (strong, nonatomic, readonly) NSString *phoneNumber;
@property (strong, nonatomic, readonly) NSString *email;

@property (strong, nonatomic, readonly) NSString *facebookUserName;
@property (strong, nonatomic, readonly) NSString *linkedInUserName;
@property (strong, nonatomic, readonly) NSString *twitterUserName;

@property (strong, nonatomic, readonly) NSString *website;
@property (strong, nonatomic, readonly) NSString *blog;
@property (strong, nonatomic, readonly) NSString *news;

@property (strong, nonatomic, readonly) MNAddress *address;

@property (strong, nonatomic, readonly) NSString *notes;

- (MNCompany*) initWithRecordReference:(ABRecordRef)ref;


@end
