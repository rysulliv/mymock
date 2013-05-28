//
//  draftLoginController.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/8/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftLoginController.h"
#import "draftMasterCountScreen.h"
#import "draftAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface draftLoginController ()

@end

@implementation draftLoginController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fbLogin:(id)sender {
    
    
     draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
     
     // this button's job is to flip-flop the session from open to closed
     if (appDelegate.session.isOpen) {
     // if a user logs out explicitly, we delete any cached token information, and next
     // time they run the applicaiton they will be presented with log in UX again; most
     // users will simply close the app or switch away, without logging out; this will
     // cause the implicit cached-token login to occur on next launch of the application
     [appDelegate.session closeAndClearTokenInformation];
     
     } else {
     
     NSArray *permissions = [NSArray arrayWithObjects:@"email", @"user_location",@"user_hometown",@"user_birthday", nil];
     appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
     // if the session isn't open, let's open it now and present the login UX to the user
     [appDelegate.session openWithCompletionHandler:^(FBSession *session,
     FBSessionState status,
     NSError *error) {
     
                  
         NSString *photosQuery = @"SELECT uid,name,birthday,current_address,first_name,last_name,current_location,timezone,email,age_range,devices FROM user WHERE uid=me()";
         // Set up the query parameter
         NSDictionary *photosQueryParam =
         [NSDictionary dictionaryWithObjectsAndKeys:photosQuery, @"q", nil];
         
         [[[FBRequest alloc]initWithSession:appDelegate.session graphPath:@"/fql" parameters:photosQueryParam HTTPMethod:@"GET"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (error) {
                 NSLog(@"Error: %@", [error localizedDescription]);
             } else {
                 //NSLog(@"Result: %@", result);
                 NSMutableArray *resultArray = [result objectForKey:@"data"];
                 for(NSDictionary *test in resultArray){
                     NSString *uid = [test objectForKey:@"uid"];
                     NSString *firstName = [test objectForKey:@"first_name"];
                     NSString *lastName = [test objectForKey:@"last_name"];
                     NSString *name = [test objectForKey:@"name"];
                     NSString *email = [test objectForKey:@"email"];
                     NSString *birthday = [test objectForKey:@"birthday"];
                     NSString *address = [test objectForKey:@"current_address"];
                     NSString *location = [test objectForKey:@"current_location"];
                     NSString *timezone = [test objectForKey:@"timezone"];
                     NSMutableString *devices = [[NSMutableString alloc]init];
                     for(NSDictionary *devicesArray in [test objectForKey:@"devices"])
                     {
                         [devices appendFormat:@"%@ - %@ |",[devicesArray objectForKey:@"os"],[devicesArray objectForKey:@"hardware"]];
                     }
                     
                     
                    [[NSUserDefaults standardUserDefaults] setValue:[test objectForKey:@"uid"] forKey:@"fbuser"];
                     
                     NSString *content = @"";
                     content = [content stringByAppendingFormat:@"email=%@&firstname=%@&lastname=%@&name=%@&birthday=%@&location=%@&timezone=%@&devices=%@&id=%@",email,firstName,lastName,name,birthday,location,timezone,devices,uid];
                     
                     NSLog(@"content: %@",content);
                     
                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://draft.aws.af.cm/api/createuser"]];
                     [request setHTTPMethod:@"POST"];
                     [request setHTTPBody:[content dataUsingEncoding:NSISOLatin1StringEncoding]];
                     [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
                     
                    
                 }
                 
                 
                 //if successful
                 draftMasterCountScreen *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"sbMenu"];////sbMainDraft
                 
                 [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                 
                 [self presentViewController:controller animated:YES completion:Nil];

                 
                 /*
                  //process members
                  NSOperationQueue *queue = [NSOperationQueue new];
                  NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                  initWithTarget:self
                  selector:@selector(threadMembersAction)
                  object:nil];
                  [queue addOperation:operation];
                  */
                 
             }
           
         }];

     }];
     }
    
    
}
@end
