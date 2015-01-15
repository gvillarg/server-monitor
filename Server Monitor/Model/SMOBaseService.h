//
//  SMOBaseService.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOService;

@interface SMOBaseService : NSManagedObject

@property (nonatomic, retain) id baseService;
@property (nonatomic, retain) NSDate * refreshDate;
@property (nonatomic, retain) SMOService *service;

@end
