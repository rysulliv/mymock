//
//  draftAppDelegate.m
//  jabberwooki
//
//  Created by Dev on 2/7/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Flurry.h"
#import "UAirship.h"
#import "UAPush.h"
#import "APIcalls.h"
#import "Reachability.h"
#import "RageIAPHelper.h"
#import "menucontainerView.h"
#import "passDetilView.h"


@implementation draftAppDelegate
@synthesize menuParent;
@synthesize purchaseIDScreen;
@synthesize fromBKmode;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //RYAN HERE ARE THE SETTINGS FOR TRIGGERING WHICH SEASON PASS WAS PURCHASED
    

    
    
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [Flurry startSession:@"6SC3GPZHZ8Y7MTX2GNF7"];
    [Flurry logEvent:@"App Launched"];
    
    
    //Create Airship options dictionary and add the required UIApplication launchOptions
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];

    [UAirship takeOff:takeOffOptions];    // Register for notifications
    [[UAPush shared]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
        
    return YES;
}
void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    [[UAPush shared] registerDeviceToken:deviceToken];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    fromBKmode = true;
    [menuParent enteredForeground];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     [UAirship land];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//FACEBOOK STUFF
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            //log the user in and show the main window
            [[[FBRequest alloc] initWithSession:session graphPath:@"me"] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 NSLog(@"request open");
                 if (!error) {
                     //self.userNameLabel.text = user.name;
                     //self.userProfileImage.profileID = user. id;
                     NSString *userName = user.id;
                     
                     NSLog(@"User Name ,%@",userName);
                     
                     NSLog(@"Token ,%@", session.accessToken);
                     
                     
                 }
             }];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"user_likes", @"read_stream", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [self.session handleOpenURL:url];
}

-(void) loadServerStuff{
    APIcalls *holder = [[APIcalls alloc] init];
    
    [holder loadNow];

}








//START OF IN APP




-(void) checkStore{
    
    NSLog(@" in check");
    if(checkingappstre == false){
        checkingappstre = true;
        if(_products == nil){
            //need to put up spinner ... and wait ...
            NSLog(@"here in reachable loading products");
            [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (success) {
                    _products = products;
                }
            }];
            
        }
    }
    
    
}

-(void) cycleinAppTry{
    [self inappPurchaseAction:inAppHolderTemp];
}


-(void) inappPurchaseAction:(NSString*) productID{
    if ([self reachable]) {
        [menuParent loadingShow];
        
        NSLog(@"Reachable--");
        
        [self checkStore];
        
        NSLog(@"product count:%i",[_products count]);
        if([_products count]< 1){
            inAppHolderTemp = productID;
            [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(cycleinAppTry) userInfo:nil repeats:NO];
/*                    [menuParent loadingHide];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apple Store"
                                                            message:@"It appears there are no products in the Store for purchase."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK!"
                                                  otherButtonTitles:nil];
            [alert show];
*/
            
        }
        else{
            
            //product list...
            
            //product list compared to product id...
            
            NSString *stringID = productID;
            
            
            for(SKProduct *product in _products){
                if([stringID isEqualToString:product.productIdentifier]){
                    NSLog(@"compared ok - purchasing");
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                }
                else{
                    NSLog(@"products:%@ compare:%@",product.productIdentifier,stringID);
                }
                
                
            }
            
            
            //            NSLog(@"products: %i",[_products count]);
            //
            //            SKProduct *product = _products[productID];
            //            NSLog(@"Buying %@...", product.productIdentifier);
            //            [[RageIAPHelper sharedInstance] buyProduct:product];
            
            checkingappstre = false;
        }
        
    } else{
        //add spinner to main view ...
        [menuParent loadingHide];
        
        NSLog(@"Not Reachable");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apple Store"
                                                        message:@"It appears your device is not connected to the network. Please connect perform this task."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
    
}
-(void) restoreAppPurchase{
    
    
    if ([self reachable]) {
        NSLog(@"Reachable");
        
        NSLog(@"product count:%i",[_products count]);
        
        [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
    } else{
        //add spinner to main view ...
        [menuParent loadingHide];
        
        NSLog(@"Not Reachable");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apple Store"
                                                        message:@"It appears your device is not connected to the network. Please connect perform this task."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK!"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
    
}


-(BOOL)reachable {
    
    NSLog(@"reachable");
    
    Reachability *r = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"request");
	// Populate the inappBuy button with the received product info.
	SKProduct *validProduct = nil;
    
	int count = [response.products count];
	if (count>0) {
		validProduct = [response.products objectAtIndex:0];
	}
	if (!validProduct) {
        
        //maybe alert?
        return;
        
	}
    
    //In app purchase update
    
    /*
     AppVersionState = APPSTATEVERSION;
     
     if([[[NSUserDefaults standardUserDefaults] valueForKey:@"PremierContent"] boolValue]){
     AppVersionState = 2;
     }
     
     [masterViewController setupMenu];
     */
}


-(void) productsRefresh{
    _products = nil;
    NSLog(@"**sproduct refresh");
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            NSLog(@"**success");
            _products = products;
            //            [self.tableView reloadData];
        }
        NSLog(@"**stop refreshing");
    }];
}

-(void) inapppurcahsewillappear{
    NSLog(@"here in app all will purchase");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}

- (void)productPurchased:(NSNotification *)notification {
    NSLog(@"productpurchased");
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            *stop = YES;
        }
    }];
    
}

-(void) stopInAppDisplay{
    
    [menuParent loadingHide];
}


-(void) activateProduct{
    
    NSLog(@"activating product complete");
    
    APIcalls *holder = [[APIcalls alloc]init];
    
    [holder setDrafts];
    
    [menuParent loadingHide];
    
    [purchaseIDScreen CompletePurchase];
    
    //NEED A WAY TO REFRESH CURRENTT SCREEN ....
    //LETS GET A ID SCREEN....
    
    
}


@end
