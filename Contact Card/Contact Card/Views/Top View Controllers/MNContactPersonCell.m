//
//  MNContactPersonCell.m
//  Contact Card
//
//  Created by Ravi Vooda on 21/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactPersonCell.h"
#import "MNLineView.h"

@interface MNContactPersonCell ()

@end

@implementation MNContactPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setContact:(MNContact *)contact {
    _contact = contact;
    
    [_cellBackgroundImage setImage:contact.backgroundImage];
    [_contactImageView setImage:contact.imageOfPerson];
    [_firstLine setText:contact.firstTitle];
    [_secondLine setText:contact.secondaryTitle];
    
    
}

@end
