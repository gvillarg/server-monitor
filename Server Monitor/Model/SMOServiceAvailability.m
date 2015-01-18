//
//  SMOServiceAvailable.m
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMOServiceAvailability.h"
#import "SMOServiceAvailabilityDetail.h"
#import "SMOServiceIP.h"
#import "SMOServicesAux.h"
#import "SMContext.h"


@implementation SMOServiceAvailability

@dynamic avgPingService1;
@dynamic avgPingService2;
@dynamic avgPingService3;
@dynamic datePing;
@dynamic pingTime;
@dynamic statusAvailable;
@dynamic detail;
@dynamic service;
@dynamic serviceIP;

@synthesize serviceDownloaded;
@synthesize similarityRate;
@synthesize statusContent;
@synthesize idServiceTest;

+(instancetype)parse:(NSDictionary *)jsonObject {
    
    SMOServiceAvailability *availability = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceAvailability"inManagedObjectContext: SMContext.sharedCenter.managedObjectContext];
    
    availability.pingTime = jsonObject[@"avgping"];
    availability.idServiceTest = jsonObject[@"idservicetest"];
    availability.similarityRate = jsonObject[@"similarity"];
    availability.statusContent = jsonObject[@"statuscontent"];
    availability.statusAvailable = jsonObject[@"statusavailability"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    availability.datePing = [dateFormat dateFromString:jsonObject[@"testDate"]];
    
    NSDictionary *testPing = jsonObject[@"testping"];
    availability.avgPingService1 = testPing[@"ping1"];
    availability.avgPingService2 = testPing[@"ping2"];
    availability.avgPingService3 = testPing[@"ping3"];
    
    return availability;
}

+(NSMutableArray *)parseArray:(NSMutableArray *)jsonArray{
    NSMutableArray * availabilityArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *jsonObject in jsonArray) {
        [availabilityArray addObject:[self parse:jsonObject]];
    }
    
    return availabilityArray;
}

@end
