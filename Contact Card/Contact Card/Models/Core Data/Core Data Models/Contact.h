//
//  Contact.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Card, Email, PhoneNumber;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * twitterUserName;
@property (nonatomic, retain) NSString * linkedInUserName;
@property (nonatomic, retain) NSString * facebookUserName;
@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * secondaryTitle;
@property (nonatomic, retain) NSString * firstTitle;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * suffixName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * prefixName;
@property (nonatomic, retain) NSData * imageOfPerson;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phoneNumbers;
@property (nonatomic, retain) Card *card;

- (Contact*) initWithContactCard:(NSDictionary*) dictionary;

- (Contact*) initWithRecordReference:(ABRecordRef)ref;

- (ABRecordRef) convertToRecordRef;

+ (NSArray*) getContactCardsFromReference:(ABRecordRef)ref;

-(NSDictionary*) dictionaryOfContactCard;

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
