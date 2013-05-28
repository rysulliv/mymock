//
//  playersListViewController.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "playersListViewController.h"
#import "draftAppDelegate.h"
#import "playerCell.h"
#import "menucontainerView.h"
#import "Flurry.h"

@interface playersListViewController ()

@end

@implementation playersListViewController

@synthesize menubutton_;


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

    //check

    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    playerList = [[NSMutableArray alloc]init];
    
    playerList = appDelegate.players;

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
    return [playerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"sbPlayerCell";
    
    playerCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[playerCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    [cell configCell:[playerList objectAtIndex:[indexPath row]]];
    
    
    
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [[appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague] objectForKey:@"picks"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Name ==  %@)", [[playerList objectAtIndex:[indexPath row]] objectForKey:@"Name"]];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    if([holderData count]>0){
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    
    
    
    // Configure the cell...
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    
    NSArray *holderData = [[appDelegate.leagues objectAtIndex: appDelegate.activeSelectedLeague] objectForKey:@"picks"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Name ==  %@)", [[playerList objectAtIndex:[indexPath row]] objectForKey:@"Name"]];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    if([holderData count]>0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Already Placed"
                                                          message:@"This player has already been placed, please make a different selection."
                                                         delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles: nil];
        [message show];

        
        
        return;
    }

    

    appDelegate.currentPlayer = [playerList objectAtIndex:[indexPath row]];
    
    
    NSMutableDictionary *dictTEMP = [NSMutableDictionary dictionary];
    
    dictTEMP = [NSMutableDictionary dictionary];
    [dictTEMP setObject:[[playerList objectAtIndex:[indexPath row]] objectForKey:@"Name" ] forKey:@"Name"];
    [dictTEMP setObject:[[playerList objectAtIndex:[indexPath row]] objectForKey:@"Position" ] forKey:@"Position"];
    [dictTEMP setObject:[[playerList objectAtIndex:[indexPath row]] objectForKey:@"School" ] forKey:@"School"];
    [dictTEMP setObject:[[playerList objectAtIndex:[indexPath row]] objectForKey:@"_id" ] forKey:@"id"];

    
    [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] removeObjectAtIndex:appDelegate.draftRoundPlaceSelected];
    
    [[[appDelegate.leagues objectAtIndex:appDelegate.activeSelectedLeague] objectForKey:@"picks"] insertObject:dictTEMP atIndex:appDelegate.draftRoundPlaceSelected];
     
     
     //objectAtIndex:appDelegate.draftRoundPlaceSelected]
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.currentPlayer = [playerList objectAtIndex:[indexPath row]];
    
    NSString *info = [NSString stringWithFormat:@"Player Detail: %@",[appDelegate.currentPlayer objectForKey:@"Name"]];
    
    [Flurry logEvent:info];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}










- (IBAction)filter:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Filter By" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil  otherButtonTitles:@"Position",@"School", @"View Full List",nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
/*
    filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterView"];
    
    //contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    //picksView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:filterView.view];
    
//    contentView.bounds = picksView.view.bounds;
*/
    
}

- (IBAction)menuButton:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.menuParent triggerMenuAction];
}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (buttonIndex == 0) {
        
        action = 1;
        //set data source...
        
        //    appDelegate.schools
        
        pickerlist = [[NSMutableArray alloc]init];
        [pickerlist addObjectsFromArray:appDelegate.positions];
        
        actionSheetSetup = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        
        [actionSheetSetup setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        [actionSheetSetup addSubview:pickerView];
        //        [pickerView release];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        [actionSheetSetup addSubview:closeButton];
        //        [closeButton release];
        
        [actionSheetSetup showInView:[[UIApplication sharedApplication] keyWindow]];
        
        [actionSheetSetup setBounds:CGRectMake(0, 0, 320, 485)];
        
        
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSArray *holderData = [appDelegate.players copy];
        
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Position ==  %@)", [pickerlist objectAtIndex:0]];
        holderData = [holderData filteredArrayUsingPredicate:predicate];
        
        playerList = [holderData copy];
        
        [self.tableView reloadData];
    }

    if (buttonIndex == 1) {
        
        action = 2;
        //set data source...
        
        //    appDelegate.schools
        
        pickerlist = [[NSMutableArray alloc]init];
        [pickerlist addObjectsFromArray:appDelegate.schools];
        
        actionSheetSetup = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        [actionSheetSetup setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        [actionSheetSetup addSubview:pickerView];
//        [pickerView release];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        [actionSheetSetup addSubview:closeButton];
//        [closeButton release];
        
        [actionSheetSetup showInView:[[UIApplication sharedApplication] keyWindow]];
        
        [actionSheetSetup setBounds:CGRectMake(0, 0, 320, 485)];
        
        
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSArray *holderData = [appDelegate.players copy];
        
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(School ==  %@)", [pickerlist objectAtIndex:0]];
        holderData = [holderData filteredArrayUsingPredicate:predicate];
        
        playerList = [holderData copy];
        
        [self.tableView reloadData];

        
    }

    

    if (buttonIndex == 2) {
        playerList = [[NSMutableArray alloc]init];
        
        playerList = appDelegate.players;
        
        [self.tableView reloadData];

    }

    
//    [self.tableView reloadData];
    
    
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    //    if(component==0){
    //        return [distance count];
    //    }
    
    return [pickerlist count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    if(component==0){
    //        return [distance objectAtIndex:row];
    ///    }
//    if(component==0){
        return [pickerlist objectAtIndex:row];
/*    }
    if(component==1){
        return [[[maincategory objectAtIndex:activeMain] objectForKey:@"sub"] objectAtIndex:row];
    }
    
    return 0;*/
	
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    //filter here
//    playerList = [[NSMutableArray alloc]init];
    
//    playerList = appDelegate.players;
    
  

    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.players copy];
    

    if(action == 1){
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Position ==  %@)", [pickerlist objectAtIndex:row]];
        holderData = [holderData filteredArrayUsingPredicate:predicate];
    }
    

    
    if(action == 2){
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(School ==  %@)", [pickerlist objectAtIndex:row]];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    }
    
    playerList = [holderData copy];

    [self.tableView reloadData];
    
    /*
    if(component==0){
        activeMain = row;
        
        
        
        [pickerDeals reloadComponent:1];
        [pickerDeals selectRow:0 inComponent:1 animated:true];
        type = [[[maincategory objectAtIndex:activeMain] objectForKey:@"subtag"] objectAtIndex:0];
        titleType =  [[[maincategory objectAtIndex:activeMain] objectForKey:@"sub"] objectAtIndex:0];
        
    }
    
    if(component==1){
        //loader and process...
        
        type = [[[maincategory objectAtIndex:activeMain] objectForKey:@"subtag"] objectAtIndex:row];
        titleType =  [[[maincategory objectAtIndex:activeMain] objectForKey:@"sub"] objectAtIndex:row];
        
        
    }
    */
    ////---NSLog(@"----------");
	
    ////---NSLog(@"audio :%@",arrayofAudio);
	////---NSLog(@"Selected audio: %@. Index of selected audio: %i", [arrayofAudio objectAtIndex:row], row);
    //parentFob.audioname = [arrayofAudio objectAtIndex:row];
    //save audio name to fob...
    //[parentFob saveFob];
}

/*


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    retval = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 0.0f,
                                                       [pickerView rowSizeForComponent:component].width,
                                                       [pickerView rowSizeForComponent:component].height)];
    
    retval.text = @"longer test";//[[maincategory objectAtIndex:row] objectForKey:@"main"];
    */
    /*
    UILabel *retval = (id)view;
    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 0.0f,
                                                           [pickerView rowSizeForComponent:component].width,
                                                           [pickerView rowSizeForComponent:component].height)];
    }
    retval.numberOfLines = 2;
    retval.opaque = NO;
    retval.backgroundColor = [UIColor clearColor];
    
     */
    /*
     if(component==0){
     retval.font = [UIFont systemFontOfSize:10];
     
     retval.text = [distance objectAtIndex:row];
     
     }
     */
    
    /*
    if(component==0){
        retval.font = [UIFont systemFontOfSize:13];
        
        retval.text = [[maincategory objectAtIndex:row] objectForKey:@"main"];
    }
    if(component==1){
        retval.font = [UIFont systemFontOfSize:13];
        
        retval.text = [[[maincategory objectAtIndex:activeMain] objectForKey:@"sub"] objectAtIndex:row];
    }
    */
    //        retval.textAlignment = UITextAlignmentLeft;
//    return retval;
//}

/*
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //    if (component == 0) {
    ///        return 45;
    //    }
    return 155;
}
*/


- (void)dismissActionSheet:(id)sender{
    [actionSheetSetup dismissWithClickedButtonIndex:0 animated:YES];
//    [_myButton setTitle:@"new title"]; //set to selected text if wanted
}


@end
