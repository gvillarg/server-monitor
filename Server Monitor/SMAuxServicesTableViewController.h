//
//  SMAuxServicesTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SMServiceSettingTableViewController.h"
#import "SMAddAuxServiceViewController.h"

@interface SMAuxServicesTableViewController : UITableViewController<SMAddAuxServiceViewControllerDelegate, NSFetchedResultsControllerDelegate>
    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
