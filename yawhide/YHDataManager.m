//
//  YHDataManager.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-23.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHDataManager.h"

@implementation YHDataManager

//Singleton Object of this class and is accessed again and again
+ (YHDataManager*) sharedData{
    static YHDataManager *sharedData;
    @synchronized(self){
        if (!sharedData){
            sharedData = [[YHDataManager alloc] init];
        }
        return sharedData;
    }
}

-(id)init{
    [self setStoresArray:[[NSMutableArray alloc]init]];
    [self setRegularFlyer:[[NSMutableArray alloc]init]];
    [self setBestPercent:[[NSMutableArray alloc]init]];
    [self setBestSavings:[[NSMutableArray alloc]init]];
    [self setStoreDictionary:[[NSMutableDictionary alloc]init]];
    return self;
}

-(void)sortTheBestSavingsAndPercent{
    NSMutableArray * regularFlyer  = [self.storeDictionary objectForKey:@"regularFlyer"];
    [self setRegularFlyer:regularFlyer];

    NSSortDescriptor * percentDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bestPercent"
                                                 ascending:NO];
    NSArray *percentDesc = [NSArray arrayWithObject:percentDescriptor];
    NSArray *percentArray = [regularFlyer sortedArrayUsingDescriptors:percentDesc];
    [self setBestPercent:[NSMutableArray arrayWithArray:percentArray]];
    
    NSSortDescriptor * savingsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bestSav"
                                                                       ascending:NO];
    NSArray *savingsDesc = [NSArray arrayWithObject:savingsDescriptor];
    NSArray *savingsArray = [regularFlyer sortedArrayUsingDescriptors:savingsDesc];
    [self setBestSavings:[NSMutableArray arrayWithArray:savingsArray]];
    
}



@end
