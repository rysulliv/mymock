//
//  seasonPassCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "seasonPassCell.h"

@implementation seasonPassCell

@synthesize getAticket;
@synthesize youAreEnrolled;
@synthesize leagueTitle;
@synthesize position;

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

-(void) setupCell:(int)row :(int) enrolled :(NSString*)title{
    youAreEnrolled.hidden = true;
    getAticket.hidden = true;
    if(enrolled==1){
        youAreEnrolled.hidden = false;
    }
    else{
        getAticket.hidden = false;
    }
    
    leagueTitle.text = title;
    
    position.text = [NSString stringWithFormat:@"%i",row+1];
}

@end
