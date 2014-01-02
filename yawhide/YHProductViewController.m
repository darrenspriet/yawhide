//
//  YHProductViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2014-01-01.
//  Copyright (c) 2014 Darren Spriet. All rights reserved.
//

#import "YHProductViewController.h"

@interface YHProductViewController ()

@end

@implementation YHProductViewController

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
    NSLog(@"what is the dictioary%@", self.productDictionary);
    
    [self.itemName setText:[self.productDictionary objectForKey:@"item"]];
    [self.itemPrice setText:[self.productDictionary objectForKey:@"price"]];
    [self.itemSavings setText:[NSString stringWithFormat:@"$%@",[self.productDictionary objectForKey:@"bestSav"]]];
    
    float percent =[[self.productDictionary objectForKey:@"bestPercent"] floatValue]*100;
    [self.itemPercentage setText:[NSString stringWithFormat:@"%.0f%@",percent, @"%OFF"]];
    [self.itemDescription setText:[self.productDictionary objectForKey:@"description"]];

    NSString *imageURL=@"https://s3.amazonaws.com/sobeys-web-production/flyer/products/images/000/158/008/original/SOB_PR064B_139_UF_Jan1_Page2_img25.jpg";

    //    NSString *imageURL=[self.productDictionary objectForKey:@"url"];

    
    //Starts a dispatch to get the image and then sets it to the cell
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.itemImage setImage:[UIImage imageWithData:data]];
        });
    });

}
-(void)viewWillDisappear:(BOOL)animated{
    [self.revealViewController setRearViewController:nil];
    [self.delegate addRightController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
