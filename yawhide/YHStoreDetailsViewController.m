//
//  YHStoreDetailsViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHStoreDetailsViewController.h"

@interface YHStoreDetailsViewController ()

@end

@implementation YHStoreDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHSideBarTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sideBarView" ];
    self.revealViewController.rightViewController =viewController;
    
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
    return [self.storeDetailsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Store Detail Cell";
    YHStoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[YHStoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    NSLog(@"what is the array %@", self.storeDetailsArray);
    [cell.itemName setText:[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"item"]];
    [cell.price setText:[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    NSString *imageURL=@"https://s3.amazonaws.com/sobeys-web-production/flyer/products/images/000/158/008/original/SOB_PR064B_139_UF_Jan1_Page2_img25.jpg";
    
    //    NSString *imageURL=[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    
    //Starts a dispatch to get the image and then sets it to the cell
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.itemImage setImage:[UIImage imageWithData:data]];
        });
    });
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"this is happeing");
}

#pragma mark - View Controllers delegate

- (IBAction)segmentControlPressed:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 1:{
              [self.tableview reloadData];
            break;
        }
        case 2:{
              [self.tableview reloadData];
            break;
        }
        default:{
              [self.tableview reloadData];
            break;
        }
    }
}
@end
