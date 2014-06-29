//
//  MNEmail.h
//  Contact Card
//
//  Created by Ravi Vooda on 22/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNEmail : NSObject

@property (strong, readonly, nonatomic) NSString *labelName;
@property (strong, readonly, nonatomic) NSString *email;

-(MNEmail*) initWithLabelName:(NSString*)labelName andEmail:(NSString*)email;

@end
