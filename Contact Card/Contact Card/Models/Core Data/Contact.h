//
//  Contact.h
//  Contact Card
//
//  Created by Ravi Vooda on 20/07/14.
//  Copyright (c) 2014 Ravi Vooda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Card, Email, PhoneNumber;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSString * facebookUserName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * firstTitle;
@property (nonatomic, retain) NSData * imageOfPerson;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * linkedInUserName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * prefixName;
@property (nonatomic, retain) NSString * secondaryTitle;
@property (nonatomic, retain) NSString * suffixName;
@property (nonatomic, retain) NSString * twitterUserName;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSData * fullImage;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Card *card;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phoneNumbers;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addPhoneNumbersObject:(PhoneNumber *)value;
- (void)removePhoneNumbersObject:(PhoneNumber *)value;
- (void)addPhoneNumbers:(NSSet *)values;
- (void)removePhoneNumbers:(NSSet *)values;

@end
