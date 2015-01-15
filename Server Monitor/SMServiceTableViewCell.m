//
//  SMServiceTableViewCell.m
//  Server Monitor
//
//  Created by Cesar on 25/08/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMServiceTableViewCell.h"

@interface SMServiceTableViewCell()

@property (nonatomic, strong) UIImageView *statusService;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *overviewLabel;

- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;

@end

@implementation SMServiceTableViewCell

- (void)layoutSubviews {
    
    [super layoutSubviews];
	
    [self.statusService setFrame:[self _imageViewFrame]];
    [self.nameLabel setFrame:[self _nameLabelFrame]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
	if (self = [super initWithCoder:aDecoder]) {
        _statusService = [[UIImageView alloc] initWithFrame:CGRectZero];
		self.statusService.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.statusService];
        
        _overviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.overviewLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.overviewLabel setTextColor:[UIColor darkGrayColor]];
        [self.overviewLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.overviewLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //[self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self.nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.nameLabel];
    }
    
    return self;
}

#define IMAGE_SIZE          40.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

// returns the frame of the various subviews -- these are dependent on the editing state of the cell
- (CGRect)_imageViewFrame {
    
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 32.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 32.0);
    }
}

#pragma mark - Recipe set accessor

- (void)setService:(SMOService *)newService {
    if (_service != NULL) {
        if (newService != _service) {
            _service = newService;
        }
    }else{
            _service = newService;
    }
    if ([_service.active boolValue]) {
        self.statusService.image = [UIImage imageNamed:@"on"];
    }else{
        self.statusService.image = [UIImage imageNamed:@"off"];
    }
	self.nameLabel.text = (_service.name.length > 0) ? _service.name : @"-";
}

@end
