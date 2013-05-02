//
//  customCell.h
//  weather
//
//  Created by Adam Hayek on 4/5/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
