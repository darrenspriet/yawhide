//
//  YHFrontViewTableViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHStoreViewTableViewController.h"

@interface YHStoreViewTableViewController ()

@end

@implementation YHStoreViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];


}

//When the view appears it adds the LeftController also known as the RearViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear store controller");
    [self.tableView reloadData];
    [self addLeftController];

}

- (void)didReceiveMemoryWarning{
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
    return [[[YHDataManager sharedData] storesArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     static NSString *CellIdentifier = @"Store Cell";
    YHStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[YHStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *storeName = [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row]  objectForKey:@"storeName"];
//    NSLog(@"what is in the flyer%@", [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row] objectForKey:@"flyer"]);
    [cell.storeName setText:storeName];
    [cell.noFlyerDetail setText:@""];
    if ([[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row] objectForKey:@"regularFlyer"]!=0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else{
        [cell.noFlyerDetail setText:@"Not Available"];

    }
    
    return cell;
}

#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSInteger row = [[self tableView].indexPathForSelectedRow row];

    [[YHDataManager sharedData] setStoreDictionary:[NSMutableDictionary dictionaryWithDictionary:[[[YHDataManager sharedData] storesArray] objectAtIndex:row]]];
    [[YHDataManager sharedData] sortTheBestSavingsAndPercent];


}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    NSInteger row = [[self tableView].indexPathForSelectedRow row];

    if ([[[[YHDataManager sharedData] storesArray] objectAtIndex:row] objectForKey:@"regularFlyer"]!=0) {
        return YES;
    }
    else{
        UIAlertView *noFlyer = [[UIAlertView alloc] initWithTitle:@"No Flyer Available"
                                                          message:@"Sorry this Location has No Flyer"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [noFlyer show];
        return NO;
    }
}


-(void)addLeftController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHSideBarTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sideBarView" ];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.revealViewController setRearViewController:nav];
    
}




@end
