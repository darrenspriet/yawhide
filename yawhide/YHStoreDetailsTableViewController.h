//
//  YHStoreDetailsTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-27.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "YHStoreDetailCell.h"
#import "YHSideBarTableViewController.h"




@interface YHStoreDetailsTableViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, strong) NSMutableArray *storeDetailsArray;


@end
