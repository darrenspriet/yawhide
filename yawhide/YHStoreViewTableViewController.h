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



@interface YHStoreViewTableViewController : UITableViewController <CLLocationManagerDelegate,UIGestureRecognizerDelegate, YHPostalViewControllerDelegate, YHStoreDetailsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;


@end
