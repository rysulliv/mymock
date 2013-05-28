//
//  leagueCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "leagueCell.h"
#import "draftAppDelegate.h"

#import "draftPicks.h"

@implementation leagueCell

@synthesize leagueNumber;
@synthesize leagueTitle;
@synthesize leftLowerAction;
@synthesize dateTimeSaved;
@synthesize parent;
@synthesize getapass;
@synthesize presstopick;
@synthesize draftClosed;

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



-(void) configCell:(NSDictionary*)object :(int)row :(int) type{
    leagueTitle.text = [object objectForKey:@"Name"];
    leagueNumber.text = [NSString stringWithFormat:@"%i",row];
    leftLowerAction.text = @"";
    dateTimeSaved.text = @"";
    
    getapass.hidden = true;
    presstopick.hidden = true;
    if(type==1){
        presstopick.hidden = false;

    }
    else{
        getapass.hidden = false;
    }
    
    rowHolder = row - 1;
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.AllowThisUserToSave==0 && rowHolder < 2){
        draftClosed.hidden = false;
        getapass.hidden = true;
        presstopick.hidden = true;
        
    }
    else{
       draftClosed.hidden = true;
    }
}

- (IBAction)infoAction:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    appDelegate.activeSelectedLeague = rowHolder;
    
    [parent menuActionAwayDetails];

    
//    

    
}

@end
