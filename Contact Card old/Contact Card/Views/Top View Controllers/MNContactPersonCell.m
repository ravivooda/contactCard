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

-(void) awakeFromNib {
    [super awakeFromNib];
}

-(void) setContact:(MNContact *)contact {
    _contact = contact;
    
//    [_cellBackgroundImage setImage:contact.backgroundImage];
    if (contact.thumbnailImage) {
        [_contactImageView setImage:contact.thumbnailImage];
    } else {
        [_contactImageView setImage:[UIImage imageNamed:@"noThumbnailImage"]];
    }
    
    [_firstLine setText:contact.firstTitle];
    [_secondLine setText:contact.secondaryTitle];
    
//    self.currentHeight = imageNameViewHeight;
//    
//    if (contact.phoneNumbers.count > 0) {
//        // The seperator above
//        MNLineView *phoneContactsTopLineSeperator = [[MNLineView alloc] initAtPoint:CGPointMake(paddingValue, self.currentHeight) ofLength:self.frame.size.width - 2*paddingValue];
//        [self.cellScrollView addSubview:phoneContactsTopLineSeperator];
//        self.currentHeight += 5;
//        
//        // Phone Numbers in the contact
//        for (MNPhoneNumber *phoneNumber in contact.phoneNumbers) {
//            UIButton *phoneBackView = [[UIButton alloc] initWithFrame:CGRectMake(paddingValue, self.currentHeight, self.frame.size.width - 2*paddingValue, phoneNumberViewHeight)];
//            [phoneBackView setBackgroundColor:[UIColor clearColor]];
//            
//            UILabel *phoneTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, phoneBackView.frame.size.width, phoneTypeLabelHeight)];
//            [phoneTypeLabel setBackgroundColor:[UIColor clearColor]];
//            [phoneTypeLabel setTextColor:mainLabelColor];
//            [phoneTypeLabel setFont:mainLabelFont];
//            [phoneTypeLabel setText:phoneNumber.labelName];
//            [phoneBackView addSubview:phoneTypeLabel];
//            
//            UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneTypeLabelHeight, phoneBackView.frame.size.width, phoneBackView.frame.size.height - phoneTypeLabelHeight)];
//            [phoneNumberLabel setBackgroundColor:[UIColor clearColor]];
//            [phoneNumberLabel setTextColor:mainValueColor];
//            [phoneNumberLabel setFont:mainValueFont];
//            [phoneNumberLabel setText:phoneNumber.phoneNumber];
//            [phoneBackView addSubview:phoneNumberLabel];
//            
//            self.currentHeight += phoneNumberViewHeight + 5;
//            
//            // Need to write the code to add the messaging and the call buttons to the phone number.
//        }
//    }
//    
//    if (contact.emails.count > 0) {
//        // The seperator above
//        MNLineView *emailContactsTopLineSeperator = [[MNLineView alloc] initAtPoint:CGPointMake(paddingValue, self.currentHeight) ofLength:self.frame.size.width - 2*paddingValue];
//        [self.cellScrollView addSubview:emailContactsTopLineSeperator];
//        self.currentHeight += 5;
//        
//        // Phone Numbers in the contact
//        for (MNEmail *email in contact.emails) {
//            UIButton *emailBackView = [[UIButton alloc] initWithFrame:CGRectMake(paddingValue, self.currentHeight, self.frame.size.width - 2*paddingValue, phoneNumberViewHeight)];
//            [emailBackView setBackgroundColor:[UIColor clearColor]];
//            
//            UILabel *emailTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emailBackView.frame.size.width, phoneTypeLabelHeight)];
//            [emailTypeLabel setBackgroundColor:[UIColor clearColor]];
//            [emailTypeLabel setTextColor:mainLabelColor];
//            [emailTypeLabel setFont:mainLabelFont];
//            [emailTypeLabel setText:email.labelName];
//            [emailBackView addSubview:emailTypeLabel];
//            
//            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneTypeLabelHeight, emailBackView.frame.size.width, emailBackView.frame.size.height - phoneTypeLabelHeight)];
//            [emailLabel setBackgroundColor:[UIColor clearColor]];
//            [emailLabel setTextColor:mainValueColor];
//            [emailLabel setFont:mainValueFont];
//            [emailLabel setText:email.email];
//            [emailBackView addSubview:emailLabel];
//        }
//    }
}

@end
