//
//  MNLineView.m
//  Contact Card
//
//  Created by Ravi Vooda on 21/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNLineView.h"

#define widthOfLine 1.0f
#define colorOfView [UIColor colorWithWhite:0.787 alpha:1.000]


@implementation MNLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (MNLineView*) initAtPoint:(CGPoint)point ofLength:(CGFloat)length {
    self = [super initWithFrame:CGRectMake(point.x, point.y, length, widthOfLine)];
    if (self) {
        [self setBackgroundColor:colorOfView];
    }
    return self;
}

@end
