//
//  detailViewCell.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewCell : UITableViewCell{
    
    IBOutlet UILabel *title;
    IBOutlet UILabel *description;
    
    IBOutlet UILabel *price;
    IBOutlet UILabel *rankPlaceNumber;
    IBOutlet UILabel *rankTitle;
    IBOutlet UILabel *rankDescription;
    IBOutlet UITextView *officialRules;
    IBOutlet UILabel *purchasePrice;
}

-(void) setupCell:(NSDictionary*)object :(int) row;
-(void) setupCell2:(NSDictionary*)object :(int) row;

@end
