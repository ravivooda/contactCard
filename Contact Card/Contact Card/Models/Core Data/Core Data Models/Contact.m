//
//  Contact.m
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "Contact.h"
#import "Address.h"
#import "Card.h"
#import "Email.h"
#import "PhoneNumber.h"


@implementation Contact

@dynamic contactID;
@dynamic notes;
@dynamic website;
@dynamic twitterUserName;
@dynamic linkedInUserName;
@dynamic facebookUserName;
@dynamic departmentName;
@dynamic companyName;
@dynamic jobTitle;
@dynamic secondaryTitle;
@dynamic firstTitle;
@dynamic nickName;
@dynamic suffixName;
@dynamic lastName;
@dynamic middleName;
@dynamic firstName;
@dynamic prefixName;
@dynamic imageOfPerson;
@dynamic address;
@dynamic emails;
@dynamic phoneNumbers;
@dynamic card;

#pragma mark - Different initializations
-(Contact*) initWithContactCard:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.imageOfPerson = [dictionary objectForKey:@"image"];
        
        self.suffixName = [dictionary objectForKey:kContactsuffixName];
        self.firstName = [dictionary objectForKey:kContactfirstName];
        self.lastName = [dictionary objectForKey:kContactlastName];
        self.middleName = [dictionary objectForKey:kContactmiddleName];
        self.nickName = [dictionary objectForKey:kContactnickName];
        
        self.firstTitle = [dictionary objectForKey:kContactfirstTitle];
        self.secondaryTitle = [dictionary objectForKey:kContactsecondaryTitle];
        self.jobTitle = [dictionary objectForKey:kContactjobTitle];
        
    }
    return self;
}

-(NSDictionary*) dictionaryOfContactCard {
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:self.imageOfPerson forKey:@"image"];
    
    [retDictionary setObject:self.suffixName forKey:kContactsuffixName];
    [retDictionary setObject:self.firstName forKey:kContactfirstName];
    [retDictionary setObject:self.lastName forKey:kContactlastName];
    [retDictionary setObject:self.middleName forKey:kContactmiddleName];
    [retDictionary setObject:self.nickName forKey:kContactnickName];
    
    [retDictionary setObject:self.firstTitle forKey:kContactfirstTitle];
    [retDictionary setObject:self.secondaryTitle forKey:kContactsecondaryTitle];
    return retDictionary;
}

- (Contact*) initWithRecordReference:(ABRecordRef)ref {
    self = [super init];
    if (self) {
        
        //        self.recordRef = ref;
        
        if (ABPersonHasImageData(ref)) {
            self.imageOfPerson = (__bridge NSData *)(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatOriginalSize));
        }
        
        self.prefixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonPrefixProperty));
        self.firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        self.lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
        self.middleName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonMiddleNameProperty));
        self.suffixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonSuffixProperty));
        self.nickName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonNicknameProperty));
        
        if (self.firstName && self.lastName) {
            self.firstTitle = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
        } else if (self.firstName) {
            self.firstTitle = [NSString stringWithFormat:@"%@",self.firstName];
        } else if (self.lastName) {
            self.firstTitle = [NSString stringWithFormat:@"%@",self.lastName];
        } else {
            self.firstTitle = @"Unknown Contact";
        }
        
        self.companyName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
        self.jobTitle = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonJobTitleProperty));
        self.departmentName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonDepartmentProperty));
        
        if (self.jobTitle && self.companyName) {
            self.secondaryTitle = [NSString stringWithFormat:@"%@, %@",self.jobTitle,self.companyName];
        } else if (self.jobTitle) {
            self.secondaryTitle = [self.jobTitle copy];
        } else if (self.companyName) {
            self.secondaryTitle = [self.companyName copy];
        } else {
            self.secondaryTitle = @"";
        }
        
        ABMultiValueRef multiPhones = (ABRecordCopyValue(ref, kABPersonPhoneProperty));
        NSMutableArray *phoneArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            PhoneNumber *phoneNumber = [[PhoneNumber alloc] init];
            phoneNumber.phoneNumber = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyValueAtIndex(multiPhones, i)));
            phoneNumber.labelName = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyLabelAtIndex(multiPhones, i)));
            [phoneArr addObject:phoneNumber];
        }
        self.phoneNumbers = [[NSSet alloc] initWithArray:phoneArr];
        
        ABMultiValueRef multiEmails = (ABRecordCopyValue(ref, kABPersonEmailProperty));
        NSMutableArray *emailsArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiEmails); i++) {
            Email *email = [[Email alloc] init];
            email.labelName = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyLabelAtIndex(multiPhones, i)));
            email.email = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyValueAtIndex(multiEmails, i)));
            [emailsArr addObject:email];
        }
        self.emails = [[NSSet alloc] initWithArray:emailsArr];
        
        ABMultiValueRef socialApps = (ABRecordCopyValue(ref, kABPersonSocialProfileProperty));
        for (int i = 0; i < ABMultiValueGetCount(socialApps); i++) {
            NSDictionary *socialItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(socialApps, i);
            if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceFacebook]) {
                self.facebookUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceTwitter]) {
                self.twitterUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceLinkedIn]) {
                self.linkedInUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            }
        }
        
        ABMultiValueRef urls = (ABRecordCopyValue(ref, kABPersonURLProperty));
        if (ABMultiValueGetCount(urls) > 0) {
            self.website = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(urls, 0));
        }
        
        ABMultiValueRef addresses = (ABRecordCopyValue(ref, kABPersonAddressProperty));
        if (ABMultiValueGetCount(addresses) > 0) {
            NSDictionary *addressItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(addresses, 0);
            self.address = [[Address alloc] initWithAddressDictionary:addressItem];
        }
        
//        self.notesOfContact = (__bridge NSString*)(ABRecordCopyValue(ref, kABPersonNoteProperty));
        
    }
    return self;
}

-(ABRecordRef) convertToRecordRef {
#warning incomplete
    return nil;
}

+(NSArray*) getContactCardsFromReference:(ABRecordRef)ref {
    return nil;
}


@end
