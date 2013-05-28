//
//  passDetilView.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface passDetilView : UITableViewController{
    int TableType;
    
    NSMutableDictionary *theObject;
    
    BOOL showPurchase;
}
- (IBAction)backAction:(id)sender; 
- (IBAction)buyAction:(id)sender;

-(void) CompletePurchase;

@end 
