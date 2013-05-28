//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                    @"league01",
                                    @"league02",
                                    @"inside",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
    
}

//    [[NSUserDefaults standardUserDefaults] setValue:league01 forKey:@"league01"];
//    [[NSUserDefaults standardUserDefaults] setValue:league02 forKey:@"league02"];
//    [[NSUserDefaults standardUserDefaults] setValue:inside forKey:@"inside"];


@end
