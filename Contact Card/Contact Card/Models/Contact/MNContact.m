//
//  MNContact.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContact.h"

@implementation MNContact

-(id) init {
    self = [super init];
    if (self) {
        _firstName = @"Ravi";
        _lastName = @"Vooda";
        _imageOfPerson = [UIImage imageNamed:@"cat"];
    }
    return self;
}

#pragma mark - NSCoding implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    
}

//@property (strong, nonatomic, readonly) NSString *jobTitle;
//@property (strong, nonatomic, readonly) NSString *companyName;
//
//#warning How many should be used, Phone numbers should be a list?
//@property (strong, nonatomic, readonly) NSString *mainPhoneNumber;
//@property (strong, nonatomic, readonly) NSString *homePhoneNumber;
//@property (strong, nonatomic, readonly) NSString *mobileNumber;
//
//@property (strong, nonatomic, readonly) NSString *personalEmail;
//@property (strong, nonatomic, readonly) NSString *workEmail;
//
//#warning Some Social Networking links Need to add more or remove
//@property (strong, nonatomic, readonly) NSString *facebookUserName;
//@property (strong, nonatomic, readonly) NSString *linkedInUserName;
//@property (strong, nonatomic, readonly) NSString *twitterUserName;

//#warning Address should be an array?
//@property (strong, nonatomic, readonly) NSString *website;
//@property (strong, nonatomic, readonly) NSString *address;
//@property (strong, nonatomic, readonly) NSString *officeLocation;
//
//@property (strong, nonatomic, readonly) NSString *notesOfContact;

-(MNContact*) initWithContactCard:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _imageOfPerson = [dictionary objectForKey:@"image"];
        
        _suffixName = [dictionary objectForKey:kContactsuffixName];
        _firstName = [dictionary objectForKey:kContactfirstName];
        _lastName = [dictionary objectForKey:kContactlastName];
        _middleName = [dictionary objectForKey:kContactmiddleName];
        _nickName = [dictionary objectForKey:kContactnickName];
        
        _firstTitle = [dictionary objectForKey:kContactfirstTitle];
        _secondaryTitle = [dictionary objectForKey:kContactsecondaryTitle];
        _jobTitle = [dictionary objectForKey:kContactjobTitle];
        
    }
    return self;
}

-(NSDictionary*) dictionaryOfContactCard {
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:_imageOfPerson forKey:@"image"];
    
    [retDictionary setObject:_suffixName forKey:kContactsuffixName];
    [retDictionary setObject:_firstName forKey:kContactfirstName];
    [retDictionary setObject:_lastName forKey:kContactlastName];
    [retDictionary setObject:_middleName forKey:kContactmiddleName];
    [retDictionary setObject:_nickName forKey:kContactnickName];
    
    [retDictionary setObject:_firstTitle forKey:kContactfirstTitle];
    [retDictionary setObject:_secondaryTitle forKey:kContactsecondaryTitle];
    return retDictionary;
}

- (MNContact*) initWithRecordReference:(ABRecordRef)ref {
    self = [super init];
    if (self) {
        
#warning Need to set the background image to some default image.
        
        if (ABPersonHasImageData(ref)) {
            NSData *imageData = (__bridge NSData *)(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatOriginalSize));
            _imageOfPerson = [UIImage imageWithData:imageData];
        }
        
        _prefixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonPrefixProperty));
        _firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        _lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
        _middleName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonMiddleNameProperty));
        _suffixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonSuffixProperty));
        _nickName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonNicknameProperty));
        
        _firstTitle = [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
        
        _companyName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
        _jobTitle = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonJobTitleProperty));
        _departmentName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonDepartmentProperty));
        
        _secondaryTitle = [NSString stringWithFormat:@"%@, %@",_jobTitle,_companyName];
        
        ABMultiValueRef multiPhones = (ABRecordCopyValue(ref, kABPersonPhoneProperty));
        if (ABMultiValueGetCount(multiPhones) > 0) {
            _phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiPhones, 0);
        }
        
        ABMultiValueRef multiEmails = (ABRecordCopyValue(ref, kABPersonEmailProperty));
        if (ABMultiValueGetCount(multiEmails) > 0) {
            _email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiEmails, 0);
        }
        
        ABMultiValueRef socialApps = (ABRecordCopyValue(ref, kABPersonSocialProfileProperty));
        for (int i = 0; i < ABMultiValueGetCount(socialApps); i++) {
            NSDictionary *socialItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(socialApps, i);
            if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceFacebook]) {
                _facebookUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceTwitter]) {
                _twitterUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceLinkedIn]) {
                _linkedInUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
            }
        }
        
        ABMultiValueRef urls = (ABRecordCopyValue(ref, kABPersonURLProperty));
        if (ABMultiValueGetCount(urls) > 0) {
            _website = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(urls, 0));
        }
        
        ABMultiValueRef addresses = (ABRecordCopyValue(ref, kABPersonAddressProperty));
        if (ABMultiValueGetCount(addresses) > 0) {
            NSDictionary *addressItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(addresses, 0);
            _address = [[MNAddress alloc] initWithAddressDictionary:addressItem];
        }
        
        _notesOfContact = (__bridge NSString*)(ABRecordCopyValue(ref, kABPersonNoteProperty));
        
    }
    return self;
}

+(NSArray*) getContactCardsFromReference:(ABRecordRef)ref {
    return Nil;
}

@end
