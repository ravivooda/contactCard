//
//  MNContact.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContact.h"

#define kProfileArchiveKey @"contactArchiveKey"
NSString * const kCustomFileUTI = @"com.mafian.contactProfileUTI.contactProfile";

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

#pragma mark - Secure coding implementations
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
