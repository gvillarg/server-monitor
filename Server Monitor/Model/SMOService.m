//
//  SMOService.m
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMOService.h"
#import "SMOAccessService.h"
#import "SMOBaseService.h"
#import "SMOServiceIP.h"
#import "SMOSoundAlert.h"
#import "SMContext.h"
#import "SMOServiceAccess.h"


@implementation SMOService

@dynamic idservice;
@dynamic active;
@dynamic identifier;
@dynamic name;
@dynamic periodicity;
@dynamic pwLibraries;
@dynamic pwParser;
@dynamic similarity;
@dynamic statusAvailable;
@dynamic statusContent;
@dynamic stRecursive;
@dynamic swMode;
@dynamic type;
@dynamic sfPath;
@dynamic serviceAccess;
@dynamic alert;
@dynamic baseService;
@synthesize serviceIP;


+(NSString *)ftpService{
    return @"ftp";
}
+(NSString *)webService{
    return @"webService";
}
+(NSString *)webPage{
    return @"webPage";
}

+(instancetype)parse:(id)jsonObject {
    SMOService * service = [NSEntityDescription insertNewObjectForEntityForName:@"SMOService"inManagedObjectContext: SMContext.sharedCenter.managedObjectContext];
    
    service.active = jsonObject[@"enable"];
    service.idservice = jsonObject[@"idservice"];
    service.name = jsonObject[@"name"];
    service.periodicity = jsonObject[@"periodicity"];
    service.pwLibraries = jsonObject[@"pwlibrary"];
    service.sfPath = jsonObject[@"sfpath"];
    service.stRecursive = jsonObject[@"sfrecursive"];
    service.similarity = jsonObject[@"similarity"];
    service.statusContent = jsonObject[@"statusc"];
    service.statusAvailable = jsonObject[@"statusd"];
    service.type = jsonObject[@"type"];
    service.swMode = jsonObject[@"wsmode"];
    
    service.serviceAccess = [SMOServiceAccess parse:jsonObject[@"serviceAccess"]];
    service.serviceAccess.service = service;
    
    service.serviceIP = [SMOServiceIP parseArray:jsonObject[@"serviceTerminal"]];
    
    return service;
}

+(NSMutableArray *)parseArray:(id)jsonArray {
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonObject in jsonArray) {
        [services addObject:[SMOService parse:jsonObject]];
    }
    return services;
}



-(NSDictionary *) toJson {
    JsonDictionary *json = [[JsonDictionary alloc] init];
    
    [json setObject:self.name forKey:@"name"];
    [json setObject:self.type forKey:@"type"];
    [json setObject:self.periodicity forKey:@"periodicity"];
    [json setObject:self.active forKey:@"enable"];
    [json setObject:self.similarity forKey:@"similarity"];
    [json setObject:self.pwLibraries forKey:@"pwlibrary"];
    [json setObject:self.swMode forKey:@"wsmode"];
    [json setObject:self.stRecursive forKey:@"sfrecursive"];
    [json setObject:self.sfPath forKey:@"sfpath"];
    [json setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"iduser"];
    
    return json.dictionary;
}


@end
