//
//  seasonPass.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/20/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface seasonPass : UITableViewController


@property (strong, nonatomic) IBOutlet UINavigationItem *navbar;
@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)menuButton:(id)sender;

@end
