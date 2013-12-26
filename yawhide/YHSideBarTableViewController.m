//
//  YHSideBarTableViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHSideBarTableViewController.h"

@interface YHSideBarTableViewController ()

@end

@implementation YHSideBarTableViewController

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

//    UINavigationController *frontNav = (id)self.revealViewController.frontViewController;
//    NSLog(@"what is the top nav%@", frontNav);
//    NSLog(@"what is the top controller%@", frontNav.topViewController);
//    self.frontController = (YHFrontViewTableViewController*)frontNav.topViewController;

    
    
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
            CellIdentifier = @"Stores";
            break;
            
        case 1:
            CellIdentifier = @"Change Location";
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
        UITableViewCell *cell = sender;


        
//      NSAssert( revealController != nil, @"oops! must have a revealViewController" );
//      NSAssert( [revealController.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        revealSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
            NSLog(@"what is dvc%@", dvc);
            NSLog(@"what is svc%@", svc);
            NSLog(@"this is revela segue%@", rvc_segue);
            if ([cell.textLabel.text isEqualToString:@"Stores"] ) {
                if (![frontNavigationController.topViewController isKindOfClass:[YHFrontViewTableViewController class]] ){
                    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:dvc];
                    [revealController setFrontViewController:navigation animated:YES];
                }
                else{
                    [revealController revealToggle:self];

                }
            }
//            else{
//                // Seems the user attempts to 'switch' to exactly the same controller he came from!
//                if(![frontNavigationController.topViewController isKindOfClass:[YHRearViewController class]] ){
//                    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:dvc];
//                    [revealController setFrontViewController:navigation animated:YES];
//                }
//                else{
//                    [revealController revealToggle:self];
//                }
//            }
        };
    }
}
- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/50",latitude,longitude]]];
    if (data==nil) {
        NSLog(@"got no data");
    }else{
        
        
        NSError* error2;
        
        NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error2];
        
        
        if (error2) {
            NSLog(@"this is an error in calling the stores");
        }
        else{
            [[[YHDataManager sharedData] storesArray] removeAllObjects];
            for(NSArray *dict in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:dict];
            }
            NSLog(@"loaded stores");
        }
    }
    SWRevealViewController* revealController = self.revealViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    UINavigationController *frontViewController = [storyboard instantiateViewControllerWithIdentifier:@"frontnavigation" ];
    [revealController setFrontViewController:frontViewController animated:YES];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"what is the index path %ld", (long)indexPath.row);
    if (indexPath.row==1) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        //sets it to the initialViewController on that storyboard
        YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
        viewController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [nav.navigationBar setBarStyle:UIBarStyleBlack];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:NULL];

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
