//
//  SMGeneralSettingTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "SMServiceSettingTableViewController.h"
#import "SMSoundAlertsTableViewController.h"

@interface SMGeneralSettingTableViewController : UITableViewController <SMSoundAlertsDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end