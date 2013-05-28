//
//  playerStats.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playerRanksTable.h"

@interface playerStats : UITableViewController{
    
    IBOutlet playerRanksTable *rankTable;
    IBOutlet UILabel *st_40;
    
    IBOutlet UILabel *st_cone;
    IBOutlet UILabel *st_shuttle;
    IBOutlet UILabel *st_braod;
    IBOutlet UILabel *st_vertical;
    IBOutlet UILabel *st_bench;
    IBOutlet UILabel *st_10;
    IBOutlet UILabel *st_20;
    
    int rememberLeague;
}
@property (strong, nonatomic) IBOutlet UINavigationItem *navbar;
@property (strong, nonatomic) IBOutlet UILabel *position;
@property (strong, nonatomic) IBOutlet UILabel *school;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *pheight;
@property (strong, nonatomic) IBOutlet UILabel *pweight;

- (IBAction)unlockaction:(id)sender;



@end
