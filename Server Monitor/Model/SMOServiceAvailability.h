//
//  SMOServiceAvailable.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOServiceAvailabilityDetail, SMOServiceIP, SMOServicesAux;

@interface SMOServiceAvailability : NSManagedObject

@property (nonatomic, retain) NSNumber * avgPingService1;
@property (nonatomic, retain) NSNumber * avgPingService2;
@property (nonatomic, retain) NSNumber * avgPingService3;
@property (nonatomic, retain) NSDate * datePing;
@property (nonatomic, retain) NSNumber * pingTime;
@property (nonatomic, retain) NSNumber * statusAvailable;
@property (nonatomic, retain) NSNumber * statusContent;
@property (nonatomic, retain) SMOServiceAvailabilityDetail *detail;
@property (nonatomic, retain) NSSet *service;
@property (nonatomic, retain) SMOServiceIP *serviceIP;


@property (nonatomic, retain) id serviceDownloaded;
@property (nonatomic, retain) NSNumber * similarityRate;
@property (nonatomic, retain) NSNumber * idServiceTest;
@end

@interface SMOServiceAvailability (CoreDataGeneratedAccessors)

- (void)addServiceObject:(SMOServicesAux *)value;
- (void)removeServiceObject:(SMOServicesAux *)value;
- (void)addService:(NSSet *)values;
- (void)removeService:(NSSet *)values;

+ (NSMutableArray *)parseArray:(NSMutableArray *)jsonArray;
+ (instancetype) parse:(NSDictionary *)jsonObject;

@end
