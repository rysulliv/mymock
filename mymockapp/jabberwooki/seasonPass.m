//
//  seasonPass.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/20/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "seasonPass.h"
#import "draftAppDelegate.h"
#import "menucontainerView.h"

@interface seasonPass ()

@end

@implementation seasonPass

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
    
//    self.navigationController.view
    
   // self.navigationController.view.frame =  CGRectMake(0, -14, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    //self.view.frame = CGRectMake(0, -14, self.view.frame.size.width, self.view.frame.size.height);
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (IBAction)menuButton:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate.menuParent triggerMenuAction];
    
}
@end
