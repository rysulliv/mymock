//
//  menucontainerView.m
//  HotDeals
//
//  Created by Ryan Sullivan on 12/2/12.
//  Copyright (c) 2012 unknown. All rights reserved.
//

#import "menucontainerView.h"
#import "draftAppDelegate.h"
#import "Flurry.h"



@interface menucontainerView ()

@end


#define VIEW_HIDDEN 265


@implementation menucontainerView

@synthesize contentView;
@synthesize hiddenButton;
@synthesize toplayer;


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
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.menuParent = self;
    
    [self loadPicks];
    [self triggerMenuAction];

    
    toplayer.hidden = false;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)0.2 target:self selector:@selector(loadServerStuffnow) userInfo:nil repeats:NO];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadServerStuffnow{
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadServerStuff];
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setToplayer:nil];
    [self setMenubottomView:nil];
    [self setHiddenButton:nil];
    [super viewDidUnload];
}



-(void) animateLayerToPoint: (CGFloat)x
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            CGRect frame = contentView.frame;
                            frame.origin.x = x;
                            contentView.frame = frame;
                        }
                     completion:^(BOOL finished){
                         layerPosition = contentView.frame.origin.x;
                     }];
}




-(void) triggerMenuAction{
    
    [self.view endEditing:true];
    
    if(layerPosition > 250){
        [self animateLayerToPoint:0];
            hiddenButton.hidden = true;
    }
    else{
        [self animateLayerToPoint:VIEW_HIDDEN];
        hiddenButton.hidden = false;
    }
    
}


- (IBAction)rightButtonMenuTrigger:(id)sender {
    [self triggerMenuAction];
}






#pragma mark screen loads

-(void) removeViews{
    
    //draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    if(SeasonPassView!= nil){
        [SeasonPassView.view removeFromSuperview];
        SeasonPassView = nil;
        
    }

    if(picksView!= nil){
        [picksView.view removeFromSuperview];
        picksView = nil;
        
    }

    if(PlayerView!= nil){
        [PlayerView.view removeFromSuperview];
        PlayerView = nil;
        
    }

    if(ResultsView!= nil){
        [ResultsView.view removeFromSuperview];
        ResultsView = nil;
        
    }
    
}

-(void) loadPicks{
    
    
    
    [self removeViews];
    
    
    
    
    //make season pass a view that loads modal display into it...??
    
    
    picksView = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPickes"];
    
    
    
    //dealMaps.parent = self;
    //SET TYPE HERE...
    
    contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    picksView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [contentView addSubview:picksView.view];
    
    
    
    
    contentView.bounds = picksView.view.bounds;

}

-(void) loadPassScreen{
    
    [self removeViews];
    
    
    
    
    //make season pass a view that loads modal display into it...??
    
    
     SeasonPassView = [self.storyboard instantiateViewControllerWithIdentifier:@"seasonPassSB"];
     
    
     
     //dealMaps.parent = self;
     //SET TYPE HERE...
    
    contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
     SeasonPassView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
     [contentView addSubview:SeasonPassView.view];
     
    
        
    
     contentView.bounds = SeasonPassView.view.bounds;

}

-(void) loadPlayerView{
    
    [self removeViews];
    
    
    
    
    //make season pass a view that loads modal display into it...??
    
    
    SeasonPassView = [self.storyboard instantiateViewControllerWithIdentifier:@"sbPlayerNav"];
    
    
    
    //dealMaps.parent = self;
    //SET TYPE HERE...
    
    contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    SeasonPassView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [contentView addSubview:SeasonPassView.view];
    
    
    
    
    contentView.bounds = SeasonPassView.view.bounds;
    
}


-(void) loadResults{
    
    [self removeViews];
    
    
    
    
    //make season pass a view that loads modal display into it...??
    
    
    ResultsView = [self.storyboard instantiateViewControllerWithIdentifier:@"sbTheResults"];
    
    
    
    //dealMaps.parent = self;
    //SET TYPE HERE...
    
    contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    ResultsView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [contentView addSubview:ResultsView.view];
    
    
    
    
    contentView.bounds = ResultsView.view.bounds;
    
}


/*
-(void) loadResults{
    NSString *holder = @"http://www.yahoo.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: holder]];

}
 */


- (IBAction)hiddenMneuButton:(id)sender {
    [self triggerMenuAction];
//    hiddenButton.hidden = true;
    
}





-(void) friendShare{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Tell a Friend" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil  otherButtonTitles:@"FaceBook", @"E-mail",nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
    /*
     filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterView"];
     
     //contentView.frame =CGRectMake(contentView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
     //picksView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     
     [self.view addSubview:filterView.view];
     
     //    contentView.bounds = picksView.view.bounds;
     */
    
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (buttonIndex == 0) {
        [Flurry logEvent:@"Facebook Invite"];
            //FACEBOOK SHARE CODE
        [FBNativeDialogs presentShareDialogModallyFrom:self initialText:@"I am playing in the 2013 MyMock Draft.  Come see if you can beat me." image:nil url:nil handler:^(FBNativeDialogResult result, NSError *error) {
            if(result == FBNativeDialogResultSucceeded)
            {
                
            }
        }];
    }
    else if (buttonIndex == 1) {
        [Flurry logEvent:@"Email Invite"];
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        
        NSString *insertString = @"";
        
        NSString *holder = @"The Fantasy Draft: check it out";
        
//        NSString *tagline =  HELP_EMAIL_SUBJECT;
        
        
        insertString = [insertString stringByAppendingFormat:@"%@ ",holder];
        
        [controller setSubject:insertString];
        
        
        NSMutableArray *addresses = [[NSMutableArray alloc] init];
        NSString *to = @"";
        
        [addresses addObject:to];
        
        
        [controller setToRecipients:addresses];
        
        
       // draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        NSString *bodymessage = [NSString stringWithFormat:@"\n AMI inquiry:  \n ---------------------------\n\n"];
        
        bodymessage = @"Check out Fanrasy Draft at: [app store id needed]!";
       
        
        [controller setMessageBody:bodymessage isHTML:NO];
        
        if (controller){
            
            [self presentViewController:controller animated:YES completion:Nil];
        }
        
        

    }
    
    
        
}

-(void) loadingShow{
    toplayer.hidden = false;
}

-(void) loadingHide{
    toplayer.hidden = true;;

}



- (void)mailComposeController:(MFMailComposeViewController*)controller  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *message=@"";
	if (result == MFMailComposeResultSent)
	{
		message=@"Mail Sent";
	}
	else if(result == MFMailComposeResultCancelled)
	{
		message=@"Sending Canceled";
	}
	else if(result == MFMailComposeResultFailed)
	{
		message=@"Sending Failed";
	}
	
	
	if ([message length]>0)
	{
		UIAlertView *alert2=[[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert2 show];
	}
	
	[self dismissViewControllerAnimated:YES completion:Nil];
    
    
}


-(void) enteredForeground{
    toplayer.hidden = false;
    
    [NSTimer scheduledTimerWithTimeInterval:(float)0.1 target:self selector:@selector(loadServerStuffnow) userInfo:nil repeats:NO];

}




@end
