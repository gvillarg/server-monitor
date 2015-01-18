//
//  SMOServiceIP.m
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMOServiceIP.h"
#import "SMOService.h"
#import "SMOServiceAvailability.h"
#import "SMOServiceContent.h"
#import "SMContext.h"


@implementation SMOServiceIP

@dynamic addressIp;
@dynamic avgAvailable;
@dynamic perSimilarity;
@dynamic statusAvailable;
@dynamic statusSimilarity;
@dynamic service;
@dynamic serviceAvailability;
@dynamic serviceContent;
@synthesize idserviceIP;

-(NSDictionary *) toJson {
    JsonDictionary *json = [[JsonDictionary alloc] init];

    [json setObject:self.idserviceIP forKey:@"idserviceterminal"];
    [json setObject:self.service.idservice forKey:@"idservice"];
    [json setObject:self.addressIp forKey:@"ipaddress"];
    [json setObject:self.avgAvailable forKey:@"lastavgping"];
    [json setObject:self.perSimilarity forKey:@"lastavgping"];
    [json setObject:self.statusSimilarity forKey:@"statusc"];
    [json setObject:self.statusAvailable forKey:@"statusd"];
    
    return json.dictionary;
}

+(instancetype)parse:(id)jsonObject {
    SMOServiceIP * ip = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceIP"inManagedObjectContext: SMContext.sharedCenter.managedObjectContext];

    ip.idserviceIP = jsonObject[@"idserviceterminal"];
    ip.addressIp = jsonObject[@"ipaddress"];
    ip.avgAvailable = jsonObject[@"lastavgping"];
    ip.perSimilarity = jsonObject[@"lastavgsimilarity"];
    ip.statusAvailable = jsonObject[@"statusd"];
    ip.statusSimilarity= jsonObject[@"statusc"];
    
    return ip;
}

+(NSMutableArray *)parseArray:(id)jsonArray {
    NSMutableArray *ipsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonObject in jsonArray) {
        [ipsArray addObject:[SMOServiceIP parse:jsonObject]];
    }
    return ipsArray;
}

@end
