//
//  MNMyCardsTableViewController.m
//  Contact Card
//
//  Created by Ravi Vooda on 01/03/14.
//  Copyright (c) 2014 Mafians. All rights reserved.
//

#import "MNMyCardsTableViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MNMyContactCardCell.h"

#define cardNameAlertViewTag 1234

@interface MNMyCardsTableViewController ()

@property (strong, nonatomic) UIBarButtonItem *defaultRightBarButtonItem;

@property (weak, nonatomic) ABNewPersonViewController *cardNewController;
@property (nonatomic) ABRecordRef cardNewRecordRef;

@property (strong, nonatomic) NSArray *cardsList;

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
    
    self.cardsList = [contactManager userCards];
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
    return self.cardsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cardCellIdentifier";
    MNMyContactCardCell *cell = (MNMyContactCardCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setContactCard:self.cardsList[[indexPath row]]];
    
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
    newPersonViewController.navigationItem.title = @"New Card";
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    newPersonViewController.navigationItem.rightBarButtonItem = saveBtn;
    
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - New Person Delegate
-(void) newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    if (newPersonView == self.cardNewController) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
        CFErrorRef err = NULL;
        bool savePressed = ABAddressBookRemoveRecord(addressBook, person, &err);
        ABAddressBookSave(addressBook, &err);
        
        /* Checking if Cancel is pressed */
        if (!savePressed) {
            NSLog(@"Cancel Pressed");
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        self.cardNewRecordRef = person;
        //TODO: Need to complete this check.
        /* Validating the card: Checking for minimal entries. We can do this later too */
//        NSString *alertSentence;
//
//        if (person ) {
//        }
        
        UIAlertView *cardNameAlertView = [[UIAlertView alloc] initWithTitle:@"Contact Card" message:@"Please provide a name for the card" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay",nil];
        cardNameAlertView.tag = cardNameAlertViewTag;
        cardNameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [cardNameAlertView show];
    }
}

#pragma mark - Alert View Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case cardNameAlertViewTag:
            switch (buttonIndex) {
                case 1:{
                    UITextField *cardNameTextField = [alertView textFieldAtIndex:0];
                    NSLog(@"Card Name: %@",cardNameTextField.text);
                    MNContactCard *newContactCard = [[MNContactCard alloc] init];
                    newContactCard.contactCardName = [cardNameTextField.text copy];
                    newContactCard.contact = [[MNContact alloc] initWithRecordReference:self.cardNewRecordRef];
                    
                    [contactManager addNewContactCard:newContactCard];
                    self.cardsList = [contactManager userCards];
                    [self.tableView reloadData];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                }
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

@end
