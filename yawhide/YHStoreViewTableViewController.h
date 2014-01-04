//
//  YHStoreViewTableViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YHPostalFinderViewController.h"
#import "YHStoreCell.h"
#import "YHStoreDetailsViewController.h"
#import "YHSideBarTableViewController.h"



@interface YHStoreViewTableViewController : UITableViewController <CLLocationManagerDelegate,UIGestureRecognizerDelegate, YHPostalViewControllerDelegate>

//The reveal Button for the Left Side BAr
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
//The Location Manager so we can get the users location
@property (nonatomic, strong) CLLocationManager *locationManager;
//The Large Activitiy Indicator when the stores are loading
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;


@end
