//
//  draftPickCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draftPickCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *placeOrder;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UILabel *playerPosition;
@property (strong, nonatomic) IBOutlet UILabel *playerSchool;

- (IBAction)teamInfoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *teaminfobuttonobj;

@property (nonatomic) int positionHolder;
@property (nonatomic,retain) id parent;

-(void) configCell:(NSString*)teamNamePass :(NSDictionary*)player :(int) position :(id) parentS :(NSMutableArray*) Needs;
@property (strong, nonatomic) IBOutlet UILabel *need01;
@property (strong, nonatomic) IBOutlet UILabel *need02;

@end
