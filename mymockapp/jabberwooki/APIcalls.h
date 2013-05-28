//
//  APIcalls.h
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIcalls : NSObject{
    
    NSMutableArray *draftObjectHolder;
}


-(void) loadNow;

-(void) postDrtaft :(NSString *)draftID :(NSMutableArray*)picks;

-(void) setDrafts;


@end
