//
//  draftPickCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftPickCell.h"
#import "draftPickTable.h"
#import "draftAppDelegate.h"

@implementation draftPickCell
@synthesize teamName;
@synthesize placeOrder;
@synthesize playerName;
@synthesize playerPosition;
@synthesize playerSchool;
@synthesize parent;
@synthesize positionHolder;
@synthesize need01;
@synthesize need02;
@synthesize teaminfobuttonobj;

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

- (IBAction)teamInfoButton:(id)sender {
    [parent teaminfoPickerData:positionHolder];
}

-(void) configCell:(NSString*)teamNamePass :(NSDictionary*)player :(int) position :(id) parentS :(NSMutableArray*) Needs{
    teamName.text = teamNamePass;
    playerName.text = [player objectForKey:@"Name"];
    playerPosition.text = [player objectForKey:@"Position"];
    playerSchool.text = [player objectForKey:@"School"];
    placeOrder.text = [NSString stringWithFormat:@"%i",position];
    
    parent = parentS;
    positionHolder = position;
    
    
    need01.text = @"";
    need02.text = @"";
    
    
    if([Needs count] > 0){
    need01.text = [NSString stringWithFormat:@"%@ - %@%%",[[Needs objectAtIndex:0] objectForKey:@"spot"],[[Needs objectAtIndex:0] objectForKey:@"percent"]];
    }

    if([Needs count] > 1){
        need02.text = [NSString stringWithFormat:@"%@ - %@%%",[[Needs objectAtIndex:1] objectForKey:@"spot"],[[Needs objectAtIndex:1] objectForKey:@"percent"]];
    }
    
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.AllowThisUserToSave==0 && appDelegate.activeSelectedLeague!=2){
        teaminfobuttonobj.enabled = false;
        teaminfobuttonobj.hidden = true;
    }


}


@end
