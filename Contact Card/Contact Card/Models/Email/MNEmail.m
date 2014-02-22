//
//  MNEmail.m
//  Contact Card
//
//  Created by Ravi Vooda on 22/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNEmail.h"

@interface MNEmail ()

@property (strong, nonatomic) NSString *labelName;
@property (strong, nonatomic) NSString *email;

@end

@implementation MNEmail

- (MNEmail*) initWithLabelName:(NSString *)labelName andEmail:(NSString *)email {
    self = [super init];
    if (self) {
        _labelName = [labelName copy];
        _email = [email copy];
    }
    return self;
}

#pragma mark - Coding Protocol implementations
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_labelName forKey:@"labelName"];
    [aCoder encodeObject:_email forKey:@"email"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _labelName = [aDecoder decodeObjectForKey:@"labelName"];
        _email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Copying Protocol implementations
-(id) copyWithZone:(NSZone *)zone {
    MNEmail *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.labelName = [_labelName copy];
        retObject.email = [_email copy];
    }
    return retObject;
}

@end
