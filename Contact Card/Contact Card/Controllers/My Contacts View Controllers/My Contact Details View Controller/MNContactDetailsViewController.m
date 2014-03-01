//
//  MNContactDetailsViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 25/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactDetailsViewController.h"
#import "MNLineView.h"

#define imageNameViewHeight 250.0f
#define paddingValue 20.0f
#define phoneNumberViewHeight 50.0f
#define phoneTypeLabelHeight 15.0f

#define mainLabelFont [UIFont fontWithName:@"Trebuchet MS" size:14]
#define mainLabelColor [UIColor colorWithWhite:0.613 alpha:1.000]

#define mainValueFont [UIFont fontWithName:@"Trebuchet MS" size:20]
#define mainValueColor [UIColor blackColor]


@interface MNContactDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *contactBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactFirstLine;
@property (weak, nonatomic) IBOutlet UILabel *contactSecondLine;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic) CGFloat currentHeight;
@end

@implementation MNContactDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_contactBackgroundImageView setImage:_contact.backgroundImage];
    [_contactImageView setImage:_contact.imageOfPerson];
    [_contactFirstLine setText:_contact.firstTitle];
    [_contactSecondLine setText:_contact.secondaryTitle];
    
    self.currentHeight = imageNameViewHeight;

    if (_contact.phoneNumbers.count > 0) {
        // The seperator above
        MNLineView *phoneContactsTopLineSeperator = [[MNLineView alloc] initAtPoint:CGPointMake(paddingValue, self.currentHeight) ofLength:self.view.frame.size.width - 2*paddingValue];
        [self.mainScrollView addSubview:phoneContactsTopLineSeperator];
        self.currentHeight += 5;

        // Phone Numbers in the contact
        for (MNPhoneNumber *phoneNumber in _contact.phoneNumbers) {
            UIButton *phoneBackView = [[UIButton alloc] initWithFrame:CGRectMake(paddingValue, self.currentHeight, self.view.frame.size.width - 2*paddingValue, phoneNumberViewHeight)];
            [phoneBackView setBackgroundColor:[UIColor clearColor]];

            UILabel *phoneTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, phoneBackView.frame.size.width, phoneTypeLabelHeight)];
            [phoneTypeLabel setBackgroundColor:[UIColor clearColor]];
            [phoneTypeLabel setTextColor:mainLabelColor];
            [phoneTypeLabel setFont:mainLabelFont];
            [phoneTypeLabel setText:phoneNumber.labelName];
            [phoneBackView addSubview:phoneTypeLabel];

            UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneTypeLabelHeight, phoneBackView.frame.size.width, phoneBackView.frame.size.height - phoneTypeLabelHeight)];
            [phoneNumberLabel setBackgroundColor:[UIColor clearColor]];
            [phoneNumberLabel setTextColor:mainValueColor];
            [phoneNumberLabel setFont:mainValueFont];
            [phoneNumberLabel setText:phoneNumber.phoneNumber];
            [phoneBackView addSubview:phoneNumberLabel];

            self.currentHeight += phoneNumberViewHeight + 5;
            
            [self.view addSubview:phoneBackView];
            // Need to write the code to add the messaging and the call buttons to the phone number.
        }
    }

    if (_contact.emails.count > 0) {
        // The seperator above
        MNLineView *emailContactsTopLineSeperator = [[MNLineView alloc] initAtPoint:CGPointMake(paddingValue, self.currentHeight) ofLength:self.view.frame.size.width - 2*paddingValue];
        [self.view addSubview:emailContactsTopLineSeperator];
        self.currentHeight += 5;

        // Phone Numbers in the contact
        for (MNEmail *email in _contact.emails) {
            UIButton *emailBackView = [[UIButton alloc] initWithFrame:CGRectMake(paddingValue, self.currentHeight, self.view.frame.size.width - 2*paddingValue, phoneNumberViewHeight)];
            [emailBackView setBackgroundColor:[UIColor clearColor]];

            UILabel *emailTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emailBackView.frame.size.width, phoneTypeLabelHeight)];
            [emailTypeLabel setBackgroundColor:[UIColor clearColor]];
            [emailTypeLabel setTextColor:mainLabelColor];
            [emailTypeLabel setFont:mainLabelFont];
            [emailTypeLabel setText:email.labelName];
            [emailBackView addSubview:emailTypeLabel];

            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, phoneTypeLabelHeight, emailBackView.frame.size.width, emailBackView.frame.size.height - phoneTypeLabelHeight)];
            [emailLabel setBackgroundColor:[UIColor clearColor]];
            [emailLabel setTextColor:mainValueColor];
            [emailLabel setFont:mainValueFont];
            [emailLabel setText:email.email];
            [emailBackView addSubview:emailLabel];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
