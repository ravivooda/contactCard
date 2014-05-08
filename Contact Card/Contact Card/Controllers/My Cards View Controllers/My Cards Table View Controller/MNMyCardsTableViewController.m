//
//  MNMyCardsTableViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 01/03/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNMyCardsTableViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface MNMyCardsTableViewController ()

@property (strong, nonatomic) UIBarButtonItem *defaultRightBarButtonItem;

@property (weak, nonatomic) ABNewPersonViewController *cardNewController;

@end

@implementation MNMyCardsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Add new card
- (IBAction)addNewCard:(UIButton *)sender {
    ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
    
    self.cardNewController = newPersonViewController;
    
    self.defaultRightBarButtonItem = newPersonViewController.navigationItem.rightBarButtonItem;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    newPersonViewController.addressBook = addressBook;
    newPersonViewController.newPersonViewDelegate = self;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:newPersonViewController];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    newPersonViewController.navigationItem.rightBarButtonItem = saveBtn;
    
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - New Person Delegate
-(void) newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    if (newPersonView == self.cardNewController) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        CFErrorRef err = NULL;
        ABAddressBookRemoveRecord(addressBook, person, &err);
        ABAddressBookSave(addressBook, &err);
        
        /* Validating the card: Checking for minimal entries */
        NSString *alertSentence;
        
//        if () {
//            <#statements#>
//        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Methods
- (void) savePressed {
    
}


@end
