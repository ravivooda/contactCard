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

@property (nonatomic) bool hasLoadedContactsFromDevice;

@end

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
        [self loadContactsFromPhone];
    }
    return self;
}

-(void) loadContactsFromPhone {
    // Import all the contacts
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
            
            NSMutableArray *contactsArray = [[NSMutableArray alloc] init];
            NSMutableArray *companyArray = [[NSMutableArray alloc] init];
            
            for( int i = 0 ; i < nPeople ; i++ ) {
                ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
                if (ABRecordCopyValue(ref, kABPersonKindProperty) == kABPersonKindPerson) {
                    MNContact *contact = [[MNContact alloc] initWithRecordReference:ref];
                    [contactsArray addObject:contact];
                } else if (ABRecordCopyValue(ref, kABPersonKindProperty) == kABPersonKindOrganization) {
                    MNCompany *company = [[MNCompany alloc] initWithRecordReference:ref];
                    [companyArray addObject:company];
                }
            }
            
            self.hasLoadedContactsFromDevice = YES;
            _personContacts = [[NSArray alloc] initWithArray:contactsArray copyItems:YES];
//            _companyContacts = [[NSArray alloc] initWithArray:companyArray copyItems:YES];
        } else {
            _personContacts = nil;
            _companyContacts= nil;
            self.hasLoadedContactsFromDevice = NO;
        }
    });
}

@end
