//
//  MNMyContactsViewController.h
//  Contact Card
//
//  Created by Ravi Vooda on 08/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNMyContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *contacts;

@end
