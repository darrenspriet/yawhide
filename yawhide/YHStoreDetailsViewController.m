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



    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //sets it to the initialViewController on that storyboard
    YHCategoryTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"categoryTableView" ];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [viewController setDelegate:self];

    
    [self.revealViewController setRearViewController:nil];
    [self setTitle:[NSString stringWithFormat:@"%@ - Flyer",[[[YHDataManager sharedData] storeDictionary] objectForKey:@"storeName"]]];
    [self setStoreDetailsArray:[NSMutableArray arrayWithArray:[[[YHDataManager sharedData] storeDictionary] objectForKey:@"regularFlyer"]]];
    [self.revealViewController setRightViewController:nav];

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

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"view store detail will disapear");
    [self.revealViewController setRightViewController:nil];
    [self.delegate addLeftController];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view  store detail will apear");
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self disableControls];
    NSLog(@"view store detail did appear");
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
    switch ([self.segment selectedSegmentIndex]) {

        case 1:{

            if (cell == nil){
                cell = [[YHStoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            //    NSLog(@"what is the array %@", self.storeDetailsArray);
            [cell.itemName setText:[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"item"]];
            [cell.price setText:[NSString stringWithFormat:@"Save $%@",[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"bestSav"]]];
            
            NSString *imageURL=@"https://s3.amazonaws.com/sobeys-web-production/flyer/products/images/000/158/008/original/SOB_PR064B_139_UF_Jan1_Page2_img25.jpg";
            
            //    NSString *imageURL=[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
            
            
            //Starts a dispatch to get the image and then sets it to the cell
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.itemImage setImage:[UIImage imageWithData:data]];
                });
            });
            break;
        }
        case 2:{
            if (cell == nil){
                cell = [[YHStoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            float percent =[[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"bestPercent"] floatValue]*100;
            [cell.itemName setText:[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"item"]];
            [cell.price setText:[NSString stringWithFormat:@"%.0f%@",percent, @"%OFF"]];
            
            NSString *imageURL=@"https://s3.amazonaws.com/sobeys-web-production/flyer/products/images/000/158/008/original/SOB_PR064B_139_UF_Jan1_Page2_img25.jpg";
            
            //    NSString *imageURL=[[self.storeDetailsArray objectAtIndex:indexPath.row] objectForKey:@"url"];
            
            
            //Starts a dispatch to get the image and then sets it to the cell
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.itemImage setImage:[UIImage imageWithData:data]];
                });
            });
            break;
        }
        default:{
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
            break;
        }
    }


    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"this is happeing");
}

#pragma mark - View Controllers delegate

- (IBAction)segmentControlPressed:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 1:{
            [self setTitle:[NSString stringWithFormat:@"%@",[[[YHDataManager sharedData] storeDictionary] objectForKey:@"storeName"]]];
            [self setStoreDetailsArray:[NSMutableArray arrayWithArray:[[[YHDataManager sharedData] storeDictionary] objectForKey:@"bestSavFlyer"]]];
            [self.tableview setContentOffset:CGPointZero animated:NO];
            [self.tableview reloadData];
            break;
        }
        case 2:{
            [self setTitle:[NSString stringWithFormat:@"%@",[[[YHDataManager sharedData] storeDictionary] objectForKey:@"storeName"]]];
            [self setStoreDetailsArray:[NSMutableArray arrayWithArray:[[[YHDataManager sharedData] storeDictionary] objectForKey:@"bestPercentFlyer"]]];
            [self.tableview setContentOffset:CGPointZero animated:NO];
            [self.tableview reloadData];
            break;
        }
        default:{
            [self setTitle:[NSString stringWithFormat:@"%@",[[[YHDataManager sharedData] storeDictionary] objectForKey:@"storeName"]]];
            [self setStoreDetailsArray:[NSMutableArray arrayWithArray:[[[YHDataManager sharedData] storeDictionary] objectForKey:@"regularFlyer"]]];
            [self.tableview setContentOffset:CGPointZero animated:NO];
            [self.tableview reloadData];
            break;
        }
    }
}

- (void)disableControls{
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
}
-(void)enableControls{
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
}
@end
