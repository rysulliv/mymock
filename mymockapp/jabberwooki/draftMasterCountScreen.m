//
//  draftMasterCountScreen.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/7/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftMasterCountScreen.h"
#import "UAPush.h"
#import "UAirship.h"
#import "draftQuestionView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface draftMasterCountScreen ()

@end

@implementation draftMasterCountScreen

@synthesize timerLabel;
@synthesize inFrontPeople;
@synthesize totalPeople;
@synthesize newsFeed;

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
    isCounting = true;
    isFirstLoad = true;
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    // Register for remote notfications with the UA Library. This call is required.
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];

    
    //placeholder for html news feed
    NSURL *url = [NSURL URLWithString:@"http://draft.aws.af.cm/"];
    [newsFeed loadRequest:[NSURLRequest requestWithURL:url]];
    
    tempinFrontofMe = 0;
    tempCountPeople = 0;
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"infrontofme"]){
        tempinFrontofMe = [[[NSUserDefaults standardUserDefaults] valueForKey:@"infrontofme"] integerValue];
        tempCountPeople = [[[NSUserDefaults standardUserDefaults] valueForKey:@"thetotalusers"] integerValue];;
        infrontofme = tempinFrontofMe;
        totalcountpeople =infrontofme;

//        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }

    
    NSLog(@"totals: %i",tempinFrontofMe);
    
    [super viewDidLoad];
    
    [self timeToLaunch];
    
    [self getPeopleinFront];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(adjustTotalsNowWithAnimation) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getPeopleinFront) userInfo:nil repeats:YES];

	// Do any additional setup after loading the view.
    
    
}
-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(notSCreenFirstShow == true){
        NSLog(@"here in not first show");
        [self getPeopleinFront];
    }else{
        notSCreenFirstShow = true;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateTimer{
    
    
    //86400 > 1
    remainseconds --;
    
    timerLabel.text = [self timeFormatted:remainseconds];
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //int hours = totalSeconds / 3600;
    int hours = (totalSeconds / 3600) % 24;
    int days = totalSeconds / 86400;
    
    NSString *head = @"";
    
    if(timerflag==1){
        head = @"roughly ";
    }
    
    if(days < 1){
        return [NSString stringWithFormat:@"%@ %02d:%02d:%02d", head,hours, minutes, seconds];
    }

    return [NSString stringWithFormat:@"%@ %02d days %02d:%02d:%02d",head, days, hours, minutes, seconds];

}

-(void) timeToLaunch{
        
    NSString* urlAddress =@"http://draft.aws.af.cm/api/gettimetilllaunch";
    
//    urlAddress = [urlAddress stringByAppendingFormat:@"%i?api_key=%@&user_id=%@",chzid,api_key,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    //-//NSLog(@"url: %@",urlAddress);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAddress]];
    
    NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSError *e;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    
    
    //FOR TESTING
    //NSLog(@"string:%@",jsonArray);
    
    
    NSMutableDictionary* holderResult = [jsonArray objectForKey:@"data"]; //2
    
    timerflag = [[holderResult objectForKey:@"flag"] integerValue];
    remainseconds = [[holderResult objectForKey:@"seconds"] integerValue];
    

    
    
    //start refresh timer
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    //NSLog(@"string:%@",holderResult);
    
//    NSMutableArray *dataset = [[jsonArray objectForKey:@"results"] objectForKey:@"locations"];
    
    
//    for(NSDictionary *item in dataset){
        
        
//    }
    
    
   // return dataset;
    

}

-(void) adjustTotalsNowWithAnimation{
    //tempinFrontofMe = 0;
    //tempCountPeople = 0;
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
//    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:2000000]];
    
    if(isCounting==false) return;
    
    
    int speed = 1;

    if(tempinFrontofMe > infrontofme){
        tempinFrontofMe = infrontofme;
    }
    
    if(tempinFrontofMe != infrontofme || tempinFrontofMe==0){
        if((infrontofme-tempinFrontofMe) > 100){
            speed = 12;
        }
        if((infrontofme-tempinFrontofMe) > 1000){
            speed = 123;
        }
        if((infrontofme-tempinFrontofMe) > 10000){
            speed = 1234;
        }
       
        tempinFrontofMe = tempinFrontofMe + speed;
        
        inFrontPeople.text = [formatter stringFromNumber:[NSNumber numberWithInteger:tempinFrontofMe]];//[NSString stringWithFormat:@"%i",tempinFrontofMe];
    }
    if(tempinFrontofMe == infrontofme && tempinFrontofMe!=0){
        inFrontPeople.text = [formatter stringFromNumber:[NSNumber numberWithInteger:tempinFrontofMe]];
    }
    
    
    speed = 1;
    
    if(tempCountPeople > totalcountpeople){
        tempCountPeople = totalcountpeople;
    }
    
    if(tempCountPeople != totalcountpeople || tempCountPeople==0){
        if((totalcountpeople-tempCountPeople) > 100){
            speed = 12;
        }
        if((totalcountpeople-tempCountPeople) > 1000){
            speed = 123;
        }
        if((totalcountpeople-tempCountPeople) > 10000){
            speed = 1234;
        }
        
        tempCountPeople = tempCountPeople + speed;
        
        totalPeople.text = [formatter stringFromNumber:[NSNumber numberWithInteger:tempCountPeople]];//[NSString stringWithFormat:@"%i",tempCountPeople];
    }
    
    if(tempCountPeople == totalcountpeople && tempCountPeople!=0){
        totalPeople.text = [formatter stringFromNumber:[NSNumber numberWithInteger:tempCountPeople]];
        
    }
    else{
        
    }
    if(tempCountPeople == totalcountpeople && tempinFrontofMe == infrontofme && tempCountPeople!=0 && tempinFrontofMe!=0){
        isCounting=false;
    }
    
}


-(void) getPeopleinFront{
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getspotinline";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }


    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d hh:mm" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    //NSLog(@"Formatted date: %@", [formatter stringFromDate: [NSDate date]]);
    
    //urlAddress = [urlAddress stringByAppendingFormat:@"?facebookId=%@&t='%@'",fbuser,[formatter stringFromDate: [NSDate date]]];
    urlAddress = [urlAddress stringByAppendingFormat:@"?facebookId=%@&t=%f",fbuser,[[NSDate date]timeIntervalSince1970]];

    
    //NSLog(@"url: %@",urlAddress);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAddress]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
    
    
//    inFrontPeople.text = [NSString stringWithFormat:@"%i",infrontofme];
//    totalPeople.text = [NSString stringWithFormat:@"%i",totalcountpeople];
    
    
    //start refresh timer
    
    //NSLog(@"string:%@",holderResult);
    
    //    NSMutableArray *dataset = [[jsonArray objectForKey:@"results"] objectForKey:@"locations"];
    
    
    //    for(NSDictionary *item in dataset){
    
    
    //    }
    
    
    // return dataset;
    
    
}
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _data = [[NSMutableData alloc] init]; // _data being an ivar
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [_data appendData:data];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // Handle the error properly
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
     NSError *e;
     NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONWritingPrettyPrinted error:&e];
    
    
    //FOR TESTING
    //NSLog(@"string:%@",jsonArray);
    
    NSLog(@"Full: %@",jsonArray);
    NSMutableDictionary* holderResult = [jsonArray objectForKey:@"data"]; //2
    
    if([[jsonArray objectForKey:@"method"] isEqualToString:@"getSpotInLine"])
    {
        infrontofme = [[holderResult objectForKey:@"infront"] integerValue];
        totalcountpeople = [[holderResult objectForKey:@"total"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:[holderResult objectForKey:@"infront"] forKey:@"infrontofme"];
        [[NSUserDefaults standardUserDefaults] setValue:[holderResult objectForKey:@"total"] forKey:@"thetotalusers"];
        isCounting=true;
        if(isFirstLoad == true)
        {
            if(totalcountpeople<=0)
            {
                [self getPeopleinFront];
            }
            else{
                isCounting=true;
                isFirstLoad = false;
            }
        }
    }
    else
    {
         [self getPeopleinFront];
    }
}
- (IBAction)moveUpPress:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Answer a question" otherButtonTitles:@"Share on Facebook", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        draftQuestionView *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbDraftQuestions"];
        
        
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:controller animated:YES completion:nil];

        
        
    } else if (buttonIndex == 1) {
        [FBNativeDialogs presentShareDialogModallyFrom:self initialText:@"I am signed up for a chance to play in the 2013 Fantasy Draft iOS App!  Check it out in the app store." image:nil url:nil handler:^(FBNativeDialogResult result, NSError *error) {
            if(result == FBNativeDialogResultSucceeded)
            {
                NSLog(@"Successully shared");
                //update place in line
                
                NSString* urlAddress =@"http://draft.aws.af.cm/api/invitefriend";
                
                NSString *fbuser = @"";
                
                if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
                    fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
                }
                
                
                
                urlAddress = [urlAddress stringByAppendingFormat:@"?facebookId=%@&t=%f",fbuser,[[NSDate date]timeIntervalSince1970]];
                
                
                //NSLog(@"url: %@",urlAddress);
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:urlAddress]];
                
                NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            NSLog(@"Dialog Error= %@",error);
        }];

    } else if (buttonIndex == 2) {
        //NSString* launchUrl = @"http://www.kickstarter.com";
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
       
	} else if (buttonIndex == 3) {
        
	}
    
	/**
	 * OR use the following switch statement
	 * Suggested by Colin =)
	 */
	/*
     switch (buttonIndex) {
     case 0:
     self.label.text = @"Destructive Button Clicked";
     break;
     case 1:
     self.label.text = @"Other Button 1 Clicked";
     break;
     case 2:
     self.label.text = @"Other Button 2 Clicked";
     break;
     case 3:
     self.label.text = @"Cancel Button Clicked";
     break;
     }
     */
}

@end
