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
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    if ([[[YHDataManager sharedData] menuArray]count]!=0) {
        [self setMenuArray :[[NSMutableArray alloc]init]];
        [self setMenuArray:[NSMutableArray arrayWithArray:[[YHDataManager sharedData] menuArray]]];
    }
    else{
        [[YHDataManager sharedData]setSideBarCells:0];
        [self setMenuArray:[NSMutableArray arrayWithArray:[[YHDataManager sharedData] menuArray]]];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//Creates a invisible footer to get rid of extra cells created
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * CellIdentifier = [self.menuArray objectAtIndex:indexPath.row];
    
    YHMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[YHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    
    SWRevealViewController* revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    UITableViewCell *cell = sender;
    
    if ([cell.textLabel.text isEqualToString:@"Stores"] ) {
        if (![frontNavigationController.topViewController isKindOfClass:[YHStoreViewTableViewController class]] ){
            YHStoreViewTableViewController* storeController = segue.destinationViewController;
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:storeController];
            [revealController setFrontViewController:navigation animated:YES];
        }
        else{
            [revealController revealToggle:self];
            
        }
    }
    else if ([cell.textLabel.text isEqualToString:@"Sort By Savings"] ) {
        if (![frontNavigationController.topViewController isKindOfClass:[YHSavingsTableViewController class]] ){
            YHSavingsTableViewController* storeController = segue.destinationViewController;
            [storeController setStoreDetailsArray:[[[YHDataManager sharedData] storeDictionary] objectForKey:@"sortSavings"]];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:storeController];
            [revealController setFrontViewController:navigation animated:YES];
        }
        else{
            [revealController revealToggle:self];
            
        }
    }
    else if ([cell.textLabel.text isEqualToString:@"Regular Flyer"] ) {
        if (![frontNavigationController.topViewController isKindOfClass:[YHStoreDetailsTableViewController class]] ){
            YHStoreDetailsTableViewController* storeController = segue.destinationViewController;
            [storeController setStoreDetailsArray:[[[[YHDataManager sharedData] storeDictionary]  objectForKey:@"flyer"] objectForKey:@"currFlyer"]];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:storeController];
            [revealController setFrontViewController:navigation animated:YES];
        }
        else{
            [revealController revealToggle:self];
            
        }
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"Change Location"] ) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        //sets it to the initialViewController on that storyboard
        YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
        [viewController setDelegate:self];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalView)];
        [viewController.navigationItem setLeftBarButtonItem:cancelButton];
        [nav.navigationBar setBarStyle:UIBarStyleDefault];
        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:nav animated:YES completion:NULL];
        
    }
}

//This is to dismiss the Modal View
-(void)dismissModalView{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
