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

#pragma mark - NSCoding implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    
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
        
        _suffixName = [dictionary objectForKey:kContactsuffixName];
        _firstName = [dictionary objectForKey:kContactfirstName];
        _lastName = [dictionary objectForKey:kContactlastName];
        _middleName = [dictionary objectForKey:kContactmiddleName];
        _nickName = [dictionary objectForKey:kContactnickName];
        
        _firstTitle = [dictionary objectForKey:kContactfirstTitle];
        _secondaryTitle = [dictionary objectForKey:kContactsecondaryTitle];
        _jobTitle = [dictionary objectForKey:kContactjobTitle];
        
    }
    return self;
}

-(NSDictionary*) dictionaryOfContactCard {
    NSMutableDictionary *retDictionary = [[NSMutableDictionary alloc] init];
    [retDictionary setObject:_imageOfPerson forKey:@"image"];
    
    [retDictionary setObject:_suffixName forKey:kContactsuffixName];
    [retDictionary setObject:_firstName forKey:kContactfirstName];
    [retDictionary setObject:_lastName forKey:kContactlastName];
    [retDictionary setObject:_middleName forKey:kContactmiddleName];
    [retDictionary setObject:_nickName forKey:kContactnickName];
    
    [retDictionary setObject:_firstTitle forKey:kContactfirstTitle];
    [retDictionary setObject:_secondaryTitle forKey:kContactsecondaryTitle];
    return retDictionary;
}

- (MNContact*) initWithRecordReference:(ABRecordRef)ref {
    self = [super init];
    if (self) {
        _prefixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonPrefixProperty));
        _firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        _lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
        _middleName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonMiddleNameProperty));
        _suffixName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonSuffixProperty));
        _nickName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonNicknameProperty));
        
        _companyName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonOrganizationProperty));
        _jobTitle = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonJobTitleProperty));
        _departmentName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonDepartmentProperty));
        
        _phoneNumber = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        
    }
    return self;
}

@end
