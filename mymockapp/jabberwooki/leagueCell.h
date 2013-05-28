//
//  leagueCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leagueCell : UITableViewCell{
    
    int rowHolder;
}
@property (strong, nonatomic) IBOutlet UILabel *leagueTitle;
@property (strong, nonatomic) IBOutlet UILabel *leftLowerAction;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeSaved;
@property (strong, nonatomic) IBOutlet UILabel *leagueNumber;

-(void) configCell:(NSDictionary*)object :(int) row:(int) type;
- (IBAction)infoAction:(id)sender;

@property (strong,nonatomic) id parent;
@property (strong, nonatomic) IBOutlet UILabel *presstopick;
@property (strong, nonatomic) IBOutlet UILabel *getapass;
@property (strong, nonatomic) IBOutlet UILabel *draftClosed;

@end
