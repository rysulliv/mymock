//
//  draftPicks.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/20/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftPicks.h"
#import "draftAppDelegate.h"
#import "menucontainerView.h"
#import "leagueCell.h"


@interface draftPicks ()

@end

@implementation draftPicks
@synthesize title01;


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
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    title01.text = [[[appDelegate.leagues objectAtIndex:0] objectForKey:@"data"] objectForKey:@"Name"];
    
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.leagues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"sbLeagueCell";
    
    leagueCell *cell = [tableView
                           dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[leagueCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary * playerInfo;
    
    
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    int showpass = 0;
    
    NSString *holderString =[NSString stringWithFormat:@"%@", [[[appDelegate.leagues objectAtIndex:[indexPath row]] objectForKey:@"data"]objectForKey:@"LeagueId"]];

    NSLog(@"sring: %@",holderString);
    
    if([holderString isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league01"] isEqualToString:@"true"]){
            showpass = 1;
    }
    if([holderString isEqualToString:@"2"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league02"] isEqualToString:@"true"]){
        showpass = 1;
    }
    if([holderString isEqualToString:@"0"]){
        showpass = 1;
    }

    
    [cell configCell: [[appDelegate.leagues objectAtIndex:[indexPath row]] objectForKey:@"data"] : [indexPath row]+1 :showpass];
    
    cell.parent = self;
    
    // Configure the cell...
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

    
    appDelegate.activeSelectedLeague = [indexPath row];
    
    
    
    if([indexPath row]==0 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league01"] isEqualToString:@"true"]){
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbNavDraftTeams"];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    if([indexPath row]==1 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league02"] isEqualToString:@"true"]){
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbNavDraftTeams"];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    if([indexPath row] == 2){
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbNavDraftTeams"];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    


    [self menuActionAwayDetails];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}



- (IBAction)menuButton:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.menuParent triggerMenuAction];

    
}

-(void) menuActionAwayDetails{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbViewDetailInfo"];
    
    
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:controller animated:YES completion:nil];

}
@end
