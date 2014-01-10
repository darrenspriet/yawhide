//
//  YHRightCategoryCell.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-30.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHRightCategoryCell.h"

@implementation YHRightCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setSelected:NO animated:YES];
    }
    // Configure the view for the selected state
    
}

@end
