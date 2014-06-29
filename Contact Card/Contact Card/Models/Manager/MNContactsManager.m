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

@property (strong, nonatomic) NSArray *personContacts;
@property (strong, nonatomic) NSArray *companyContacts;

@property (strong, nonatomic) NSMutableArray *privateUserCards;

@property (nonatomic) dispatch_semaphore_t sema;

@end


@implementation MNContactsManager

static MNContactsManager *singletonInstance = nil;

+ (MNContactsManager*) sharedInstance {
    if (!singletonInstance) {
        singletonInstance = [[[self class] alloc] init];
    }
    return singletonInstance;
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
    self.sema = dispatch_semaphore_create(0);
    // Import all the contacts
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
            
            NSMutableArray *contactsArray = [[NSMutableArray alloc] init];
//            NSMutableArray *companyArray = [[NSMutableArray alloc] init];
            
            for( int i = 0 ; i < nPeople ; i++ ) {
                ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
                if (ABRecordCopyValue(ref, kABPersonKindProperty) == kABPersonKindPerson) {
                    Contact *contact = [[Contact alloc] initWithRecordReference:ref];
                    [contactsArray addObject:contact];
                } else if (ABRecordCopyValue(ref, kABPersonKindProperty) == kABPersonKindOrganization) {
//                    MNCompany *company = [[MNCompany alloc] initWithRecordReference:ref];
//                    [companyArray addObject:company];
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
        dispatch_semaphore_signal(self.sema);
    });
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
}

-(void) addNewContactCard:(Card *)card {
//    if (!self.privateUserCards) {
//        self.privateUserCards = [[NSMutableArray alloc] init];
//    }
//    
//    [self.privateUserCards addObject:card];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:@"allContactsManager"];
    NSManagedObjectContext *context = managedObjectContext;
    [managedObjectContext insertObject:card];
    
//    FailedBankInfo *failedBankInfo = [NSEntityDescription
//                                      insertNewObjectForEntityForName:@"FailedBankInfo"
//                                      inManagedObjectContext:context];
//    failedBankInfo.name = @"Test Bank";
//    failedBankInfo.city = @"Testville";
//    failedBankInfo.state = @"Testland";
//    FailedBankDetails *failedBankDetails = [NSEntityDescription
//                                            insertNewObjectForEntityForName:@"FailedBankDetails"
//                                            inManagedObjectContext:context];
//    failedBankDetails.closeDate = [NSDate date];
//    failedBankDetails.updateDate = [NSDate date];
//    failedBankDetails.zip = [NSNumber numberWithInt:12345];
//    failedBankDetails.info = failedBankInfo;
//    failedBankInfo.details = failedBankDetails;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(NSArray*)userCards {
    if (!self.privateUserCards) {
        return nil;
    }
    NSArray *retArray = [[NSArray alloc] initWithArray:self.privateUserCards copyItems:YES];
    return retArray;
}

@end
