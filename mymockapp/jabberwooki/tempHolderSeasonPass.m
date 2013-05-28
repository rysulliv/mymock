//
//  tempHolderSeasonPass.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 2/25/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "tempHolderSeasonPass.h"

@interface tempHolderSeasonPass ()

@end

@implementation tempHolderSeasonPass

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
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"seasonPassSB"];
    
    //    [self addChildViewController:controller];
    [self.view addSubview:controller.view];

	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated{
    
    
    
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
