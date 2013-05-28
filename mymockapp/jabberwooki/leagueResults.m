//
//  leagueResults.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/12/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "leagueResults.h"
#import "draftAppDelegate.h"
#import "menucontainerView.h"

@interface leagueResults ()

@end

@implementation leagueResults
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *urlAddress = @"http://draft.aws.af.cm/api/leagueresults";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.menuParent triggerMenuAction];

}


@end
