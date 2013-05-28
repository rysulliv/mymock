//
//  playerStatsCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerStatsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) IBOutlet UILabel *percent;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UILabel *playerpercent;

-(void) setupCell:(NSString*) playername_ :(NSString*) playerRankPercent;

@end
