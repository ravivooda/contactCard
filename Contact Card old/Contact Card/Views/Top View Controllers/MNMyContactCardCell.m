//
//  MNMyContactCardCell.m
//  Contact Card
//
//  Created by Ravi Vooda on 01/03/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNMyContactCardCell.h"

@interface MNMyContactCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@end

@implementation MNMyContactCardCell

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

-(void) setContactCard:(MNContactCard *)contactCard
{
    _contactCard = contactCard;
    [self.cardNameLabel setText:contactCard.contactCardName];
}

@end
