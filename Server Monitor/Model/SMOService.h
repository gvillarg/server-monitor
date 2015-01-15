//
//  SMOService.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOServiceAccess, SMOBaseService, SMOServiceIP, SMOSoundAlert;

@interface SMOService : NSManagedObject

@property (nonatomic, retain) NSNumber * idservice;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * periodicity;
@property (nonatomic, retain) NSNumber * pwLibraries;
@property (nonatomic, retain) NSNumber * pwParser;
@property (nonatomic, retain) NSNumber * similarity;
@property (nonatomic, retain) NSString * statusAvailable;
@property (nonatomic, retain) NSNumber * statusContent;
@property (nonatomic, retain) NSNumber * stRecursive;
@property (nonatomic, retain) NSNumber * swMode;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * sfPath;
@property (nonatomic, retain) SMOServiceAccess *serviceAccess;
@property (nonatomic, retain) SMOSoundAlert *alert;
@property (nonatomic, retain) NSSet *baseService;
@property (strong) NSMutableArray *serviceIP;

+(NSString *)ftpService;
+(NSString *)webService;
+(NSString *)webPage;
+(instancetype)parse:(id)jsonObject;
+(NSMutableArray *)parseArray:(NSMutableArray *)jsonArray;

-(NSDictionary *) toJson;
@end



@interface SMOService (CoreDataGeneratedAccessors)

- (void)addBaseServiceObject:(SMOBaseService *)value;
- (void)removeBaseServiceObject:(SMOBaseService *)value;
- (void)addBaseService:(NSSet *)values;
- (void)removeBaseService:(NSSet *)values;


@end
