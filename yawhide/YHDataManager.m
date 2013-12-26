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
    return self;

}


@end
