//
//  SMOServiceAccess.m
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMOServiceAccess.h"
#import "SMOService.h"
#import "SMContext.h"


@implementation SMOServiceAccess

@dynamic password;
@dynamic port;
@dynamic security;
@dynamic url;
@dynamic user;
@dynamic service;

-(NSDictionary *) toJson {
    JsonDictionary *json = [[JsonDictionary alloc] init];
    
    [json setObject:self.service.idservice forKey:@"idservice"];
    [json setObject:self.url forKey:@"url"];
    [json setObject:self.port forKey:@"port"];
    [json setObject:self.security forKey:@"security"];
    [json setObject:self.user forKey:@"username"];
    [json setObject:self.password forKey:@"password"];
    
    return json.dictionary;
}
+(instancetype)parse:(id)jsonObject {
    SMOServiceAccess * serviceAccess = [NSEntityDescription insertNewObjectForEntityForName:@"SMOServiceAccess"inManagedObjectContext: SMContext.sharedCenter.managedObjectContext];
    
    serviceAccess.url = jsonObject[@"url"];
    serviceAccess.port = jsonObject[@"port"];
    serviceAccess.security = jsonObject[@"security"];
    serviceAccess.user = jsonObject[@"username"];
    serviceAccess.password = jsonObject[@"password"];
    
    return serviceAccess;
}



@end
