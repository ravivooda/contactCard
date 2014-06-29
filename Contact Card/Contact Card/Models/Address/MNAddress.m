//
//  MNAddress.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNAddress.h"

@interface MNAddress ()

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *country;

@property (strong, nonatomic) NSString *countryCode;

@end

@implementation MNAddress

- (MNAddress*) initWithAddressDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _street = [dictionary objectForKey:(NSString*)kABPersonAddressStreetKey];
        _city = [dictionary objectForKey:(NSString*)kABPersonAddressCityKey];
        _zipCode = [dictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
        _state = [dictionary objectForKey:(NSString*)kABPersonAddressStateKey];
        _country = [dictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
        
        _countryCode = [dictionary objectForKey:(NSString*)kABPersonAddressCountryCodeKey];
    }
    return self;
}

#pragma mark - Secure Coding Protocols implementation
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_street forKey:@"street"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_zipCode forKey:@"zipCode"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_countryCode forKey:@"countryCode"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _street = [aDecoder decodeObjectForKey:@"street"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _zipCode = [aDecoder decodeObjectForKey:@"zipCode"];
        _country = [aDecoder decodeObjectForKey:@"country"];
        _countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
    }
    return self;
}

+(BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Copying Protocols implementation
-(id) copyWithZone:(NSZone *)zone {
    MNAddress *retObject = [[[self class] allocWithZone:zone] init];
    if (retObject) {
        retObject.street = [_street copy];
        retObject.city = [_city copy];
        retObject.state = [_state copy];
        retObject.zipCode = [_zipCode copy];
        retObject.country = [_country copy];
        retObject.countryCode = [_countryCode copy];
    }
    return retObject;
}

@end
