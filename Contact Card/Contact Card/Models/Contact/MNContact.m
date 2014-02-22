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

#define kProfileArchiveKey @"contactArchiveKey"
NSString * const kCustomFileUTI = @"com.mafian.contactProfileUTI.contactProfile";

@interface MNContact ()

// Identifier of the card
@property (nonatomic) int contactID;

// Images
@property (strong, nonatomic) UIImage *imageOfPerson;
@property (strong, nonatomic) UIImage *backgroundImage;

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

#warning Some Social Networking links Need to add more or remove
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
-(id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return [self securelyArchiveRootObject:self];
}

-(id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return [NSData data];
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    return kCustomFileUTI;
}

-(NSString*) activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return @"Transer contact";
}

-(UIImage*) activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size {
    return nil;
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

#pragma mark - Secure Coding Protocol implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Copying Protocol implementations
-(id) copyWithZone:(NSZone *)zone {
    MNContact *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.contactID = _contactID;

        retObject.imageOfPerson = [UIImage imageWithCGImage:_imageOfPerson.CGImage];
        retObject.backgroundImage = [UIImage imageWithCGImage:_backgroundImage.CGImage];
        
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
        NSMutableArray *phoneArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            MNPhoneNumber *phoneNumber = [[MNPhoneNumber alloc] initWithLabelName:(__bridge NSString *)(ABMultiValueCopyLabelAtIndex(multiPhones, i)) andPhoneNumber:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(multiPhones, i))];
            [phoneArr addObject:phoneNumber];
        }
        _phoneNumbers = [[NSArray alloc] initWithArray:phoneArr copyItems:YES];
        
        ABMultiValueRef multiEmails = (ABRecordCopyValue(ref, kABPersonEmailProperty));
        NSMutableArray *emailsArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < ABMultiValueGetCount(multiEmails); i++) {
            MNEmail *email = [[MNEmail alloc] initWithLabelName:(__bridge NSString *)(ABMultiValueCopyLabelAtIndex(multiEmails, i)) andEmail:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(multiEmails, i))];
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

+(NSArray*) getContactCardsFromReference:(ABRecordRef)ref {
    return Nil;
}

@end
