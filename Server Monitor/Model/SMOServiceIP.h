//
//  SMOServiceIP.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOService, SMOServiceAvailable, SMOServiceContent;

@interface SMOServiceIP : NSManagedObject

@property (nonatomic, retain) NSString * idserviceIP;
@property (nonatomic, retain) NSString * addressIp;
@property (nonatomic, retain) NSNumber * avgAvailable;
@property (nonatomic, retain) NSNumber * perSimilarity;
@property (nonatomic, retain) NSString * statusAvailable;
@property (nonatomic, retain) NSString * statusSimilarity;
@property (nonatomic, retain) SMOService *service;
@property (nonatomic, retain) NSSet *serviceAvailability;
@property (nonatomic, retain) NSSet *serviceContent;

-(NSDictionary *) toJson;
+(instancetype)parse:(id)jsonObject;
+(NSMutableArray *)parseArray:(NSMutableArray *)jsonArray;

@end

@interface SMOServiceIP (CoreDataGeneratedAccessors)

- (void)addServiceAvailabilityObject:(SMOServiceAvailable *)value;
- (void)removeServiceAvailabilityObject:(SMOServiceAvailable *)value;
- (void)addServiceAvailability:(NSSet *)values;
- (void)removeServiceAvailability:(NSSet *)values;

- (void)addServiceContentObject:(SMOServiceContent *)value;
- (void)removeServiceContentObject:(SMOServiceContent *)value;
- (void)addServiceContent:(NSSet *)values;
- (void)removeServiceContent:(NSSet *)values;

@end
