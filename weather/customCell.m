//
//  customCell.m
//  weather
//
//  Created by Adam Hayek on 4/5/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "customCell.h"

@implementation customCell

@synthesize tempLabel = _nameLabel;
@synthesize descLabel = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

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
