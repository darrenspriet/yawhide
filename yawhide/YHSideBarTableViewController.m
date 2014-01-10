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


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setMenuArray:[NSMutableArray arrayWithArray:[[YHDataManager sharedData] menuArray]]];
    [self.tableView reloadData];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
    [viewController setDelegate:self];
    self.postalNavigator = [[UINavigationController alloc]initWithRootViewController:viewController];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalView)];
    [viewController.navigationItem setLeftBarButtonItem:cancelButton];
    [self.postalNavigator.navigationBar setBarStyle:UIBarStyleDefault];
    [self.postalNavigator setModalPresentationStyle:UIModalPresentationFullScreen];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [self.menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * CellIdentifier = [self.menuArray objectAtIndex:indexPath.row];
    
    YHMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[YHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    
    SWRevealViewController* revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    UITableViewCell *cell = sender;
    
    //We know what to do if the cell is Stores, and it reveals and shows
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
}

- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];

    
    float distance = 50;
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:
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
        
        NSMutableDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
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
            for(NSMutableArray *array in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:array];
            }
            [[YHDataManager sharedData] sortFlyerArrays];

            
            NSLog(@"loaded stores");
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //This finds the cell of Change Location and brings up the Postal Finder View Controller
    if ([cell.textLabel.text isEqualToString:@"Change Location"] ) {

        [self presentViewController:self.postalNavigator animated:YES completion:^{
            [self.revealViewController revealToggle:self];

        }];

        
    }
}

//This is to dismiss the Modal View
-(void)dismissModalView{
    [self.revealViewController revealToggle:self];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


@end
