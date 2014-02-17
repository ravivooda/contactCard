//
//  MNContactsManager.m
//  Contact Card
//
//  Created by Ravi Vooda on 09/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactsManager.h"
#import <AddressBook/AddressBook.h>

@interface MNContactsManager ()

@property (strong, nonatomic) NSArray *contactsArray;

@end

@implementation MNContactsManager

static MNContactsManager *singletonInstance = nil;

+ (MNContactsManager*) sharedInstance {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"allContactsManager"];
    MNContactsManager *contactsManager;
    if (savedArray) {
        contactsManager = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (!contactsManager) {
            contactsManager = [[MNContactsManager alloc] init];
        }
        return contactsManager;
    }
    contactsManager = [[MNContactsManager alloc] init];
    return contactsManager;
}

+(id)alloc {
    @synchronized([self class]) {
        NSAssert(singletonInstance == nil, @"Attempted to allocate a second instance of a MNContactsManager.");
        singletonInstance = [super alloc];
        return singletonInstance;
    }
    return nil;
}

-(id) init {
    self = [super init];
    if (self) {
        // Import all the contacts
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
                CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
                
                NSLog(@"start loop");
                for( int i = 0 ; i < nPeople ; i++ ) {
                    ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i );
                    MNContact *contact = [[MNContact alloc] initWithRecordReference:ref];
                }
                
                NSLog(@"end loop");
            }
        });
    }
    return self;
}

@end
