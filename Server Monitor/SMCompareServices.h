//
//  SMCompareServices.h
//  Server Monitor
//
//  Created by Cesar on 18/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCompareServices : NSObject

+ (float)compareStructureFTP:(NSDictionary *)base downloaded: (NSDictionary *)newService;
+ (float)compareStructureWebServices: (NSDictionary *)base downloaded: (NSDictionary *)newService type: (NSString *)type;
@end
