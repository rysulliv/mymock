//
//  draftPicks.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/20/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draftPicks : UITableViewController

- (IBAction)menuButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *title01;

-(void) menuActionAwayDetails;

@end
