//
//  SMGetService.h
//  Server Monitor
//
//  Created by Cesar on 6/11/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMOService.h"

@interface SMGetService : NSObject

@property (strong,nonatomic) NSDictionary *jsonParsed;

-(NSString *)getJson: (SMOService *)service;

@end
