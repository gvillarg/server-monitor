//
//  SMContentTableViewController.h
//  Server Monitor
//
//  Created by Gustavo Villar on 1/17/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOServiceAvailability.h"

@interface SMContentTableViewController : UITableViewController

@property (strong, nonatomic) SMOServiceAvailability *availability;

@end
