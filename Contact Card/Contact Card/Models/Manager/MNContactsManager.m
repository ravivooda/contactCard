//
//  MNContactsManager.m
//  Contact Card
//
//  Created by Ravi Vooda on 09/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactsManager.h"
#import <AddressBook/AddressBook.h>
#import "PhoneNumber.h"
#import "Address.h"
#import "Email.h"
#import "Contact.h"
#import "Card.h"

@interface MNContactsManager ()

@property (nonatomic) bool hasLoadedContactsFromDevice;

@property (strong, nonatomic) NSArray *personContacts;
@property (strong, nonatomic) NSArray *companyContacts;

@property (strong, nonatomic) NSArray *contactsArray;

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
    self.sema = dispatch_semaphore_create(0);
    // Import all the contacts
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
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
        dispatch_semaphore_signal(self.sema);
    });
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
}

-(void) addNewContactCard:(MNContactCard *)card {
    
    // Just wanna check something
    
    NSManagedObjectContext *context = sharedContext;
    Contact *contactToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
    MNContact *contact = card.contact;
    contactToSave.contactID = [NSNumber numberWithInt:contact.contactID];
    contactToSave.companyName = contact.companyName;
    contactToSave.departmentName = contact.departmentName;
    contactToSave.facebookUserName = contact.facebookUserName;
    contactToSave.firstName = contact.firstName;
    contactToSave.firstTitle = contact.firstTitle;
    contactToSave.imageOfPerson = UIImagePNGRepresentation(contact.imageOfPerson);
    contactToSave.jobTitle = contact.jobTitle;
    contactToSave.lastName = contact.lastName;
    contactToSave.linkedInUserName = contact.linkedInUserName;
    contactToSave.middleName = contact.middleName;
    contactToSave.nickName = contact.nickName;
    contactToSave.notes = contact.notesOfContact;
    contactToSave.prefixName = contact.prefixName;
    contactToSave.secondaryTitle = contact.secondaryTitle;
    contactToSave.suffixName = contact.suffixName;
    contactToSave.twitterUserName = contact.twitterUserName;
    contactToSave.website = contact.website;
    
    Address *addressToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
    MNAddress *address = card.contact.address;
    addressToSave.city = address.city;
    addressToSave.country = address.country;
    addressToSave.countryCode = address.countryCode;
    addressToSave.state = address.state;
    addressToSave.street = address.street;
    addressToSave.zipCode = address.zipCode;
    addressToSave.contactInfo = contactToSave;
    contactToSave.address = addressToSave;
    
    for (MNEmail *email in contact.emails) {
        Email *emailToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Email" inManagedObjectContext:context];
        emailToSave.email = email.email;
        emailToSave.labelName = email.labelName;
        emailToSave.contactInfo = contactToSave;
        [contactToSave addEmailsObject:emailToSave];
    }
    
    for (MNPhoneNumber *phoneNumber in contact.phoneNumbers) {
        PhoneNumber *phoneNumberToSave = [NSEntityDescription insertNewObjectForEntityForName:@"PhoneNumber" inManagedObjectContext:context];
        phoneNumberToSave.phoneNumber = phoneNumber.phoneNumber;
        phoneNumberToSave.labelName = phoneNumber.labelName;
        phoneNumberToSave.contactInfo = contactToSave;
        [contactToSave addPhoneNumbersObject:phoneNumberToSave];
    }
    
    Card *cardToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    cardToSave.contact = contactToSave;
    cardToSave.contactCardName = card.contactCardName;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(NSArray*)userCards {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = sharedContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:sharedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    _privateUserCards = [[NSMutableArray alloc] init];
    
    for (Card *info in fetchedObjects) {
        MNContactCard *cardToPush = [[MNContactCard alloc] init];
        cardToPush.contactCardName = info.contactCardName;
        cardToPush.contact = [[MNContact alloc] initWithContact:info.contact];
        [_privateUserCards addObject:cardToPush];
    }
    
    return _privateUserCards;
}

@end
