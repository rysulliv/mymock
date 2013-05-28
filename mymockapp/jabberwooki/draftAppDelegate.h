//
//  draftAppDelegate.h
//  jabberwooki
//
//  Created by Dev on 2/7/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import <FacebookSDK/FacebookSDK.h>

@interface draftAppDelegate : UIResponder <UIApplicationDelegate>{
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
    
    NSString * inAppHolderTemp;
    
    BOOL checkingappstre;

}


@property (strong, nonatomic) FBSession *session;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) id menuParent;
@property (nonatomic,retain) id purchaseIDScreen;

@property (nonatomic,retain) NSMutableArray *players;
@property (nonatomic,retain) NSMutableArray *playerRanks;
@property (nonatomic,retain) NSDictionary *currentPlayer;
@property (nonatomic,retain) NSMutableArray *teamPickOrder;
@property (nonatomic,retain) NSMutableArray *leagues;
@property (nonatomic,retain) NSMutableArray *schools;
@property (nonatomic,retain) NSMutableArray *positions;
@property (nonatomic,retain) NSMutableArray *teamRank;

@property (nonatomic, retain) NSMutableDictionary *insideInfo;
@property (nonatomic) int activeSelectedLeague;
@property (nonatomic) int draftRoundPlaceSelected;

@property (nonatomic) int allowSave1;
@property (nonatomic) int allowSave2;

@property (nonatomic) int AllowThisUserToSave;

-(void) loadServerStuff;

@property (nonatomic) BOOL fromBKmode;

-(void) inappPurchaseAction:(NSString*) productID;
-(void) stopInAppDisplay;
-(void) activateProduct;
-(void) restoreAppPurchase;


@end
