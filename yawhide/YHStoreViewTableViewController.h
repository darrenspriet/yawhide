//
//  YHStoreViewTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YHStoreCell.h"
#import "YHStoreDetailsViewController.h"
#import "YHSideBarTableViewController.h"



@interface YHStoreViewTableViewController : UITableViewController <UIGestureRecognizerDelegate>

//The reveal Button for the Left Side BAr
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;



@end
