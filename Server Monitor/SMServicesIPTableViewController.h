//
//  SMServicesIPTableViewController.h
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOService.h"
#import "SMOServiceAccess.h"

@interface SMServicesIPTableViewController : UITableViewController{
    NSMutableArray *ipList; 
}

    @property (nonatomic, strong) SMOService *service;
    @property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
