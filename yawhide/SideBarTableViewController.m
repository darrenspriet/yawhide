//
//  SideBarTableViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "SideBarTableViewController.h"

@interface SideBarTableViewController ()

@end

@implementation SideBarTableViewController

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"Front";
            break;
            
        case 1:
            CellIdentifier = @"Back";
            break;
            
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSLog(@"this is sender %@", sender);
    
    //    if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
    //        [sender isKindOfClass:[UITableViewCell class]] &&[sender hasText: @"Back"]){
    //
    //    }
    //    if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
    //        [sender isKindOfClass:[UITableViewCell class]] )
    //    {
    //        // sender is the table view cell that was selected
    //        UITableViewCell *cell = sender;
    //        NSLog(@"cell info %@", cell.textLabel.text);
    //        if ([cell.textLabel.text isEqualToString:@"BACK"] ) {
    //            [self performSelector:@selector(goToSecondButton) withObject:nil afterDelay:.5];
    //
    //            [self.delegate clickedBackButton];
    //
    //            NSLog(@"back button pressed");
    //        }
    //        else{
    //            // get the text of the label in the cell with tag 0
    //            UILabel* c = [(SWUITableViewCell *)sender label];
    //            ColorViewController* cvc = segue.destinationViewController;
    //            cvc.delegate = self;
    //            cvc.color = c.textColor;
    //            cvc.text = c.text;
    //        }
    //        //Sets the TableView Controller as the delegate of the current View Controller
    //        [self setDelegate:(id<MenuViewControllerDelegate>)segue.destinationViewController];
    //
    //
    //    }
    
    // configure the segue.
    if ([segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* revealSegue = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* revealController = self.revealViewController;
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController

        
//      NSAssert( revealController != nil, @"oops! must have a revealViewController" );
//      NSAssert( [revealController.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        revealSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
            UITableViewCell *cell = sender;
            if ([cell.textLabel.text isEqualToString:@"Front"] ) {
                if (![frontNavigationController.topViewController isKindOfClass:[FrontViewTableViewController class]] ){
                    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:dvc];
                    [revealController setFrontViewController:navigation animated:YES];
                }
                else{
                    [revealController revealToggle:self];
                }
            }
            else{
                // Seems the user attempts to 'switch' to exactly the same controller he came from!
                if(![frontNavigationController.topViewController isKindOfClass:[RearViewController class]] ){
                    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:dvc];
                    [revealController setFrontViewController:navigation animated:YES];
                }
                else{
                    [revealController revealToggle:self];
                }
            }
        };
    }
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

@end
