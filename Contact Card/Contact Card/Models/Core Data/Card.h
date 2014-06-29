//
//  Card.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Ravi Vooda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * contactCardName;
@property (nonatomic, retain) Contact *contact;

@end
