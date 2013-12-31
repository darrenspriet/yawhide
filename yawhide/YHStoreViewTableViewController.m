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
    [self.activityIndicator setHidden:YES];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setColor:[UIColor blackColor]];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-self.navigationController.navigationBar.frame.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height);
    [self.view addSubview: self.activityIndicator];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];

    
    if ([[[YHDataManager sharedData] storesArray] count]==0) {
        [self setLocationManager:[[CLLocationManager alloc]init]];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager startUpdatingLocation];

    }
    else{
        [self.tableView reloadData];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.revealViewController setRightViewController:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHSideBarTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sideBarView" ];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.revealViewController setRearViewController:nav];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//        NSLog(@"didFailWithError: %@", error);
//        UIAlertView *errorAlert = [[UIAlertView alloc]
//                                   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    if ([[[YHDataManager sharedData] storesArray]count] ==0) {
        
        NSLog(@"new location is%@", newLocation);
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/50",newLocation.coordinate.latitude,newLocation.coordinate.longitude]]];
        
        if (data==nil) {
            NSLog(@"got no data");
                    UIAlertView *noData = [[UIAlertView alloc]
                                           initWithTitle:@"Sorry "
                                           message:@"Our Server Must Be Down"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                    [noData show];
            [self.activityIndicator stopAnimating];

        }else{
            
        NSError* error;
        
        NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
        if (error) {
            NSLog(@"this is an error in calling the stores");
        }
        else{
            [[[YHDataManager sharedData] storesArray] removeAllObjects];
            NSLog(@"loaded all the stores");
            for(NSArray *dict in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:dict];
            }
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];

        }

    }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"user Denied Authorization");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        //sets it to the initialViewController on that storyboard
        YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
        viewController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [nav.navigationBar setBarStyle:UIBarStyleDefault];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:NULL];
        
        
    }
    else if (status == kCLAuthorizationStatusAuthorized) {

        NSLog(@"user Allowed Authorization");
        [self.activityIndicator startAnimating];

    }
}
- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude
{
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

        [self.tableView reloadData];
        NSLog(@"all went as planned");
    }
    }
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

}



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        //sets it to the initialViewController on that storyboard
//        YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
//        [viewController setDelegate:self];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalView)];
//        [viewController.navigationItem setLeftBarButtonItem:cancelButton];
//        [nav.navigationBar setBarStyle:UIBarStyleDefault];
//        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
//        [self presentViewController:nav animated:YES completion:NULL];
//        
//    }
//}


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
