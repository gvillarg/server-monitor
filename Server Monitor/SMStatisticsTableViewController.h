//
//  SMStatisticsTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMEditServiceController.h"
#import "SMAddServiceViewController.h"
#import "SMAppDelegate.h"


@interface SMStatisticsTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
