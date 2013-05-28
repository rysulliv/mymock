//
//  playerStats.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "playerStats.h"
#import "draftAppDelegate.h"

@interface playerStats ()

@end

@implementation playerStats
@synthesize navbar;
@synthesize position;
@synthesize school;
@synthesize year;
@synthesize pheight;
@synthesize pweight;

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
    
    
    [rankTable activateTable];
    
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    if(appDelegate.activeSelectedLeague==-1){
        appDelegate.activeSelectedLeague = rememberLeague;
    }

    
    navbar.title = [appDelegate.currentPlayer objectForKey:@"Name"];
    
    position.text =[appDelegate.currentPlayer objectForKey:@"Position"];
    school.text =    [appDelegate.currentPlayer objectForKey:@"School"];
    year.text = [appDelegate.currentPlayer objectForKey:@"Year"];
    pheight.text =  [appDelegate.currentPlayer objectForKey:@"Height"];
    NSLog(@"info: %@",[appDelegate.currentPlayer objectForKey:@"Weight"]);     
    pweight.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Weight"]];
    
    
    st_40.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Forty"]];
    st_20.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Twenty"]];
    st_cone.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Cone"]];
    st_shuttle.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Shuttle"]];
    st_braod.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Broad"]];
    st_vertical.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Vertical"]];
    //st_bench.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Bench"]];
    st_10.text = [NSString stringWithFormat:@"%@",[appDelegate.currentPlayer objectForKey:@"Ten"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 30;
    }
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inside"] isEqualToString:@"true"]){
        if(section==1){
            return 0.1f;
        }
        else{
            return 30;
        }
        
    }
    else{
        if(section==1){
            return 30;
        }
        else{
            return 0.1f;
        }
        
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section]==0){
        cell.hidden = false;
        
        return;
    }
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inside"] isEqualToString:@"true"]){
        if([indexPath section]==1){
            cell.hidden = true;
        }
        else{
            cell.hidden = false;
        }
        
    }
    else{
        if([indexPath section]==1){
            cell.hidden = false;
        }
        else{
            cell.hidden = true;
        }
        
    }
}


/*

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath row]==0){
        return 62;
    }
    
    if([indexPath row]==1 || [indexPath row]==5  || [indexPath row]==9){
        return 20;
    }
    
    
    if([indexPath row]==2){
        if(masterCommand == 1){
            return 401;//370
        }
        else{
            return 1;
        }
        
    }
    
    if([indexPath row]==3){
        if(masterCommand == 0){
            return 62;
        }
        else{
            return 1;
        }
        
    }
    
    if([indexPath row]==4){
        if(masterCommand==0){
            return 142;
        }
        else{
            return 1;
        }
        
    }
    
    if([indexPath row]==7){
        if(masterCommand ==1){
            return 20;
        }
        else{
            return 1;
        }
        
    }
    
    if([indexPath row]==8){
        if(masterCommand == 1){
            return 48;
        }
        else{
            return 1;
        }
        
    }
    
    
    
    return 48;
    
    
}
*/

- (IBAction)unlockaction:(id)sender {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    rememberLeague = appDelegate.activeSelectedLeague;
    appDelegate.activeSelectedLeague = -1;
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbViewDetailInfo"];
    
    
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
