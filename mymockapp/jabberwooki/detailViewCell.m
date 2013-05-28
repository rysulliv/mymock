//
//  detailViewCell.m
//  jabberwooki
//
//  Created by Ryan Sullivan on 3/1/13.
//  Copyright (c) 2013 jabberwooki. All rights reserved.
//

#import "detailViewCell.h"

@implementation detailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setupCell:(NSDictionary*)object :(int) row{
    title.text = [object objectForKey:@"Name"];
    description.text = [object objectForKey:@"Description"];
    
    rankPlaceNumber.text = [NSString stringWithFormat:@"%i",row+1];
    
    if(row < [[object objectForKey:@"Prizes"] count]){
        rankTitle.text = [[[object objectForKey:@"Prizes"] objectAtIndex:row ] objectForKey:@"Title"];
        rankDescription.text = [[[object objectForKey:@"Prizes"] objectAtIndex:row ] objectForKey:@"Description"];;
    }
    
    //title.text = @"1";
    
    officialRules.text =  [object objectForKey:@"Rules"];
    
    price.text =[object objectForKey:@"Price"];
    
   // officialRules.text = @"22";
}

-(void) setupCell2:(NSDictionary*)object :(int) row{
    title.text = [object objectForKey:@"Title"];
    description.text = [object objectForKey:@"Description"];
    
    rankPlaceNumber.text = [NSString stringWithFormat:@"%i",row+1];
    
    if(row < [[object objectForKey:@"Perks"] count]){
        rankTitle.text = [[[object objectForKey:@"Perks"] objectAtIndex:row ] objectForKey:@"Title"];
        rankDescription.text = [[[object objectForKey:@"Perks"] objectAtIndex:row ] objectForKey:@"Description"];;
    }
    
    //title.text = @"1";
    
    officialRules.text =  [object objectForKey:@"Rules"];
    
    price.text =[object objectForKey:@"Price"];
    // officialRules.text = @"22";
}

@end
