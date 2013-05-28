//
//  navViewController.m
//  HotDeals
//
//  Created by Ryan Sullivan on 12/2/12.
//  Copyright (c) 2012 unknown. All rights reserved.
//

#import "navViewController.h"
#import "draftAppDelegate.h"
#import "menucontainerView.h"
#import "Flurry.h"

@interface navViewController ()

@end

@implementation navViewController

@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    parent = appDelegate.menuParent;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuButtonAction:(id)sender {
    
    if(parent == nil){
        draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        parent = appDelegate.menuParent;
    }
    
    
    UIButton *button = (UIButton*)sender;
    
    
    
    switch (button.tag) {
        case 1:
            [Flurry logEvent:@"Menu picks"];
            [parent loadPicks];
            [parent triggerMenuAction];
            break;
        case 2:

            break;
        case 3:
            [Flurry logEvent:@"Menu Results"];
            [parent loadResults];
            [parent triggerMenuAction];            
            break;
        case 4:
            [Flurry logEvent:@"Menu FriendShare"];
            [parent friendShare];
            break;
        case 5:
            [Flurry logEvent:@"Menu Passes"];
            [parent loadPassScreen];
            [parent triggerMenuAction];
            break;
            break;
        case 6:
            [Flurry logEvent:@"Menu PlayerView"];            
            [parent loadPlayerView];
            [parent triggerMenuAction];
            break;
            
        default:
            break;
    }
    
     
    
}






@end
