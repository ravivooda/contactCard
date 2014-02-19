//
//  MNAddress.m
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNAddress.h"

@implementation MNAddress

-(MNAddress*) initWithAddressDictionary:(NSDictionary *)dictionary {
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

@end
