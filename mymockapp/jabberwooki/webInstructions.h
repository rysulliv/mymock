//
//  webInstructions.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/10/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webInstructions : UIViewController
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
