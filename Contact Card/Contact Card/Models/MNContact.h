//
//  MNContact.h
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface MNContact : NSObject <NSSecureCoding, UIActivityItemSource, NSCopying>

- (MNContact*) initWithContactCard:(NSDictionary*) dictionary;

- (MNContact*) initWithRecordReference:(ABRecordRef)ref;

- (ABRecordRef) convertToRecordRef;

+ (NSArray*) getContactCardsFromReference:(ABRecordRef)ref;

-(NSDictionary*) dictionaryOfContactCard;

@end
