//
//  APIcalls.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "APIcalls.h"
#import "draftAppDelegate.h"
#import "AFNetworking.h"
#import "menucontainerView.h"

@implementation APIcalls


-(void) loadNow{

    //a thread....
    [self getPlayers]; //players and schools and positions are set in this method call
    
}




-(void) checkUserandSetPasses{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"league01"];
    [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"league02"];
    [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"inside"];

    

    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getuserdata?";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }

    
    
    urlAddress = [urlAddress stringByAppendingFormat:@"facebookId=%@",fbuser];
    
    NSLog(@"url: %@",urlAddress);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
	
    
    NSError *e;
    
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    

    NSLog(@"arary: %@",jsonArray);

    NSDictionary *dataset = [[jsonArray objectForKey:@"data"] objectForKey:@"passes"];
    
    //NSLog(@"string:%@",dataset);
    
    for(NSDictionary *item in dataset) {
         NSLog(@"object: %@", item);//[item objectForKey:@"event"]);
       // NSLog(@"data: %@",[item objectForKey:@"League1"]);
        
        
        //each item have to pull reviews....
        //
        
        
    }
  
    //dataset = nil;
    
    
    //was this:
    // "passes":{"League0":0,"League1":0,"League2":0,"Inside":0},
    //now its this:
    // "passes":[{"League0":"1"},{"League1":"1"},{"League2":"1"},{"Inside":"1"}]
    

    if([[dataset objectForKey:@"League1"] integerValue]==1){
      [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"league01"];
    }
    if([[dataset objectForKey:@"League2"] integerValue]==1){
        [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"league02"];
    }

    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];

    if([[dataset objectForKey:@"Inside"] integerValue]==1){
        [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"inside"];
        appDelegate.AllowThisUserToSave = appDelegate.allowSave2;
    }
    

    //get player info and set league status

    //MUST UE STRINGS !!!!!
    // @"ture" or @"false"
    
//    NSString *league01 = @"false";
//    NSString *league02 = @"false";
//    NSString *inside = @"false";
    
//    [[NSUserDefaults standardUserDefaults] setValue:league01 forKey:@"league01"];
//    [[NSUserDefaults standardUserDefaults] setValue:league02 forKey:@"league02"];
//    [[NSUserDefaults standardUserDefaults] setValue:inside forKey:@"inside"];

    
    //this one is always set to true
    [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"league03"];
    
    
    
    //finish process
    
    [appDelegate.menuParent loadingHide];
    
    if(appDelegate.fromBKmode == false){
        [appDelegate.menuParent loadPicks];
    }
    
    appDelegate.fromBKmode = false;
//    [self loadPicks];

}


-(NSArray*) getTeamNeeds: (int) rank{
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *holderData = [appDelegate.playerRanks copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Rank ==  %i)",rank];
    holderData = [holderData filteredArrayUsingPredicate:predicate];
    
    //NSLog(@"data: %@",holderData);
    
    NSMutableDictionary *FinalHolder = [[NSMutableDictionary alloc]init];
    
    for(NSMutableDictionary *obj in holderData){
        
        
        NSArray *holderDataP = [appDelegate.players copy];
        
        
        NSPredicate *predicateP = [NSPredicate predicateWithFormat:@"(Name ==  %@)", [obj objectForKey:@"Name"]];
        
        holderDataP = [holderDataP filteredArrayUsingPredicate:predicateP];
        
        
        //NSLog(@"position: %@",holderDataP);
        
        if([holderDataP count]>0){
            
            
            
            if([FinalHolder objectForKey:[[holderDataP objectAtIndex:0]objectForKey:@"Position"]] == Nil){
                [FinalHolder setObject:[obj objectForKey:@"Percentage"] forKey:[[holderDataP objectAtIndex:0]objectForKey:@"Position"]];
            }
            else{
                float num = [[FinalHolder objectForKey:[[holderDataP objectAtIndex:0]objectForKey:@"Position"]] floatValue];
                
                //NSLog(@"num:%f, %f",num,[[obj objectForKey:@"Percentage"] floatValue]);
                
                num = num + [[obj objectForKey:@"Percentage"] floatValue];
                
                [FinalHolder removeObjectForKey:[[holderDataP objectAtIndex:0]objectForKey:@"Position"]];
                
                NSString *theValue = [NSString stringWithFormat:@"%02.2f",num];
                
                [FinalHolder setObject:theValue forKey:[[holderDataP objectAtIndex:0]objectForKey:@"Position"]];
                
                
            }
            
        }
        
        
        
        /*
         NSEnumerator *enumerator = [myDictionary keyEnumerator];
         id key;
         
         while ((key = [enumerator nextObject])) {
         NSLog(@"Do something with the key here:%@",key);
         }
         */
        
        //NSLog(@"%@",FinalHolder);
        
        //Position
        //Percentage
        
    }
    
    NSMutableArray *FinalArray = [[NSMutableArray alloc]init];
    
    for(NSMutableDictionary *obj in FinalHolder){
        
        NSMutableDictionary *tempF = [[NSMutableDictionary alloc]init];
        
        
        [tempF setObject:obj forKey:@"spot"];
        [tempF setObject:[FinalHolder objectForKey:obj] forKey:@"percent"];
        
        //NSLog(@"obj: %@",tempF);
        [FinalArray addObject:tempF];
        
    }
    
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"percent" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *FinalSortedArary;
    FinalSortedArary = [FinalArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    //NSLog(@"final: %@",FinalSortedArary);
    
    return FinalSortedArary;
}

-(void) getPlayers{
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getplayerlist";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];

	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
//                                            NSLog(@"json: %@",JSON);
                                             [self completeGetPlayer:JSON];
                                         }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) { 
                                        }];
    


    [operation start];

}

-(void) completeGetPlayer :(id) JSON{
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    

    NSMutableArray *dataset = [JSON objectForKey:@"data"];
    
    appDelegate.players = dataset;

//    NSLog(@"player: %@",appDelegate.players);
    
    appDelegate.schools =  [[NSMutableArray alloc]init];
    for(NSDictionary *object in appDelegate.players){
        NSString *temp = [object objectForKey:@"School"];
        [appDelegate.schools addObject:   [NSString stringWithFormat:@"%@",[temp stringByReplacingOccurrencesOfString:@"\"" withString:@""]]];
        //[NSString stringWithFormat:@"%@",[object objectForKey:@"School"]]];
    }
    
    appDelegate.schools = [appDelegate.schools valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    NSArray *sortedArray = [appDelegate.schools sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    appDelegate.schools =  [[NSMutableArray alloc]init];
    [appDelegate.schools addObjectsFromArray:sortedArray];
    
    

    
    appDelegate.positions =  [[NSMutableArray alloc]init];
    for(NSDictionary *object in appDelegate.players){
        NSString *temp = [object objectForKey:@"Position"];
        [appDelegate.positions addObject:   [NSString stringWithFormat:@"%@",[temp stringByReplacingOccurrencesOfString:@"\"" withString:@""]]];

    }
    
    appDelegate.positions = [appDelegate.positions valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    sortedArray = [appDelegate.positions sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    appDelegate.positions =  [[NSMutableArray alloc]init];
    [appDelegate.positions addObjectsFromArray:sortedArray];
    
    
    //now we can start get ranks
    [self getPlayerRanks];
}



-(void) getPlayerRanks{
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getplayerrankings";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             //                                            NSLog(@"json: %@",JSON);
                                             [self completeGetPlayerRanks:JSON];
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        }];
    
    
    
    [operation start];


}

-(void) completeGetPlayerRanks :(id) JSON{
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSMutableArray *dataset = [JSON objectForKey:@"data"];
    
    appDelegate.playerRanks = dataset;
    
    
//    NSLog(@"player Ranks %@",appDelegate.playerRanks);
    
    
    //now we can start get settings;
    
    [self getDrafts];

}





-(void) getSettigns{
    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getsettings";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             //                                            NSLog(@"json: %@",JSON);
                                             [self completeGetSettings:JSON];
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        }];
    
    
    
    [operation start];
    
}


-(void) completeGetSettings :(id) JSON{
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSMutableArray *dataset = [JSON objectForKey:@"data"];
    
    
    NSLog(@"data set: %@",[dataset objectAtIndex:0]);
    
    

    
    NSMutableDictionary* holder =  [dataset objectAtIndex:0];

    appDelegate.allowSave1 = [[holder objectForKey:@"AllowSaves1"] integerValue];//AllowSaves1//AllowSaves1
    appDelegate.allowSave2 = [[holder objectForKey:@"AllowSaves2"] integerValue];
    
    appDelegate.AllowThisUserToSave = appDelegate.allowSave1;
    
    
    NSLog(@"allow saves: %i, %i",appDelegate.allowSave1, appDelegate.allowSave2);
    
    
    appDelegate.teamPickOrder = [[NSMutableArray alloc]init];
    appDelegate.leagues = [[NSMutableArray alloc]init];
    
    appDelegate.teamPickOrder = [holder objectForKey:@"TeamPickOrder"];
    
    
    appDelegate.insideInfo = [[NSMutableDictionary alloc]init];
    
    appDelegate.insideInfo = [holder objectForKey:@"InsideInfo"];
    
    
    
    //Make Needs for each Round Pick
    NSMutableArray *RoundNeeds = [[NSMutableArray alloc] init];
    
    
    
    int x = 1;
    while(x < 33){
        
        [RoundNeeds addObject:[self getTeamNeeds:x]];
        x++;
    }
    
    
    
    for(NSMutableDictionary *item in [holder objectForKey:@"Leagues"]) {
        //NSLog(@"object: %@", item);//[item objectForKey:@"event"]);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict = [NSMutableDictionary dictionary];
        [dict setObject:item forKey:@"data"];
        
        //int round = [item objectForKey:@"Rounds"];
        
        NSMutableArray *pickTemp =[[NSMutableArray alloc] initWithCapacity:32];
        
        int x = 0;
        while(x < 32){
            NSMutableDictionary *dictTEMP = [NSMutableDictionary dictionary];
            
            dictTEMP = [NSMutableDictionary dictionary];
            [dictTEMP setObject:@"" forKey:@"Name"];
            [dictTEMP setObject:@"" forKey:@"Position"];
            [dictTEMP setObject:@"" forKey:@"School"];
            [dictTEMP setObject:@"" forKey:@"id"];
            
            [pickTemp addObject:dictTEMP];
            
            x++;
        }
        
        
        
        
        NSMutableArray *draftPickHolderTemp =  draftObjectHolder;
        
        
        //NSLog(@"draftPickHolderTemp: %@",draftPickHolderTemp);
        
        
        BOOL leagueset = false;
        for (NSMutableDictionary *object in draftPickHolderTemp){
            
            //NSLog(@" %@, %@",[item objectForKey:@"LeagueId"],[object objectForKey:@"League"]);
            
            if([[item objectForKey:@"LeagueId"] integerValue] == [[object objectForKey:@"League"] integerValue]){
                leagueset = true;
                
                //date
                
                pickTemp =[[NSMutableArray alloc] initWithCapacity:32];
                
                for(NSMutableDictionary *objectPICKS in [object objectForKey:@"Picks"] ){
                    
                    NSArray *holderData = [appDelegate.players copy];
                    
                    
                    //NSLog(@" %@, %@",  objectPICKS, [[appDelegate.players objectAtIndex:0] objectForKey:@"_id"]);
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(_id ==  %@)",[objectPICKS objectForKey:@"PlayerId" ] ];
                    
                    holderData = [holderData filteredArrayUsingPredicate:predicate];
                    
                    if([holderData count] > 0){
                        
                        NSMutableDictionary *dictTEMP = [NSMutableDictionary dictionary];
                        dictTEMP = [NSMutableDictionary dictionary];
                        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"Name"] forKey:@"Name"];
                        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"Position"] forKey:@"Position"];
                        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"School"] forKey:@"School"];
                        [dictTEMP setObject:[[holderData objectAtIndex:0] objectForKey:@"_id"] forKey:@"id"];
                        
                        [pickTemp addObject:dictTEMP];
                        
                        
                        
                    }
                    else{
                        NSMutableDictionary *dictTEMP = [NSMutableDictionary dictionary];
                        
                        dictTEMP = [NSMutableDictionary dictionary];
                        [dictTEMP setObject:@"" forKey:@"Name"];
                        [dictTEMP setObject:@"" forKey:@"Position"];
                        [dictTEMP setObject:@"" forKey:@"School"];
                        [dictTEMP setObject:@"" forKey:@"id"];
                        
                        [pickTemp addObject:dictTEMP];
                        
                    }
                    
                }
                
                
                [dict setObject:appDelegate.teamPickOrder forKey:@"rounds"];
                [dict setObject:RoundNeeds forKey:@"roundsneeds"];
                [dict setObject:pickTemp forKey:@"picks"];
                
                
                
                
                
                
            }
        }
        
        
        
        [appDelegate.leagues addObject:dict];
        
        
        dict = [NSMutableDictionary dictionary];
    }
    
    
    NSLog(@"Leagues: %@",appDelegate.leagues);
    
    
    //////// DO NOT RUN [self setDraftsTest];
    
    [self checkUserandSetPasses];

}





-(void) setDrafts{
    
    
    //[{%22League0%22:0,%22League1%22:0,%22League2%22:0,%22Inside%22:1}]
    
    
    NSMutableArray *pickTemp =[[NSMutableArray alloc] initWithCapacity:32];

    NSMutableDictionary * dictTEMP;
    
    dictTEMP = [NSMutableDictionary dictionary];
    [dictTEMP setObject:@"1" forKey:@"League0"];
    [pickTemp addObject:dictTEMP];
    
   // dictTEMP = [NSMutableDictionary dictionary];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"league01"] isEqualToString:@"true"]){
        [dictTEMP setObject:@"1" forKey:@"League1"];
    }
    else{
        [dictTEMP setObject:@"0" forKey:@"League1"];
    }
   // [pickTemp addObject:dictTEMP];
    
    //dictTEMP = [NSMutableDictionary dictionary];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"league02"] isEqualToString:@"true"]){
        [dictTEMP setObject:@"1" forKey:@"League2"];
    }
    else{
        [dictTEMP setObject:@"0" forKey:@"League2"];
    }
   // [pickTemp addObject:dictTEMP];
    
    
    //dictTEMP = [NSMutableDictionary dictionary];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"league03"] isEqualToString:@"true"]){
        [dictTEMP setObject:@"1" forKey:@"Inside"];
    }
    else{
        [dictTEMP setObject:@"0" forKey:@"Inside"];
    }
    //[pickTemp addObject:dictTEMP];
    

    
    
    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/updateuserpurchases";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }

    
    
    NSError *e2;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dictTEMP options:0 error:&e2];
    
    NSString *content = @"";
    
    NSString *holderSt = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    holderSt = [holderSt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    content = [content stringByAppendingFormat:@"userid=%@&passes=%@",fbuser, holderSt];
    
    
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?%@",content];
    
    NSLog(@"url: %@",urlAddress);

    
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
	
    
    NSError *e;
    
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    
    NSMutableArray *dataset = [jsonArray objectForKey:@"data"];
    
    //NSLog(@"string:%@",dataset);
    
    for(NSDictionary *item in dataset) {
        // NSLog(@"object: %@", item);//[item objectForKey:@"event"]);
        
        
        //each item have to pull reviews....
        //
        
        
    }
    
    //dataset = nil;
    
    
    
    
}


-(void) setDraftsTest{
    
    
    //[{%22League0%22:0,%22League1%22:0,%22League2%22:0,%22Inside%22:1}]
    
    
    NSMutableArray *pickTemp =[[NSMutableArray alloc] initWithCapacity:32];
    
    NSMutableDictionary * dictTEMP;
    
    dictTEMP = [NSMutableDictionary dictionary];
    [dictTEMP setObject:@"1" forKey:@"League0"];
//    [pickTemp addObject:dictTEMP];
    
   // dictTEMP = [NSMutableDictionary dictionary];
        [dictTEMP setObject:@"0" forKey:@"League1"];
//    [pickTemp addObject:dictTEMP];
    
    //dictTEMP = [NSMutableDictionary dictionary];
        [dictTEMP setObject:@"0" forKey:@"League2"];
//    [pickTemp addObject:dictTEMP];
    
    
    //dictTEMP = [NSMutableDictionary dictionary];
        [dictTEMP setObject:@"0" forKey:@"Inside"];
///    [pickTemp addObject:dictTEMP];
    
    
    
    
    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/updateuserpurchases";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    
    
    
    NSError *e2;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dictTEMP options:0 error:&e2];
    
    NSString *content = @"";
    
    NSString *holderSt = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    holderSt = [holderSt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    content = [content stringByAppendingFormat:@"userid=%@&passes=%@",fbuser, holderSt];
    
    
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?%@",content];
    
    NSLog(@"url: %@",urlAddress);
    
    
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
	
    
    NSError *e;
    
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    
    NSMutableArray *dataset = [jsonArray objectForKey:@"data"];
    
    //NSLog(@"string:%@",dataset);
    
    for(NSDictionary *item in dataset) {
        // NSLog(@"object: %@", item);//[item objectForKey:@"event"]);
        
        
        //each item have to pull reviews....
        //
        
        
    }
    
    //dataset = nil;
    
    
    
    
}


-(void) getDrafts{
    
    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/getmockdrafts";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?FacebookId=%@",fbuser];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             //                                            NSLog(@"json: %@",JSON);
                                             [self completeGetDraftsComplete:JSON];
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        }];
    
    
    
    [operation start];
    
    
}

-(void) completeGetDraftsComplete :(id) JSON{
    
    draftAppDelegate *appDelegate = (draftAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSMutableArray *dataset = [JSON objectForKey:@"data"];
    
    draftObjectHolder = dataset;
    
    
    //    NSLog(@"player Ranks %@",appDelegate.playerRanks);
    
    
    //now we can start get settings;
    
    [self getSettigns];
    
}



-(void) postDrtaft :(NSString *)draftID :(NSMutableArray*)picks{
    
    
    
    NSString* urlAddress =@"http://draft.aws.af.cm/api/savemockdraft";
    
    NSString *fbuser = @"";
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"]){
        fbuser = [[NSUserDefaults standardUserDefaults] valueForKey:@"fbuser"];
    }
    
    
    NSError *e;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:picks options:0 error:&e];

    /*
    NSString *rawText = @"One Broadway, Cambridge, MA";
    
    NSString *encodedText = [rawText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Encoded text: %@", encodedText);
    NSString *decodedText = [encodedText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Original text: %@", decodedText);
    */
    
    NSString *content = @"";
    
    NSString *holderSt = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    holderSt = [holderSt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    content = [content stringByAppendingFormat:@"userid=%@&league=%@&picks=%@",fbuser,draftID, holderSt];
    
    
    
    urlAddress = [urlAddress stringByAppendingFormat:@"?%@",content];
    
    //NSLog(@"url: %@",urlAddress);
    
	
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlAddress]];
    
	NSData *connect = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
	
    
    NSError *e2;
    
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e2];
    

//NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:connect options:NSJSONWritingPrettyPrinted error:&e];
    
   // NSMutableArray *dataset = [jsonArray objectForKey:@"data"];
    
    //NSLog(@"string:%@",jsonArray);

    

    
    
    
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setURL:[NSURL URLWithString:urlAddress]];
    //NSLog(@"url: %@",urlAddress);
    

    
}
@end
