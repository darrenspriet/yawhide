//
//  YHSplashScreenViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2014-01-04.
//  Copyright (c) 2014 Darren Spriet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "YHPostalFinderViewController.h"

@interface YHSplashScreenViewController : UIViewController <CLLocationManagerDelegate, YHPostalViewControllerDelegate>

//The Location Manager so we can get the users location
@property (nonatomic, strong) CLLocationManager *locationManager;
//The Large Activitiy Indicator when the stores are loading
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *largeActivityIndicator;

@end
