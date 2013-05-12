//
//  customCell.m
//  weather
//
//  Created by Adam Hayek on 5/11/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "customCell.h"

@implementation customCell

@synthesize locationLabel = _locationLabel;

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

@end
