//
//  PostalFinderViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-22.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PostalViewControllerDelegate <NSObject>
- (void)didDismissPresentedViewControllerWithLatitude:(float)latitude andLongitude:(float)longitude;
@end

@interface PostalFinderViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) id<PostalViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;

@end
