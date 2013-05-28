//
//  draftPickTable.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftPickTable.h"
#import "draftAppDelegate.h"
#import "draftPickCell.h"
#import "playerStatsCell.h"
#import "menucontainerView.h"
#import "APIcalls.h"
#import "playersListViewController.h"

@interface draftPickTable ()

@end

@implementation draftPickTable
@synthesize toolbar;

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
    
    
    Draft =  [appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague];

    NSLog(@"league: %@",appDelegate.leagues);
    
    toolbar.title = [[Draft objectForKey:@"data"] objectForKey:@"Name"];
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    
    NSLog(@"DRAFT:%@",Draft);
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
    if(tableView.tag==2){
        return [details count];
    }

    // Return the number of rows in the section.
    return [[Draft objectForKey:@"rounds"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = @"sbDraftCell";
    
    draftPickCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[draftPickCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary * playerInfo;
    
    if([[Draft objectForKey:@"picks"] count] > [indexPath row]){
        playerInfo = [[Draft objectForKey:@"picks"] objectAtIndex:[indexPath row]];
    }
    

    [cell configCell:[[Draft objectForKey:@"rounds"] objectAtIndex:[indexPath row]] :playerInfo :[indexPath row]+1 :self:[[Draft objectForKey:@"roundsneeds"] objectAtIndex:[indexPath row]] ];
    

    
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
    
    if(appDelegate.AllowThisUserToSave==0 && appDelegate.activeSelectedLeague!=2){
    
        return;
    }

    
    
    if(tableView.tag==2){
        return;
    }


    appDelegate.draftRoundPlaceSelected = [indexPath row];

    
    
    //add seque
    
    playersListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPlayerListView"];
    
    
    [[self navigationController] pushViewController:controller animated:YES];
    
    
    
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
    if(tableView.tag==2){
        return 117;
    }
    
    return 117;
}


- (IBAction)backAction:(id)sender {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.AllowThisUserToSave==0 && appDelegate.activeSelectedLeague!=2){
        [self dismissViewControllerAnimated:true completion:nil];
        return;
    }

    //    [self dismissViewControllerAnimated:true completion:nil];
    
    [appDelegate.menuParent loadingShow];
    
    //show updating processing...
    
    //post data to server ....
    
    ///the ndismiss
    
    [NSTimer scheduledTimerWithTimeInterval:(float)0.1 target:self selector:@selector(doactionnow) userInfo:nil repeats:NO];
    
}

- (IBAction)coppyOtherLeagues:(id)sender {
    
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Copy Picks From:" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil  otherButtonTitles:nil];
    
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int x = 0;
    
    while(x < [appDelegate.leagues count]){
        [popupQuery addButtonWithTitle:[[[appDelegate.leagues objectAtIndex:x] objectForKey:@"data"] objectForKey:@"Name"]];

        x++;
    }
    
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (buttonIndex == 0) {
        
    }
    else{
        
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *picksTemp = [[appDelegate.leagues objectAtIndex:buttonIndex-1]objectForKey:@"picks"];
        
        
        [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] removeAllObjects];
        
        [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] addObjectsFromArray:picksTemp];
        

        
    }
    
    Draft =  [appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague];

    
    [self.tableView reloadData];
    
    
}

- (IBAction)lockitin:(id)sender {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.menuParent loadingShow];
    
    //show updating processing...
    
    //post data to server ....
    
///the ndismiss
    
    [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(doactionnow) userInfo:nil repeats:NO];


}

-(void) doactionnow{
    
    //process to server ....
    
    //also need to get locked in date from server on loading of accounts....
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    Draft =  [appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague];

    //NSLog(@"draft: %@", Draft);
    
    APIcalls *holder = [[APIcalls alloc] init];
    
    
    NSMutableArray *holderPick = [[NSMutableArray alloc]init];
    
    int counter = 1;
    for(NSMutableDictionary *obj in [Draft objectForKey:@"picks"]){
     
        NSString *holderString = [NSString stringWithFormat:@"%i",counter];
        
        NSMutableDictionary *objTemp = [[NSMutableDictionary alloc]init];
        
        [objTemp setObject:[obj objectForKey:@"id"] forKey:@"PlayerId"];
        [objTemp setObject:[obj objectForKey:@"Name"] forKey:@"PlayerName"];
        [objTemp setObject:holderString forKey:@"Position"];
        
        [holderPick addObject:objTemp];

        counter++;
        
    }
    
    

    [holder postDrtaft:[[Draft objectForKey:@"data"]objectForKey:@"LeagueId"] : holderPick];
    
    
    [self dismissViewControllerAnimated:true completion:nil];

    
    [appDelegate.menuParent loadingHide];
    
}

//- (IBAction)teaminfopicks:(id)sender {
-(void) teaminfoPickerData :(int) position{
    
    
    //check data...
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inside"] isEqualToString:@"false"]){

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Inside Season Pass"
                                                          message:@"Please purchase an Inside Season Pass to view this data."
                                                         delegate:self
                                                cancelButtonTitle:@"Close"
                                                otherButtonTitles: nil];
        [message show];
        
        //After some time

        
        return;
    }
    
    
//    action = 1;
    //set data source...
    
    //    appDelegate.schools
    
  //  pickerlist = [[NSMutableArray alloc]init];
  //  [pickerlist addObjectsFromArray:appDelegate.positions];
    
    positionHolder = position;
    
    actionSheetSetup = [[UIActionSheet alloc] initWithTitle:@"The Pros Pick"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [actionSheetSetup setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    
    
    
    pickerlist = [[NSMutableArray alloc]init];
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",position];
    holderData = [holderData filteredArrayUsingPredicate:predicate];

    for(NSMutableDictionary *obj in holderData){
        
        
        NSArray *holderDataXX = [[appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague] objectForKey:@"picks"];
        
        NSPredicate *predicateXX = [NSPredicate predicateWithFormat:@"(Name ==  %@)", [obj objectForKey:@"Name"]];
        holderDataXX = [holderDataXX filteredArrayUsingPredicate:predicateXX];

        NSString* theStringHolderTemp = @"";
        
        if([holderDataXX count]>0){
            theStringHolderTemp = @"[placed]-";
        }
        
        
        //        NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Rank"]);
       // NSLog(@"rank: %@",[[details objectAtIndex:[indexPath row]] objectForKey:@"Percentage"]);


        NSMutableString *tempString = [NSString stringWithFormat:@"%@%@: %@%%",theStringHolderTemp,[obj objectForKey:@"Name"],        [obj objectForKey:@"Percentage"]];

        [pickerlist addObject:tempString];
    }
    
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    

    
    [actionSheetSetup addSubview:pickerView];

    
    //CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    
//    teamInfoTable.dataSource = self;
//    teamInfoTable.delegate = self;
    

    //        [pickerView release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheetSetup addSubview:closeButton];

    UISegmentedControl *selectButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Select"]];
    selectButton.momentary = YES;
    selectButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    selectButton.segmentedControlStyle = UISegmentedControlStyleBar;
    selectButton.tintColor = [UIColor blackColor];
    [selectButton addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventValueChanged];
    [actionSheetSetup addSubview:selectButton];

    //        [closeButton release];
    
    
    
//    CustomView *innerView = [[CustomView alloc] initWithNibName:@"CustomView" bundle:nil];
//    innerView.view.frame = CGRectMake(0, 10, 320, 210);
//    [asheet addSubview:innerView.view];
//    teamInfoTable = [[playerRanksTable alloc] initWithFrame:CGRectMake(0, 40, 320, 305) style:UITableViewStylePlain];
//    teamInfoTable.dataSource = self;
//    teamInfoTable.delegate = self;
//    teamInfoTable.tag = 2;
//    teamInfoTable.frame = CGRectMake(0, 10, 320, 210);
    //[self activateTable:position];
    
   // [actionSheetSetup addSubview:teamInfoTable];
    
    
    
    
    [actionSheetSetup showInView:[[UIApplication sharedApplication] keyWindow]];//self.view];//
    
    [actionSheetSetup setBounds:CGRectMake(0, 0, 320, 485)];
    
    
    
    //set first spot
    
    NSArray *holderData2 = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",positionHolder];
    holderData2 = [holderData2 filteredArrayUsingPredicate:predicate2];
    
    ativePlayerSelect = [[holderData2 objectAtIndex:0]objectForKey:@"Name"];

    //[teamInfoTable activateTable:position];

    
    //[self.view addSubview:tableView];
    
//    teamInfoTable = [[playerRanksTable alloc]initWithFrame:CGRectMake(0, 40, 320, 305)];
//    [teamInfoTable setBounds:CGRectMake(0, 0, 320, 305)];

    
    //    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    //    pickerView.showsSelectionIndicator = YES;
    //    pickerView.dataSource = self;
    //    pickerView.delegate = self;
    
 
 
    
//    [self.tableView reloadData];
    //[teamInfoTable reloadData];
}


- (void)dismissActionSheet:(id)sender{
   //     [teamInfoTable activateTable:2];
   //[teamInfoTable reloadData];
    [actionSheetSetup dismissWithClickedButtonIndex:0 animated:YES];
    //    [_myButton setTitle:@"new title"]; //set to selected text if wanted
}

- (void)SelectAction:(id)sender{
    
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    appDelegate.currentPlayer = [playerList objectAtIndex:[indexPath row]];
    
  
    
    
    
    NSArray *holderData = [appDelegate.players copy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Name ==  %@)",ativePlayerSelect ];
    
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    if([holderData count] > 0){
    
        
        NSArray *holderDataXX = [[appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague] objectForKey:@"picks"];
        
        NSPredicate *predicateXX = [NSPredicate predicateWithFormat:@"(Name ==  %@)", [[holderData objectAtIndex:0] objectForKey:@"Name"]];
        holderDataXX = [holderDataXX filteredArrayUsingPredicate:predicateXX];
        
        
        if([holderDataXX count]>0){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Already Placed"
                                                              message:@"This player has already been placed, please make a different selection."
                                                             delegate:self
                                                    cancelButtonTitle:@"ok"
                                                    otherButtonTitles: nil];

            [actionSheetSetup dismissWithClickedButtonIndex:0 animated:YES];
            //[actionSheetSetup addSubview:message];

            [message show];
            return;
        }
        

        
        NSMutableDictionary *dictTEMP = [NSMutableDictionary dictionary];
        dictTEMP = [NSMutableDictionary dictionary];
        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"Name"] forKey:@"Name"];
        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"Position"] forKey:@"Position"];
        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"School"] forKey:@"School"];
        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"_id"] forKey:@"id"];
        
    
    [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] removeObjectAtIndex:positionHolder-1];
    
    [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] insertObject:dictTEMP atIndex:positionHolder-1];
    
        [self.tableView reloadData];
    }
    
    //     [teamInfoTable activateTable:2];
    //[teamInfoTable reloadData];
    [actionSheetSetup dismissWithClickedButtonIndex:0 animated:YES];
    //    [_myButton setTitle:@"new title"]; //set to selected text if wanted
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {

    return [pickerlist count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerlist objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",positionHolder];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    ativePlayerSelect = [[holderData objectAtIndex:row]objectForKey:@"Name"];
    
    

}








-(void) activateTable:(int) rankSet{
    
    // self.dataSource = self;
    // self.delegate = self;
    
    
//    self.tag = 2;
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",rankSet];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    details = [holderData copy];
    
    [teamInfoTable reloadData];
    
    //[self reloadData];
    
    //  details = appDelegate.playerRanks;
    
    
    
}

@end
