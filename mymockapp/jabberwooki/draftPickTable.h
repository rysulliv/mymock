//
//  draftPickTable.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playerRanksTable.h"

@interface draftPickTable : UITableViewController <UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSMutableDictionary *Draft;
    
    UIActionSheet *actionSheetSetup;
    
    playerRanksTable *teamInfoTable;
    
       NSMutableArray *details;
    
        NSMutableArray *pickerlist;
    
    int positionHolder;
    NSString* ativePlayerSelect;
}
- (IBAction)backAction:(id)sender;
- (IBAction)coppyOtherLeagues:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *toolbar;
- (IBAction)lockitin:(id)sender;
- (IBAction)teaminfopicks:(id)sender;
-(void) teaminfoPickerData :(int) position;

@end
