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

@interface YHSideBarTableViewController : UITableViewController <YHPostalViewControllerDelegate>

//Sets up the Array for the SideBar itself
@property (nonatomic, strong) NSMutableArray *menuArray;

@end
