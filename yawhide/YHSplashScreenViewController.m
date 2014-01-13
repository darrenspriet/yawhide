//
//  YHSplashScreenViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2014-01-04.
//  Copyright (c) 2014 Darren Spriet. All rights reserved.
//

#import "YHSplashScreenViewController.h"


@interface YHSplashScreenViewController ()

@end

@implementation YHSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.largeActivityIndicator setHidden:YES];
    [self.largeActivityIndicator setHidesWhenStopped:YES];
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location Manager In Store View didFailWithError: %@", error);
    //        UIAlertView *errorAlert = [[UIAlertView alloc]
    //                                   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [self.locationManager stopUpdatingLocation];
    if ([[[YHDataManager sharedData] storesArray]count] ==0) {
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/50",newLocation.coordinate.latitude,newLocation.coordinate.longitude]]];
        
        if (data==nil) {
            NSLog(@"got no data");
            UIAlertView *noData = [[UIAlertView alloc]
                                   initWithTitle:@"Sorry "
                                   message:@"Our Server Must Be Down"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [noData show];
            [self.largeActivityIndicator stopAnimating];
            
        }else{
            
            NSError* error;
            
            NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:&error];
            if (error) {
                NSLog(@"this is an error in calling the stores");
            }
            else{
                [[[YHDataManager sharedData] storesArray] removeAllObjects];
                NSLog(@"loaded all the stores");
                for(NSArray *array in dictionary){
                    [[[YHDataManager sharedData] storesArray] addObject:array];
                }
                [self performSegueWithIdentifier:@"splashSegue" sender:self];\
                [self.largeActivityIndicator stopAnimating];
                
            }
            
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"user Denied Authorization");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        //sets it to the initialViewController on that storyboard
        YHPostalFinderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PostalFinderViewController" ];
        [viewController setDelegate:self];
        [viewController.navigationItem setLeftBarButtonItem:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [nav.navigationBar setBarStyle:UIBarStyleDefault];
        nav.navigationItem.leftBarButtonItem = nil;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:NULL];
        
        
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        
        NSLog(@"user Allowed Authorization");
        [self.largeActivityIndicator setHidden:NO];
        [self.largeActivityIndicator startAnimating];
        
    }
}
- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude
{

    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"splashSegue" sender:self];

    }];
    
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/50",latitude,longitude]]];
    if (data==nil) {
        NSLog(@"got no data");
        UIAlertView *noData = [[UIAlertView alloc]
                               initWithTitle:@"Sorry "
                               message:@"Our Server Must Be Down"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
        [noData show];
        [self.largeActivityIndicator stopAnimating];
        
    }else{
        
        NSError* error2;
        
        NSDictionary * dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error2];
        
        
        if (error2) {
            NSLog(@"this is an error in calling the stores");
        }
        else{
            [[[YHDataManager sharedData] storesArray] removeAllObjects];
            for(NSMutableArray *array in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:array];
            }

            NSLog(@"all went as planned");
        }
    }
}
-(void)dismissPostalView{
    NSLog(@"Not Doing anything here, Cancel doesn't exist");
}


@end
