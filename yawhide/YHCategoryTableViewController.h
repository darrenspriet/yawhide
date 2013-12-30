//
//  YHCategoryTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//
@protocol YHCategoryTableViewControllerDelegate <NSObject>
- (void)disableControls;
-(void)enableControls;
@end

#import <UIKit/UIKit.h>



@interface YHCategoryTableViewController : UITableViewController
@property (nonatomic, weak) id<YHCategoryTableViewControllerDelegate> delegate;


@end
