//
//  playerStatsCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "playerStatsCell.h"

@implementation playerStatsCell
@synthesize rank;
@synthesize percent;
@synthesize playerName;
@synthesize playerpercent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setupCell:(NSString*) playername_ :(NSString*) playerRankPercent{
    playerpercent.text = [NSString stringWithFormat:@"%@%%",playerRankPercent];
    playerName.text = [NSString stringWithFormat:@"%@",playername_];
}

@end
