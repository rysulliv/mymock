//
//  menucontainerView.h
//  HotDeals
//
//  Created by Ryan Sullivan on 12/2/12.
//  Copyright (c) 2012 unknown. All rights reserved.
//

#import "draftViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface menucontainerView : draftViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    float layerPosition;
    
    UINavigationController *SeasonPassView;
    UITableViewController *picksView;
    UINavigationController *PlayerView;
    UIViewController *ResultsView;
}


-(void) triggerMenuAction;
- (IBAction)rightButtonMenuTrigger:(id)sender;

-(void) loadPassScreen;
-(void) loadPicks;
-(void) loadPlayerView;

@property (strong, nonatomic) IBOutlet UIView *menubottomView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *toplayer;
- (IBAction)hiddenMneuButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *hiddenButton;

-(void) friendShare;

-(void) loadResults;

-(void) loadingShow;
-(void) loadingHide;


-(void) enteredForeground;

@end
