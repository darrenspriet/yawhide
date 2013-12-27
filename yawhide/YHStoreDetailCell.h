//
//  YHStoreDetailCell.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-27.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHStoreDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
