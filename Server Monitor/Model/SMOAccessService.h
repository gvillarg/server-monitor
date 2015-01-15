//
//  SMOAccessService.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOService;

@interface SMOAccessService : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSNumber * security;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) SMOService *service;

@end
