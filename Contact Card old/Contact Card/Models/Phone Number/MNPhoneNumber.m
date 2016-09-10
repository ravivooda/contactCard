//
//  MNPhoneNumber.m
//  Contact Card
//
//  Created by Ravi Vooda on 22/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNPhoneNumber.h"

@interface MNPhoneNumber ()

@property (strong, nonatomic) NSString *labelName;
@property (strong, nonatomic) NSString *phoneNumber;

@end

@implementation MNPhoneNumber

-(MNPhoneNumber*) initWithLabelName:(NSString *)labelName andPhoneNumber:(NSString *)phoneNumber {
    self = [super init];
    if (self) {
        _labelName = [labelName copy];
        _phoneNumber = [phoneNumber copy];
    }
    return self;
}

#pragma mark - Coding Protocol implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_labelName forKey:@"labelName"];
    [aCoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _labelName = [aDecoder decodeObjectForKey:@"labelName"];
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    }
    return self;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Copying Protocol implementations
-(id) copyWithZone:(NSZone *)zone {
    MNPhoneNumber *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.labelName = [_labelName copy];
        retObject.phoneNumber = [_phoneNumber copy];
    }
    return retObject;
}

@end
