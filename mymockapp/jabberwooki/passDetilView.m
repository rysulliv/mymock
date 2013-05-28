//
//  passDetilView.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "passDetilView.h"
#import "draftAppDelegate.h"
#import "detailViewCell.h"

@interface passDetilView ()

@end

@implementation passDetilView

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
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.purchaseIDScreen = self;
    
    showPurchase = true;
    
    TableType = 0;
    
    
    if(appDelegate.activeSelectedLeague == -1){
        theObject =  appDelegate.insideInfo;
        TableType = 1;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inside"]isEqualToString:@"true"]){
            showPurchase = false;
        }
    }
    else{
        theObject =  [appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague];
        
        if(appDelegate.activeSelectedLeague == 0 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league01"] isEqualToString:@"true"]){
            showPurchase = false;
        }
        if(appDelegate.activeSelectedLeague == 1 && [[[NSUserDefaults standardUserDefaults] valueForKey:@"league02"]isEqualToString:@"true"]){
            showPurchase = false;
        }
        if(appDelegate.activeSelectedLeague == 2 ){
            showPurchase = false;
        }
        

    }


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    
    [super viewDidAppear:animated];
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
    if(TableType==0){
        return 4;
    }
    if(TableType==1){
        return 4;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2 && (TableType == 1 || TableType == 0)){
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.activeSelectedLeague == -1){
            return [[theObject objectForKey:@"Perks"] count];            
            
        }

        return [[[theObject objectForKey:@"data"] objectForKey:@"Prizes"] count];
    }
    
    if(section==0){
        //check to see if purchases ... if not then
        if(showPurchase){
            return 2;
        }
        else{
            return 1;
        }
    }

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    if([indexPath section]==0){
        if([indexPath row]==0){
            CellIdentifier = @"sbDetailName";
        }
        else{
            
            CellIdentifier = @"sbPurchase";
        }
    }
    if([indexPath section]==1){
        CellIdentifier = @"sbDetailDescription";
    }
    if([indexPath section]==2){
        CellIdentifier = @"sbDetailRank";
    }
    if([indexPath section]==3){
        CellIdentifier = @"sbDetailOfficial";
    }
    
    
    detailViewCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[detailViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.activeSelectedLeague == -1){
        [cell setupCell2: theObject:[indexPath row]];
        
    }
    else{
        [cell setupCell: [theObject objectForKey:@"data"] :[indexPath row]];
    }
    

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
        return @"";
    }
    if (section == 1)
    {
        if(TableType == 0){
            return @"Description";
        }
        else{
            return @"Description";
        }
    }
    if (section == 2)
    {
        if(TableType == 0){
            return @"Rank Prizes";
        }
        else{
            return @"Features";
        }
    }
    if (section == 3)
    {
        return @"Official Rules";
    }

    return @"";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    return 71;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)buyAction:(id)sender {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if(appDelegate.activeSelectedLeague == -1){
        [appDelegate inappPurchaseAction:@"inside"];
        
    }
    else{
        theObject =  [appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague];
        
        if(appDelegate.activeSelectedLeague == 0){
            [appDelegate inappPurchaseAction:@"league01"];
        }
        if(appDelegate.activeSelectedLeague == 1){
            [appDelegate inappPurchaseAction:@"league02"];
        }
        
    }
    


    
    /*
    
    srhAppDelegate *appDelegate = (srhAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate restoreAppPurchase];
    [self dismissViewControllerAnimated:YES completion:nil];
*/
    
    
//TEMP ACTION!!!!!!!!
    
    /*
    //ISSUE POSSIBLILIT SINCE LEAGUE ID's CHAGNES /// THIS USES ARRAYS NOT ID!!!!!
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.activeSelectedLeague == -1){
        [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"inside"];
    }
    else{
        if(appDelegate.activeSelectedLeague == 0){
            
            [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"league01"];

        }
        if(appDelegate.activeSelectedLeague == 1 ){
            [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"league02"];
        }
    }

        [self dismissViewControllerAnimated:TRUE completion:nil];

*/
}


-(void) CompletePurchase{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
