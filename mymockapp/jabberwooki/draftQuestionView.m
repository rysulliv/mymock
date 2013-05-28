//
//  draftQuestionView.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/8/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftQuestionView.h"

@interface draftQuestionView ()

@end

@implementation draftQuestionView


@synthesize answerOptions;
@synthesize processingAction;
@synthesize questionText;
@synthesize answerPicker;
@synthesize answerButton;

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
    processingAction.hidden = true;
    [self getQuestion];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionAnswerNow:(id)sender {
    answerOptions.hidden = false;
}

- (IBAction)selectedAction:(id)sender {
    [self answerQuestion];
    
   
}

-(void) postaction{
    
    //this should trigger if server responds ... if not just alert user so they don't feel like they were cheated a move up in postion
    
        processingAction.hidden = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getQuestion{
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getquestion";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?facebookId=%@",fbuser];
    
    
    //NSLog(@"url: %@",urlAddress);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAddress]];
    
    NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSError *e;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    
    
    //FOR TESTING
    NSLog(@"string:%@",jsonArray);
    
    NSMutableDictionary* holderResult = [jsonArray objectForKey:@"data"]; //2
    
    question_text = [holderResult objectForKey:@"text"];
    pickerAnswers = [holderResult objectForKey:@"answers"];
    NSString *status = [jsonArray objectForKey:@"status"];
    if([status isEqualToString:@"noquestion"])
    {
        //there are no more questions for we need to tell them that
        answerButton.hidden = true;
        [questionText setText:@"No More questions to answer right now.  Check back again tomorrow for more chances to move up in line!"];
    }
    else{
        answerButton.hidden = false;
        [questionText setText:question_text];
        
        answer_text = [pickerAnswers objectAtIndex:0];
    }
    

}

-(void) answerQuestion{
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/answerquestion";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?question=%@&answer=%@&facebookId=%@",question_text,answer_text,fbuser];
    urlAddress = [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAddress]];
    
    NSLog(@"url: %@",urlAddress);
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setURL:[NSURL URLWithString:urlAddress]];
    //NSLog(@"url: %@",urlAddress);
    //NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    //NSError *e;

    
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
    NSLog(@"string:%@",jsonArray);
    
    answerOptions.hidden = true;
    
    processingAction.hidden = false;
    
    
    //change to 0.1 once live
    [NSTimer scheduledTimerWithTimeInterval:3.1 target:self selector:@selector(postaction) userInfo:nil repeats:NO];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if(component==0){
        return [pickerAnswers count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component==0){
        return [pickerAnswers objectAtIndex:row];
    }
    
    return 0;
	
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    answer_text = [pickerAnswers objectAtIndex:row];
}






- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
@end
