//
//  seasonPassTable.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "seasonPassTable.h"
#import "seasonPassCell.h"
#import "draftAppDelegate.h"
#import "menucontainerView.h"

@interface seasonPassTable ()

@end

@implementation seasonPassTable

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    

    CellIdentifier = @"sbSeasonPassCell";
    
    
    seasonPassCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[seasonPassCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *titleX;
    
    int showpass = 0;
    
    
    if([indexPath section] == 2){
        titleX = [appDelegate.insideInfo objectForKey:@"Title"];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inside"] isEqualToString:@"true"]){
            showpass = 1;
        }
        
          [cell setupCell:[indexPath section]:showpass:titleX];
    }
    else{
        
#warning issue - if leagues are out of order ... do a find league instead
        
        
        if([indexPath section] < [appDelegate.leagues count]){
            
            if([indexPath section]==0){
                for(NSMutableDictionary *object in appDelegate.leagues){

                    int value = [[[object objectForKey:@"data"] objectForKey:@"LeagueId"] integerValue];
                    
                    if(value == 1){
                        if([indexPath section]==0 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league01"] isEqualToString:@"true"]){
                            showpass = 1;
                            
                        }
                        
                        titleX = [[[appDelegate.leagues objectAtIndex:[indexPath section]] objectForKey:@"data" ] objectForKey:@"Name"];
                        [cell setupCell:[indexPath section]:showpass:titleX];
                
                        
                        break;
                    }
                        
                }
                
                
            }

            
            if([indexPath section]==1){
                for(NSMutableDictionary *object in appDelegate.leagues ){
                    int value = [[[object objectForKey:@"data"] objectForKey:@"LeagueId"] integerValue];
                    
                    if(value == 2){
                        if([indexPath section]==1 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league02"] isEqualToString:@"true"]){
                            showpass = 1;
                        }
                        
                        titleX = [[[appDelegate.leagues objectAtIndex:[indexPath section]] objectForKey:@"data" ] objectForKey:@"Name"];
                        [cell setupCell:[indexPath section]:showpass:titleX];
                        
                        
                        break;
                    }
                    
                }
                
                
            }

            
//            titleX = [[[appDelegate.leagues objectAtIndex:[indexPath section]] objectForKey:@"data" ] objectForKey:@"Name"];
        }
    }
    
  
    
   // [cell setupCell: [theObject objectForKey:@"data"] :[indexPath row]];
    
    
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    

    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbViewDetailInfo"];
    
    
    if([indexPath section] == 2){
        appDelegate.activeSelectedLeague = -1;
        
    }
    else{
        
        if([indexPath section] < [appDelegate.leagues count]){

            appDelegate.activeSelectedLeague = [indexPath section];


        }
    }
    
    
    
    
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:controller animated:YES completion:nil];

    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return @"Leagues";
    }
    if (section == 1)
    {
        return @" ";
    }
    if (section == 2)
    {
        return @"Upgrades";
    }
    
    return @"";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if ([indexPath section] == 0)
    {
        return 44;
    }
    if ([indexPath section] == 1)
    {
        if(TableType == 0){
            return 81;
        }
        else{
            return 81;
        }
    }
    if ([indexPath section] == 2)
    {
        if(TableType == 0){
            return 50;
        }
        else{
            return 50;
        }
    }
    if ([indexPath section] == 3)
    {
        return 246;
    }
     */
    
    return 71;
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)menuButton:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.menuParent triggerMenuAction];

}

- (IBAction)restore:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate restoreAppPurchase];

    [appDelegate.menuParent triggerMenuAction];
}
@end
