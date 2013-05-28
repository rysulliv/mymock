//
//  seasonPassCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seasonPassCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *getAticket;
@property (strong, nonatomic) IBOutlet UILabel *youAreEnrolled;
@property (strong, nonatomic) IBOutlet UILabel *leagueTitle;
@property (strong, nonatomic) IBOutlet UILabel *position;


-(void) setupCell:(int)row :(int) enrolled :(NSString*)title;

@end
