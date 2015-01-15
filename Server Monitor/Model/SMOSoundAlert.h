//
//  SMOSoundAlert.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOService;

@interface SMOSoundAlert : NSManagedObject

@property (nonatomic, retain) id alert1050;
@property (nonatomic, retain) id alert5070;
@property (nonatomic, retain) id alert7099;
@property (nonatomic, retain) NSString * ipAlert;
@property (nonatomic, retain) id unavailability;
@property (nonatomic, retain) SMOService *service;

@end
