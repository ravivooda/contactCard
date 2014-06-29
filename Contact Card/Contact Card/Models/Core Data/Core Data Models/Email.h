//
//  Email.h
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface Email : NSManagedObject

@property (nonatomic, retain) NSString * labelName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Contact *contactInfo;

@end
