//
//  SMServicesTableTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 8/23/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMEditServiceController.h"
#import "SMAddServiceViewController.h"
#import "SMReviewCenter.h"

@interface SMServicesTableViewController : UITableViewController<SMAddServiceDelegate, SMEditServiceControllerDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) SMReviewCenter *reviewCenter;

@end
