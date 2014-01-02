//
//  YHProductViewController.h
//  yawhide
//
//  Created by Darren Spriet on 2014-01-01.
//  Copyright (c) 2014 Darren Spriet. All rights reserved.
//
@protocol YHProductViewControllerDelegate <NSObject>
- (void)addRightController;
@end

#import <UIKit/UIKit.h>

@interface YHProductViewController : UIViewController

@property (nonatomic, weak) id<YHProductViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *productDictionary;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemSavings;
@property (weak, nonatomic) IBOutlet UILabel *itemPercentage;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;



@end
