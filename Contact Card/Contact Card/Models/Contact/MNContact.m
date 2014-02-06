//
//  MNContact.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContact.h"

@implementation MNContact

-(id) init {
    self = [super init];
    if (self) {
        _firstName = @"Ravi";
        _lastName = @"Vooda";
        _imageOfPerson = [UIImage imageNamed:@"cat"];
    }
    return self;
}

//@property (strong, nonatomic, readonly) NSString *jobTitle;
//@property (strong, nonatomic, readonly) NSString *companyName;
//
//#warning How many should be used, Phone numbers should be a list?
//@property (strong, nonatomic, readonly) NSString *mainPhoneNumber;
//@property (strong, nonatomic, readonly) NSString *homePhoneNumber;
//@property (strong, nonatomic, readonly) NSString *mobileNumber;
//
//@property (strong, nonatomic, readonly) NSString *personalEmail;
//@property (strong, nonatomic, readonly) NSString *workEmail;
//
//#warning Some Social Networking links Need to add more or remove
//@property (strong, nonatomic, readonly) NSString *facebookUserName;
//@property (strong, nonatomic, readonly) NSString *linkedInUserName;
//@property (strong, nonatomic, readonly) NSString *twitterUserName;

//#warning Address should be an array?
//@property (strong, nonatomic, readonly) NSString *website;
//@property (strong, nonatomic, readonly) NSString *address;
//@property (strong, nonatomic, readonly) NSString *officeLocation;
//
//@property (strong, nonatomic, readonly) NSString *notesOfContact;

-(MNContact*) initWithContactCard:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _imageOfPerson = [dictionary objectForKey:@"image"];
        
        _suffixName = [dictionary objectForKey:@"suffixName"];
        _firstName = [dictionary objectForKey:@"firstName"];
        _lastName = [dictionary objectForKey:@"lastName"];
        _middleName = [dictionary objectForKey:@"middleName"];
        _nickName = [dictionary objectForKey:@"nickName"];
        
        _firstTitle = [dictionary objectForKey:@"firstTitle"];
        _secondaryTitle = [dictionary objectForKey:@"secondaryTitle"];
        _jobTitle = [dictionary objectForKey:@"jobTitle"];
        
    }
    return self;
}

-(NSDictionary*) dictionaryOfContactCard {
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:_imageOfPerson forKey:@"image"];
    
    [retDictionary setObject:_suffixName forKey:@"suffixName"];
    [retDictionary setObject:_firstName forKey:@"firstName"];
    [retDictionary setObject:_lastName forKey:@"lastName"];
    [retDictionary setObject:_middleName forKey:@"middleName"];
    [retDictionary setObject:_nickName forKey:@"nickName"];
    
    [retDictionary setObject:_firstTitle forKey:@"firstTitle"];
    [retDictionary setObject:_secondaryTitle forKey:@"secondaryTitle"];
    return retDictionary;
}

@end
