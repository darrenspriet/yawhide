//
//  YHCategoryTableViewController.m
//  yawhide
//
//  Created by Darren Spriet on 2013-12-29.
//  Copyright (c) 2013 Darren Spriet. All rights reserved.
//

#import "YHCategoryTableViewController.h"

@interface YHCategoryTableViewController ()

@end

@implementation YHCategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *tempArray =[NSMutableArray arrayWithArray:[[[[YHDataManager sharedData] storeDictionary] objectForKey:@"categories"]  sortedArrayUsingSelector:@selector(compare:)]];
    [self setCategoryArray:[[NSMutableArray alloc]init]];
    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"All",@"category", @"YES" ,@"selected",  nil];
    [self.categoryArray addObject:diction];
    
    for (int i=0; i< [tempArray count]; i++) {
        NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithObjectsAndKeys:[tempArray objectAtIndex:i],@"category", @"NO" ,@"selected",  nil];
        [self.categoryArray addObject:diction];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.delegate reloadTablewithArray:self.categoryArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryCell";
    YHRightCategoryCell *cell;
    
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if ([[[self.categoryArray objectAtIndex:indexPath.row ] objectForKey:@"selected"] isEqualToString:@"YES"] ) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //    NSLog(@"what is the array %@", self.storeDetailsArray);
    NSString *capitalizedCategory = [[[[[self.categoryArray objectAtIndex:indexPath.row ] objectForKey:@"category"] substringToIndex:1] uppercaseString] stringByAppendingString:[[[self.categoryArray objectAtIndex:indexPath.row ] objectForKey:@"category"] substringFromIndex:1]];
    
    [cell.categoryName setText:capitalizedCategory];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YHRightCategoryCell *cell = (YHRightCategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[self.categoryArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"selected"];
        for (int i=0; i<[self.categoryArray count]; i++) {
            if (indexPath.row==i) {
                //Do Nothing
            }
            else{
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                YHRightCategoryCell *oldCell = (YHRightCategoryCell*)[tableView cellForRowAtIndexPath:index];
                [[self.categoryArray objectAtIndex:index.row ] setObject:@"NO" forKey:@"selected"];
                [oldCell setAccessoryType:UITableViewCellAccessoryNone];
                
            }
        }
                [self.revealViewController revealToggle:self];

    }
    
   }

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
