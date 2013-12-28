//
//  YHSideBarTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YHMenuCell.h"
#import "YHStoreViewTableViewController.h"
#import "YHRearViewController.h"
#import "YHSavingsTableViewController.h"
#import "YHStoreDetailsTableViewController.h"




@interface YHSideBarTableViewController : UITableViewController <YHPostalViewControllerDelegate>
@property (nonatomic, strong) YHRearViewController *rearController;
@property (nonatomic, strong) NSMutableArray *menuArray;



@end
