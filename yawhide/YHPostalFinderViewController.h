//
//  PostalFinderViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol YHPostalViewControllerDelegate <NSObject>
- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude;
-(void)dismissPostalView;

@end

@interface YHPostalFinderViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate>
@property (nonatomic, weak) id<YHPostalViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;
- (IBAction)getMyLocation:(UIButton *)sender;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *largeActivityIndicator;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end
