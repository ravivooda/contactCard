//
//  MNContactCard.m
//  Contact Card
//
//  Created by Ravi Vooda on 01/03/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactCard.h"

@implementation MNContactCard

-(id) copyWithZone:(NSZone *)zone {
    MNContactCard *returnObject = [[[self class] allocWithZone:zone] init];
    if (returnObject) {
        returnObject.contactCardName = [self.contactCardName copyWithZone:zone];
        returnObject.contact = [self.contact copyWithZone:zone];
    }
    return returnObject;
}

@end
