//
//  MNContactCardViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 01/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNContactCardViewController.h"

@interface MNContactCardViewController ()

@end

@implementation MNContactCardViewController

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
    [self.nameOfContact setText:@"Ravi Vooda"];
    [self.nameOfContact setFont:[UIFont fontWithName:@"Thonburi" size:18.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
