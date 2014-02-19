//
//  MNAddress.h
//  Contact Card
//
//  Created by Ravi Vooda on 05/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAddress : NSObject

@property (readonly, strong, nonatomic) NSString *street;
@property (readonly, strong, nonatomic) NSString *city;
@property (readonly, strong, nonatomic) NSString *state;
@property (readonly, strong, nonatomic) NSString *zipCode;
@property (readonly, strong, nonatomic) NSString *country;

@property (readonly, strong, nonatomic) NSString *countryCode;

-(MNAddress*) initWithAddressDictionary:(NSDictionary*)dictionary;

@end
