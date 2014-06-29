//
//  MNCompany.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNCompany.h"

@implementation MNCompany

//-(MNCompany*) initWithRecordReference:(ABRecordRef)ref {
//    self = [super init];
//    if (self) {
//#warning Need to set the background image to some default image.
//        
//        if (ABPersonHasImageData(ref)) {
//            NSData *imageData = (__bridge NSData *)(ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatOriginalSize));
//            _imageOfCompany = [UIImage imageWithData:imageData];
//        }
//        
//        _firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
//        _lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
//        
//        _companyName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
//        
//        ABMultiValueRef multiPhones = (ABRecordCopyValue(ref, kABPersonPhoneProperty));
//        if (ABMultiValueGetCount(multiPhones) > 0) {
//            _phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiPhones, 0);
//        }
//        
//        ABMultiValueRef multiEmails = (ABRecordCopyValue(ref, kABPersonEmailProperty));
//        if (ABMultiValueGetCount(multiEmails) > 0) {
//            _email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiEmails, 0);
//        }
//        
//        ABMultiValueRef socialApps = (ABRecordCopyValue(ref, kABPersonSocialProfileProperty));
//        for (int i = 0; i < ABMultiValueGetCount(socialApps); i++) {
//            NSDictionary *socialItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(socialApps, i);
//            if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceFacebook]) {
//                _facebookUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
//            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceTwitter]) {
//                _twitterUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
//            } else if ([[socialItem objectForKey:(NSString *)kABPersonSocialProfileServiceKey] isEqualToString:(NSString*)kABPersonSocialProfileServiceLinkedIn]) {
//                _linkedInUserName = [socialItem valueForKey:(NSString*)kABPersonSocialProfileUsernameKey];
//            }
//        }
//        
//        ABMultiValueRef urls = (ABRecordCopyValue(ref, kABPersonURLProperty));
//        if (ABMultiValueGetCount(urls) > 0) {
//            _website = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(urls, 0));
//        }
//        
//        ABMultiValueRef addresses = (ABRecordCopyValue(ref, kABPersonAddressProperty));
//        if (ABMultiValueGetCount(addresses) > 0) {
//            NSDictionary *addressItem = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(addresses, 0);
//            _address = [[MNAddress alloc] initWithAddressDictionary:addressItem];
//        }
//        
//        _notes = (__bridge NSString*)(ABRecordCopyValue(ref, kABPersonNoteProperty));
//        
//    }
//    return self;
//}

@end
