//
//  playerRanksTable.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerRanksTable : UITableView<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *details;
}

-(void) activateTable;

-(void) activateTable:(int) rankSet;

@end
