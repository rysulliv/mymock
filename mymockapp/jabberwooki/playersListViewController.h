//
//  playersListViewController.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playersListViewController : UITableViewController <UIActionSheetDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSMutableArray *playerList;
    
    
    UIViewController *filterView;
    
    NSMutableArray *pickerlist;
    
    UIActionSheet *actionSheetSetup;
    
    int action;
    
}
- (IBAction)filter:(id)sender;

- (IBAction)menuButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menubutton_;

@end
