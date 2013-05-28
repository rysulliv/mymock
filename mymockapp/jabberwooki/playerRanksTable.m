//
//  playerRanksTable.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "playerRanksTable.h"
#import "draftAppDelegate.h"
#import "playerStatsCell.h"

@implementation playerRanksTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
    
    /*        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(forum ==  %@)",forumFilter];
     holderData = [holderData filteredArrayUsingPredicate:predicate];
*/
}

-(id) init{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void) activateTable{
    
    self.dataSource = self;
    self.delegate = self;
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Name ==  %@)",[appDelegate.currentPlayer objectForKey:@"Name"]];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    details = [holderData copy];
    
    [self reloadData];
    
    //  details = appDelegate.playerRanks;
    
    

}


-(void) activateTable:(int) rankSet{
    
   // self.dataSource = self;
   // self.delegate = self;
    
    
    self.tag = 2;
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",rankSet];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    details = [holderData copy];
    
    [self reloadData];
    
    //  details = appDelegate.playerRanks;
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [details count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.tag == 2){
        
        
        NSString *CellIdentifier;
        
        
        CellIdentifier = @"sbPlayerStatsCell02";
        //playerStatsCell *cell;
        
        playerStatsCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[playerStatsCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        NSLog(@" cell: %@",cell);
        
        cell.hidden = false;
        
        NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Rank"]);
        NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"]);
        
//        cell.rank.text = [NSString stringWithFormat:@"Pick #%@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Rank"]];
//        cell.percent.text = [NSString stringWithFormat:@"%@%%",[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"]];
        [cell setupCell:[[details objectAtIndex:[indexPath row]] objectForKey:@"Name"] :[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"] ];
        
        NSLog(@" cell: %@",     cell.playerpercent.text);
        
        
        
        
        
        return cell;
    }
    
    
    NSString *CellIdentifier;
    
    
    CellIdentifier = @"sbPlayerStatsCell";
    
    
    playerStatsCell *cell = [tableView
                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[playerStatsCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Rank"]);
    NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"]);
    
    cell.rank.text = [NSString stringWithFormat:@"Pick #%@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Rank"]];
    cell.percent.text = [NSString stringWithFormat:@"%@%%",[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"]];

    
    NSLog(@" cell: %@",     cell.rank.text);
    
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}




@end
