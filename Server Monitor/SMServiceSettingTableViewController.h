//
//  SMServiceSettingTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMGeneralSettingTableViewController.h"
#import "SMAuxServicesTableViewController.h"

@interface SMServiceSettingTableViewController : UITableViewController 
    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
