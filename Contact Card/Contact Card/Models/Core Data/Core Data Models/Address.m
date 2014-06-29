//
//  Address.m
//  Contact Card
//
//  Created by Ravi Vooda on 29/06/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "Address.h"
#import "Contact.h"


@implementation Address

@dynamic street;
@dynamic country;
@dynamic countryCode;
@dynamic zipCode;
@dynamic state;
@dynamic city;
@dynamic contactInfo;

- (Address*) initWithAddressDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.street = [dictionary objectForKey:(NSString*)kABPersonAddressStreetKey];
        self.city = [dictionary objectForKey:(NSString*)kABPersonAddressCityKey];
        self.zipCode = [dictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
        self.state = [dictionary objectForKey:(NSString*)kABPersonAddressStateKey];
        self.country = [dictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
        
        self.countryCode = [dictionary objectForKey:(NSString*)kABPersonAddressCountryCodeKey];
    }
    return self;
}


@end
