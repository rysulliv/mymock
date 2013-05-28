//
//  draftViewController.m
//  jabberwooki
//
//  Created by Dev on 2/7/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "draftViewController.h"

@interface draftViewController ()

@end

@implementation draftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
