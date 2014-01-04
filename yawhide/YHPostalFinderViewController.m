//
//  YHPostalFinderViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHPostalFinderViewController.h"

@interface YHPostalFinderViewController ()

@end

@implementation YHPostalFinderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.largeActivityIndicator setHidden:YES];
    [self.postalCode becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkPostalCodeAndSubmit];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ((textField.text.length==0)||(textField.text.length==2) ||(textField.text.length==4)){
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField reloadInputViews];
        
    }
    else{
        [textField setKeyboardType:UIKeyboardTypeDefault];
        [textField reloadInputViews];
    }
    
    if (textField.text.length >= 6 && range.length == 0)
    {
        
    	return NO; // return NO to not change text
    }
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    
    // replace the text in the range with the upper case version of the replacement string
    [textField replaceRange:textRange withText:[string uppercaseString]];
    return NO;
}


- (int)checkPostalCode:(NSString*)string {
    NSString *trimmedString = [string  stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([trimmedString length] ==6) {
        for (int i=0; i<[trimmedString length]; i++) {
            if (i % 2) {
                NSLog(@"mod%d", i);
                if (!isnumber([trimmedString characterAtIndex:i])) {
                    return 0;
                }
            }
            else{
                NSLog(@" no mod%d", i );
                if (!isalpha([trimmedString characterAtIndex:i])) {
                    return 0;
                }
            }
        }
        return 1;
    }
    else{
        return 0;
    }
}

- (IBAction)postalButton:(UIButton *)sender {
    
    [self checkPostalCodeAndSubmit];
    
}

-(void)checkPostalCodeAndSubmit{
    if ([self checkPostalCode:self.postalCode.text]==1) {
        [self.largeActivityIndicator startAnimating];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.postalCode.text completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            [self.delegate didDismissPresentedViewControllerWithLatitude:placemark.location.coordinate.latitude andLongitude:placemark.location.coordinate.longitude];
            [self.largeActivityIndicator stopAnimating];
            
        }];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Postal Code"
                                                          message:@"Please Try Again"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        NSLog(@"postal code no good");
    }
    
}

- (IBAction)getMyLocation:(UIButton *)sender {
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self.locationManager stopUpdatingLocation];
    
    float distance = 50;
    
    NSLog(@"new location is%@", newLocation);
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: [NSString stringWithFormat:@"http://darrenspriet.apps.runkite.com/getNearestStores/%f/%f/%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude, distance]]];
    
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
            for(NSArray *dict in dictionary){
                [[[YHDataManager sharedData] storesArray] addObject:dict];
            }
            [self.largeActivityIndicator stopAnimating];
            [self.delegate didDismissPresentedViewControllerWithLatitude:newLocation.coordinate.latitude andLongitude:newLocation.coordinate.longitude];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"user Denied Authorization");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Location Service Not Authorized"
                                                          message:@"Please enable Location Services for YawHide in System Settings or enter your postal code manually"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"user Allowed Authorization");
        [self.locationManager startUpdatingLocation];
        [self.largeActivityIndicator startAnimating];
    }
}
@end
