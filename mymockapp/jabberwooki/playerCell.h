//
//  playerCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UILabel *playerPosition;
@property (strong, nonatomic) IBOutlet UILabel *playerSchool;

-(void) configCell:(NSDictionary*)object;

@end
