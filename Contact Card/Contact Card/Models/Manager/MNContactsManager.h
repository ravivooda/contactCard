//
//  MNContactsManager.h
//  Contact Card
//
//  Created by Ravi Vooda on 09/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNContactsManager : NSObject

@property (strong, nonatomic, readonly) NSArray *allContacts;

/**
 *Returns the shared instance of MNContactsManager.
 */
+(MNContactsManager*) sharedInstance;

@property (strong, readonly, nonatomic) NSArray *personContacts;
@property (strong, readonly, nonatomic) NSArray *companyContacts;

@property (strong, readonly, nonatomic) NSArray *userCards;

-(void) addNewContactCard:(Card*)card;

typedef void (^ContactsLoadedCompletionBlock)(void);

@end
