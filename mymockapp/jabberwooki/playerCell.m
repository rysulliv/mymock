//
//  playerCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "playerCell.h"

@implementation playerCell
@synthesize playerSchool;
@synthesize playerPosition;
@synthesize playerName;


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

-(void) configCell:(NSDictionary*)object{
    playerName.text = [object objectForKey:@"Name"];
    playerPosition.text = [object objectForKey:@"Position"];
    playerSchool.text = [object objectForKey:@"School"];
}

@end
