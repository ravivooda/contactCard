//
//  MNContactsManager.m
//  Contact Card
//
//  Created by Ravi Vooda on 09/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactsManager.h"

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
    }
    return self;
}

@end
