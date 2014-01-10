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
    [self setMenuArray:[[NSMutableArray alloc]init]];
    [self setStoreDictionary:[[NSMutableDictionary alloc]init]];
    [self.menuArray addObject:@"Stores"];
    [self.menuArray addObject:@"Change Location"];
    
    return self;
}

-(void)sortFlyerArrays{
    NSMutableDictionary *diff = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyr"] , @"regularFlyer",
                                 [[self.storesArray objectAtIndex:0] objectForKey:@"bestPercentFlyer"] , @"bestPercentFlyer",
                                 [[self.storesArray objectAtIndex:0] objectForKey:@"bestSavFlyer"] , @"bestSavFlyer",

                                 nil];
    //    for (int x=0; x<[self.storesArray count]; x++) {
    //        NSLog(@"store array has %@", [self.storesArray objectAtIndex:x]);
    //        [[diff objectAtIndex:x]  setObject:[[self.storesArray objectAtIndex:x] objectForKey:@"regularFler"] forKey:@"regularFlyer"];
    //
    //    }
    NSLog(@"categories %d", [[[self.storesArray objectAtIndex:0]objectForKey:@"categories"] count]);
    NSArray *categorys = [[[self.storesArray objectAtIndex:0] objectForKey:@"categories"] allKeys];
    NSMutableArray *newStoresArray = [[NSMutableArray alloc]init];
    
    //    NSLog(@"the categories are %@", [[self.storesArray objectAtIndex:0] objectForKey:@"categories"] );
    for (int z=0; z< [[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] count ]; z++) {
        NSMutableDictionary *singleItem =[NSMutableDictionary dictionaryWithDictionary:[[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] objectAtIndex:z]];
        [singleItem setObject:@"" forKey:@"categories"];
        [newStoresArray addObject:singleItem];
    }
    for (int i=0; i<[categorys count]; i++) {
        //        NSMutableDictionary *foodObject = [[[self.storesArray objectAtIndex:0] objectForKey:@"categories"]objectForKey:[categorys objectAtIndex:i]];
        NSArray *foodObjectArray = [[[[self.storesArray objectAtIndex:0] objectForKey:@"categories"]objectForKey:[categorys objectAtIndex:i]] allObjects];
        
        for (int j=0; j<[foodObjectArray count]; j++) {
            NSString *itemName = [[foodObjectArray objectAtIndex:j]objectForKey:@"item"];
            //            NSLog(@"count of regflyer%d", [[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] count ]);
            for (int k=0; k< [[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] count ]; k++) {
                
                if ([[[[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] objectAtIndex:k]objectForKey:@"item"] isEqualToString:itemName]) {
                    [newStoresArray removeObjectAtIndex:k];
                    NSMutableDictionary *singleItem =[NSMutableDictionary dictionaryWithDictionary:[[[self.storesArray objectAtIndex:0] objectForKey:@"regularFlyer"] objectAtIndex:k]];
                    [singleItem setObject:[categorys objectAtIndex:i] forKey:@"categories"];
                    [newStoresArray insertObject:singleItem atIndex:k];
                    //                  NSLog(@"this is the new %@", [newStoresArray lastObject] );
                }
            }
        }
    }
    
    NSLog(@"new stores %@", newStoresArray);
    [diff setObject:newStoresArray forKey:@"regularFlyer"];
    NSLog(@"BestSavings %@", diff);
}

@end
