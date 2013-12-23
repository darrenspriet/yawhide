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
    [self.postalCode becomeFirstResponder];
    
	// Do any additional setup after loading the view.
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
    
    if (textField.text.length==2) {
        //        UITextRange *selectedRange = [textField selectedTextRange];
        //        NSInteger offset = [textField offsetFromPosition:textField.endOfDocument toPosition:selectedRange.end];
        //        NSString *output = [textField.text  stringByAppendingString:@"Pi"];
        //        NSLog(@"what is this %@fsdasd", output);
        //        textField.text = output;
        //
        ////        UITextPosition *newPos = [textField positionFromPosition:textField.endOfDocument offset:offset];
        ////        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:4];
        ////        NSLog(@"what is the range %@", textField.selectedTextRange);
        //        [self selectTextForInput:textField
        //                            atRange:NSMakeRange(3, 4)];
        
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
        NSLog(@"postal code is good");
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.postalCode.text completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemark %@",placemark);
            //String to hold address
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"addressDictionary %@", placemark.addressDictionary);
            
            NSLog(@"placemark %@",placemark.region);
            NSLog(@"placemark %@",placemark.country);  // Give Country Name
            NSLog(@"placemark %@",placemark.locality); // Extract the city name
            NSLog(@"location %@",placemark.name);
            NSLog(@"location %@",placemark.ocean);
            NSLog(@"location %@",placemark.postalCode);
            NSLog(@"location %@",placemark.subLocality);
            
            NSLog(@"location %@",placemark.location);
            NSLog(@"latitude %f",placemark.location.coordinate.latitude);
            NSLog(@"longitude %f",placemark.location.coordinate.longitude);
            
            //Print the location to console
            NSLog(@"I am currently at %@",locatedAt);
            NSLog(@"this is the placemarks %@", placemarks);
            //        NSLog(@"placemark at %@", [placemarks objectAtIndex:0]);
            //       [placemarks objectAtIndex:0].longitude;
            
            //Error checking
            \
            [self.delegate didDismissPresentedViewControllerWithLatitude:placemark.location.coordinate.latitude andLongitude:placemark.location.coordinate.longitude];
            
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

@end
