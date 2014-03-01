//
//  MNMyContactsViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 08/02/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNMyContactsViewController.h"
#import "MNContactPersonCell.h"
#import "MNContactDetailsViewController.h"

@interface MNMyContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *allContactsTableview;

@end

@implementation MNMyContactsViewController {
    MNContact *selectedContact;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.contacts = contactManager.personContacts;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.allContactsTableview) {
        static NSString *CellIdentifier = @"contactDisplayCellIdentifier";
        MNContactPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[MNContactPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...
        [cell setContact:self.contacts[indexPath.row]];
        return cell;
    }
    
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - Table view delegate methods
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MNContactPersonCell *selectedCell = (MNContactPersonCell*)[tableView cellForRowAtIndexPath:indexPath];
    selectedContact = selectedCell.contact;
    [self performSegueWithIdentifier:@"detailsContactSegue" sender:self];
}

#pragma mark - Segue methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsContactSegue"]) {
        MNContactDetailsViewController *dvc = segue.destinationViewController;
        dvc.contact = selectedContact;
    }
}

@end