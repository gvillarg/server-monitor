//
//  SMContentTableViewCell.h
//  Server Monitor
//
//  Created by Gustavo Villar on 1/17/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
