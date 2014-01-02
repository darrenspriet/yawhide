//
//  YHStoreDetailsViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//
@protocol YHStoreDetailsViewControllerDelegate <NSObject>
- (void)addLeftController;
@end

#import <UIKit/UIKit.h>
#import "YHStoreDetailCell.h"
#import "YHSideBarTableViewController.h"
#import "YHCategoryTableViewController.h"
#import "YHProductViewController.h"



@interface YHStoreDetailsViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, YHCategoryTableViewControllerDelegate, YHProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, weak) id<YHStoreDetailsViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *storeDetailsArray;
- (IBAction)segmentControlPressed:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
