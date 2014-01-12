//
//  YHStoreDetailsViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "YHStoreDetailCell.h"
#import "YHSideBarTableViewController.h"
#import "YHCategoryTableViewController.h"
#import "YHProductViewController.h"



@interface YHStoreDetailsViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, YHProductViewControllerDelegate, YHCategoryTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

@property (nonatomic, strong) NSMutableArray *storeDetailsArray;
@property (nonatomic, strong) NSMutableArray *regularFlyer;
@property (nonatomic, strong) NSMutableArray *bestPercent;
@property (nonatomic, strong) NSMutableArray *bestSavings;

- (IBAction)segmentControlPressed:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
