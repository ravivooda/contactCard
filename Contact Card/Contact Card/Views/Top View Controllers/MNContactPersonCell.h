//
//  MNContactPersonCell.h
//  Contact Card
//
//  Created by Ravi Vooda on 21/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNContactPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLine;
@property (weak, nonatomic) IBOutlet UILabel *secondLine;

@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *cellScrollView;

@property (strong, nonatomic) MNContact *contact;

@end
