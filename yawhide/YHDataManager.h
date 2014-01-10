//
//  YHDataManager.h
//  yawhide
//
//  Created by Darren Spriet on 2013-12-23.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHDataManager : NSObject

//As singleton Object that is called at the beginning of the Application
+ (YHDataManager*) sharedData;

@property (nonatomic, strong) NSMutableArray *storesArray;
@property (nonatomic, strong) NSMutableDictionary *storeDictionary;
@property (nonatomic, strong) NSMutableArray *menuArray;


-(void)sortFlyerArrays;
@end
