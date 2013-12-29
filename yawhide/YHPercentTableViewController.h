//
//  YHPercentTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHStoreDetailCell.h"


@interface YHPercentTableViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, strong) NSMutableArray *storeDetailsArray;

@end
