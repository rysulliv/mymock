//
//  draftMasterCountScreen.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/7/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draftMasterCountScreen : UIViewController <UIActionSheetDelegate>{
    
    int remainseconds;
    int timerflag;
    
    int infrontofme;
    int totalcountpeople;
    
    int tempinFrontofMe;
    int tempCountPeople;
    
    BOOL isCounting;
    BOOL isFirstLoad;
    
    
    BOOL notSCreenFirstShow;
    
    NSMutableData *_data;
    
}

@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *inFrontPeople;
@property (strong, nonatomic) IBOutlet UILabel *totalPeople;
@property (strong, nonatomic) IBOutlet UIWebView *newsFeed;
- (IBAction)moveUpPress:(id)sender;
 
@end
