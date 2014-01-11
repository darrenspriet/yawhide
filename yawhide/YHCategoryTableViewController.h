//
//  YHCategoryTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//
@protocol YHCategoryTableViewControllerDelegate <NSObject>
- (void)reloadTablewithArray:(NSArray*)array;
@end

#import <UIKit/UIKit.h>
#import "YHRightCategoryCell.h"




@interface YHCategoryTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, weak) id<YHCategoryTableViewControllerDelegate> delegate;




@end
