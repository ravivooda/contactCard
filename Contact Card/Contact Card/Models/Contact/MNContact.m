//
//  MNContact.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContact.h"
#import "MNPhoneNumber.h"
#import "MNEmail.h"
#import <malloc/malloc.h>
#import "Email.h"
#import "PhoneNumber.h"

#define kProfileArchiveKey @"contactArchiveKey"
NSString * const kCustomFileUTI = @"com.mafian.customProfileUTI.customprofile";

@interface MNContact ()

// Identifier of the card
@property (nonatomic) int contactID;

// Images
@property (strong, nonatomic) UIImage *imageOfPerson;

// Identification i.e. Name
@property (strong, nonatomic) NSString *prefixName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *suffixName;
@property (strong, nonatomic) NSString *nickName;

// Maybe they want to show different details on the card
@property (strong, nonatomic) NSString *firstTitle;
@property (strong, nonatomic) NSString *secondaryTitle;

// Work Details
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *departmentName;

// Phone Number
@property (strong, nonatomic) NSArray *phoneNumbers;

// Email
@property (strong, nonatomic) NSArray *emails;

// Social Networking links
@property (strong, nonatomic) NSString *facebookUserName;
@property (strong, nonatomic) NSString *linkedInUserName;
@property (strong, nonatomic) NSString *twitterUserName;

// Website
@property (strong, nonatomic) NSString *website;

// Addresses
@property (strong, nonatomic) MNAddress *address;

// Notes
@property (strong, nonatomic) NSString *notesOfContact;

@end

@implementation MNContact

#pragma mark - Activity item source implementations
-(id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    // Let the activity view controller know NSData is being sent by passing this placeholder.
    return [NSData data];
}

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    //Serialize this object for sending. NSCoding protocol must be implemented for the serialization to occur.
    return [self securelyArchiveRootObject:self];
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return kCustomFileUTI;
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return @"Transfer contact";
}

-(UIImage*) activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    return nil;
}

-(id) initWithContact:(Contact *)contact {
    self = [super init];
    if (self) {
        self.companyName = contact.companyName;
        self.contactID = [contact.contactID intValue];
        self.departmentName = contact.departmentName;
        self.facebookUserName = contact.facebookUserName;
        self.firstName = contact.firstName;
        self.firstTitle = contact.firstTitle;
        self.imageOfPerson = [UIImage imageWithData:contact.imageOfPerson];
        self.jobTitle = contact.jobTitle;
        self.lastName = contact.lastName;
        self.linkedInUserName = contact.linkedInUserName;
        self.middleName = contact.middleName;
        self.nickName = contact.nickName;
        self.notesOfContact = contact.notes;
        self.prefixName = contact.prefixName;
        self.secondaryTitle = contact.secondaryTitle;
        self.suffixName = contact.suffixName;
        self.twitterUserName = contact.twitterUserName;
        self.website = contact.website;
        self.address = [[MNAddress alloc] initWithAddress:contact.address];
        
        NSMutableArray *emailsArray = [[NSMutableArray alloc] init];
        for (Email *email in contact.emails) {
            MNEmail *emailToPush = [[MNEmail alloc] init];
            emailToPush.email = email.email;
            emailToPush.labelName = email.labelName;
            [emailsArray addObject:emailToPush];
        }
        self.emails = [[NSArray alloc] initWithArray:emailsArray];
        
        NSMutableArray *phoneNumbersArray = [[NSMutableArray alloc] init];
        for (PhoneNumber *phoneNumber in contact.phoneNumbers) {
            MNPhoneNumber *phoneNumberToPush = [[MNPhoneNumber alloc] initWithLabelName:phoneNumber.labelName andPhoneNumber:phoneNumber.phoneNumber];
            [phoneNumbersArray addObject:phoneNumberToPush];
        }
        self.phoneNumbers = [[NSArray alloc] initWithArray:phoneNumbersArray];
    }
    return self;
}

- (NSData*) securelyArchiveRootObject:(id) object {
    //Use secure encoding because files could be transfered from anywhere by anyone
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //Ensure that secure encoding is used
    [archiver setRequiresSecureCoding:YES];
    [archiver encodeObject:object forKey:kProfileArchiveKey];
    [archiver finishEncoding];
    
    return data;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageOfPerson forKey:@"imageOfContact"];
    [aCoder encodeObject:self.prefixName forKey:@"prefixName"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.middleName forKey:@"middleName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.suffixName forKey:@"suffixName"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    
    [aCoder encodeObject:self.firstTitle forKey:@"firstTitle"];
    [aCoder encodeObject:self.secondaryTitle forKey:@"secondaryTitle"];
    
    [aCoder encodeObject:self.jobTitle forKey:@"jobTitle"];
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.departmentName forKey:@"departmentName"];
    
    [aCoder encodeObject:self.phoneNumbers forKey:@"phoneNumbers"];
    [aCoder encodeObject:self.emails forKey:@"emails"];
    
    [aCoder encodeObject:self.facebookUserName forKey:@"faceBookUserName"];
    [aCoder encodeObject:self.linkedInUserName forKey:@"linkedInUserName"];
    [aCoder encodeObject:self.twitterUserName forKey:@"twitterUserName"];
    
    [aCoder encodeObject:self.website forKey:@"website"];
    [aCoder encodeObject:self.address forKey:@"address"];
    
    [aCoder encodeObject:self.notesOfContact forKey:@"notesOfContact"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.imageOfPerson = [aDecoder decodeObjectForKey:@"imageOfContact"];
        self.prefixName = [aDecoder decodeObjectForKey:@"prefixName"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.middleName = [aDecoder decodeObjectForKey:@"middleName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.suffixName = [aDecoder decodeObjectForKey:@"suffixName"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        
        self.firstTitle = [aDecoder decodeObjectForKey:@"firstTitle"];
        self.secondaryTitle = [aDecoder decodeObjectForKey:@"secondaryTitle"];
        
        self.jobTitle = [aDecoder decodeObjectForKey:@"jobTitle"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.departmentName = [aDecoder decodeObjectForKey:@"departmentName"];
        
        self.phoneNumbers = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[MNPhoneNumber class],[NSArray class],nil] forKey:@"phoneNumbers"];
        self.emails = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[MNEmail class],[NSArray class],nil] forKey:@"emails"];
        
        self.facebookUserName = [aDecoder decodeObjectForKey:@"faceBookUserName"];
        self.linkedInUserName = [aDecoder decodeObjectForKey:@"linkedInUserName"];
        self.twitterUserName = [aDecoder decodeObjectForKey:@"twitterUserName"];
        
        self.website = [aDecoder decodeObjectForKey:@"website"];
        self.address = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[MNAddress class],[NSArray class],nil] forKey:@"address"];
        
        self.notesOfContact = [aDecoder decodeObjectForKey:@"notesOfContact"];
    }
    return self;
}

#pragma mark - Copying Protocol implementations
-(id) copyWithZone:(NSZone *)zone {
    MNContact *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.contactID = _contactID;

        retObject.imageOfPerson = [UIImage imageWithCGImage:_imageOfPerson.CGImage];
        
        retObject.prefixName = [_prefixName copyWithZone:zone];
        retObject.firstName = [_firstName copyWithZone:zone];
        retObject.middleName = [_middleName copyWithZone:zone];
        retObject.lastName = [_lastName copyWithZone:zone];
        retObject.suffixName = [_suffixName copyWithZone:zone];
        retObject.nickName = [_nickName copyWithZone:zone];
        
        retObject.firstTitle = [_firstTitle copyWithZone:zone];
        retObject.secondaryTitle = [_secondaryTitle copyWithZone:zone];
        
        retObject.jobTitle = [_jobTitle copyWithZone:zone];
        retObject.departmentName = [_departmentName copyWithZone:zone];
        retObject.companyName = [_companyName copyWithZone:zone];
        
        retObject.phoneNumbers = [_phoneNumbers copyWithZone:zone];
        retObject.emails = [_emails copyWithZone:zone];
        
        retObject.facebookUserName = [_facebookUserName copyWithZone:zone];
        retObject.twitterUserName = [_twitterUserName copyWithZone:zone];
        retObject.linkedInUserName   = [_linkedInUserName copyWithZone:zone];
        
        retObject.website = [_website copyWithZone:zone];
        
        retObject.address = [_address copyWithZone:zone];
        
        retObject.notesOfContact = [_notesOfContact copyWithZone:zone];
    }
    return retObject;
}


#pragma mark - Different initializations
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
        
        if (_firstName && _lastName) {
            _firstTitle = [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
        } else if (_firstName) {
            _firstTitle = [NSString stringWithFormat:@"%@",_firstName];
        } else if (_lastName) {
            _firstTitle = [NSString stringWithFormat:@"%@",_lastName];
        } else {
            _firstTitle = @"Unknown Contact";
        }
        
        _companyName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
        _jobTitle = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonJobTitleProperty));
        _departmentName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonDepartmentProperty));
        
        if (_jobTitle && _companyName) {
            _secondaryTitle = [NSString stringWithFormat:@"%@, %@",_jobTitle,_companyName];
        } else if (_jobTitle) {
            _secondaryTitle = [_jobTitle copy];
        } else if (_companyName) {
            _secondaryTitle = [_companyName copy];
        } else {
            _secondaryTitle = @"";
        }
        
        ABMultiValueRef multiPhones = (ABRecordCopyValue(ref, kABPersonPhoneProperty));
        NSMutableArray *phoneArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            MNPhoneNumber *phoneNumber = [[MNPhoneNumber alloc] initWithLabelName:(__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyLabelAtIndex(multiPhones, i))) andPhoneNumber:(__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyValueAtIndex(multiPhones, i)))];
            [phoneArr addObject:phoneNumber];
        }
        _phoneNumbers = [[NSArray alloc] initWithArray:phoneArr copyItems:YES];
        
        ABMultiValueRef multiEmails = (ABRecordCopyValue(ref, kABPersonEmailProperty));
        NSMutableArray *emailsArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiEmails); i++) {
            MNEmail *email = [[MNEmail alloc] initWithLabelName:(__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyLabelAtIndex(multiPhones, i))) andEmail:(__bridge NSString *)ABAddressBookCopyLocalizedLabel((ABMultiValueCopyValueAtIndex(multiEmails, i)))];
            [emailsArr addObject:email];
        }
        _emails = [[NSArray alloc] initWithArray:emailsArr copyItems:YES];
        
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

-(ABRecordRef) convertToRecordRef {
    ABRecordRef retObject = ABPersonCreate();
    if (retObject) {
        ABPersonSetImageData(retObject, (__bridge CFDataRef)[NSData dataWithData:UIImagePNGRepresentation(self.imageOfPerson)], nil);
        ABRecordSetValue(retObject, kABPersonPrefixProperty, (__bridge CFTypeRef)self.prefixName, nil);
        ABRecordSetValue(retObject, kABPersonFirstNameProperty, (__bridge CFTypeRef)self.firstName, nil);
        ABRecordSetValue(retObject, kABPersonMiddleNameProperty, (__bridge CFTypeRef)self.middleName, nil);
        ABRecordSetValue(retObject, kABPersonLastNameProperty, (__bridge CFTypeRef)self.lastName, nil);
        ABRecordSetValue(retObject, kABPersonSuffixProperty, (__bridge CFTypeRef)self.suffixName, nil);
        ABRecordSetValue(retObject, kABPersonNicknameProperty, (__bridge CFTypeRef)self.nickName, nil);
        ABRecordSetValue(retObject, kABPersonJobTitleProperty, (__bridge CFTypeRef)self.jobTitle, nil);
        ABRecordSetValue(retObject, kABPersonOrganizationProperty, (__bridge CFTypeRef)self.companyName, nil);
        ABRecordSetValue(retObject, kABPersonDepartmentProperty, (__bridge CFTypeRef)self.departmentName, nil);
        
        ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (MNPhoneNumber *phoneNumber in self.phoneNumbers) {
            ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)phoneNumber.phoneNumber, (__bridge CFTypeRef)phoneNumber.labelName, NULL);
        }
        
        ABRecordSetValue(retObject, kABPersonPhoneProperty, phoneNumbers, nil);
        
        ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (MNEmail *email in self.emails) {
            ABMultiValueAddValueAndLabel(emails, (__bridge CFTypeRef)email.email, (__bridge CFTypeRef)email.labelName, NULL);
        }
        ABRecordSetValue(retObject, kABPersonEmailProperty, emails, nil);

#warning Need to figure this out. For social links.
////        ABMutableMultiValueRef facebook;
////        ABMutableMultiValueRef linkedIn;
////        ABMutableMultiValueRef twitter;
//        ABMutableMultiValueRef socialLinks;
//        
//        if (self.facebookUserName && ![self.facebookUserName isEqualToString:@""]) {
//            ABMutableMultiValueRef facebook = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
//            ABMultiValueAddValueAndLabel(facebook, (__bridge CFTypeRef)self.facebookUserName, kABPersonSocialProfileUsernameKey, NULL);
//        }
//        
//        if (self.linkedInUserName && ![self.linkedInUserName isEqualToString:@""]) {
//            ABMutableMultiValueRef linkedIn = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
//            ABMultiValueAddValueAndLabel(linkedIn, (__bridge CFTypeRef)self.linkedInUserName, kABPersonSocialProfileUsernameKey, NULL);
//        }
//        
//        if (self.twitterUserName && ![self.twitterUserName isEqualToString:@""]) {
//            ABMutableMultiValueRef twitter = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
//            ABMultiValueAddValueAndLabel(twitter, (__bridge CFTypeRef)self.twitterUserName, kABPersonSocialProfileUsernameKey, NULL);
//        }
        
        ABMutableMultiValueRef website = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        if (self.website) {
            ABMultiValueAddValueAndLabel(website, (__bridge CFTypeRef)self.website, kABPersonHomePageLabel, NULL);
        }
        
        ABRecordSetValue(retObject, kABPersonURLProperty, website, nil);
#warning Need to implement for the later ones. Address and everything below.
    }
    return retObject;
}

+(NSArray*) getContactCardsFromReference:(ABRecordRef)ref {
    return Nil;
}

@end
