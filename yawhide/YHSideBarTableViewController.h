//
//  YHSideBarTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMenuCell.h"
#import "YHFrontViewTableViewController.h"
#import "YHRearViewController.h"




@interface YHSideBarTableViewController : UITableViewController
@property (nonatomic, strong) YHFrontViewTableViewController *frontController;
@property (nonatomic, strong) YHRearViewController *rearController;

@end
