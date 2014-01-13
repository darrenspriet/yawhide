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
    
//ONLY NEEDED IF WE ADD THE REVEAL CONTROLLER ON THE LEFT
//    [self.revealButtonItem setTarget: self.revealViewController];
//    [self.revealButtonItem setAction: @selector( revealToggle: )];
    
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];

}

//When the view appears it adds the LeftController also known as the RearViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear store controller");
    [self.tableView reloadData];
//    [self addLeftController];

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
//    Sobeys
//    125 The Queensway, Etobicoke, ON M8Y 1H6, Canada ‎
//    +1 416-259-1758 ‎ · sobeys.com
//bestPercentFlyer: Array[492]
//bestSavFlyer: Array[492]
//categories: Array[14]
//city: "Mississauga, ON"
//currFlyerDate: "2014-01-11T05:35:37.220Z"
//location: Object
//postalCode: "L5M 7L9"
//regularFlyer: Array[492]
//storeHours: Object
//storeLocation: "5602 10th Line W"
//storeName: "Mississauga"
//urlNumber: 158
    
     static NSString *CellIdentifier = @"Store Cell";
    YHStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[YHStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *storeName = [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row]  objectForKey:@"storeName"];
    NSString *storeLocation = [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row]  objectForKey:@"storeLocation"];
    NSString *city = [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row]  objectForKey:@"city"];
    NSString *postalCode = [[[[YHDataManager sharedData] storesArray] objectAtIndex:indexPath.row]  objectForKey:@"postalCode"];
    [cell.storeName setText:[NSString stringWithFormat:@"%@-",storeName]];
    [cell.address setText:storeLocation];
    [cell.city setText:[NSString stringWithFormat:@"%@, %@",city, postalCode]];
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
    
    if([segue.identifier isEqualToString:@"postalFinderSegue"]){
        UINavigationController * navController =segue.destinationViewController;
        YHPostalFinderViewController *postalFinder = (YHPostalFinderViewController *)navController.topViewController;
        //passes the schedule
        [postalFinder setDelegate:self];
    }
    else{
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        [[YHDataManager sharedData] setStoreDictionary:[NSMutableDictionary dictionaryWithDictionary:[[[YHDataManager sharedData] storesArray] objectAtIndex:row]]];
        [[YHDataManager sharedData] sortTheBestSavingsAndPercent];
    }



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

- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    
    float distance = 50;
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/%f",latitude,longitude, distance]]];
    
    //If there is no data, then we show a Alert that says the Server is down
    if (data==nil) {
        NSLog(@"got no data");
        UIAlertView *noData = [[UIAlertView alloc]
                               initWithTitle:@"Sorry"
                               message:@"Our Servers Must Be Down"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
        [noData show];
    }else{
        
        NSError* error2;
        
        NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error2];
        
        if (error2) {
            NSLog(@"this is an error in calling the stores");
            UIAlertView *noData = [[UIAlertView alloc]
                                   initWithTitle:@"Sorry"
                                   message:@"Our Servers Must Be Down"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [noData show];
        }
        else{
            [[[YHDataManager sharedData] storesArray] removeAllObjects];
            for(NSArray *array in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:array];
            }
            
            
            NSLog(@"loaded stores");
        }
    }
    
}


-(void)dismissPostalView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


//ONLY NEEDED IF WE ADD THE REVEAL CONTROLLER
-(void)addLeftController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHSideBarTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sideBarView" ];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.revealViewController setRearViewController:nav];
    
}




@end
