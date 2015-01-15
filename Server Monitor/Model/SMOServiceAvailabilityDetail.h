//
//  SMOServiceAvailabilityDetail.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOServiceAvailable;

@interface SMOServiceAvailabilityDetail : NSManagedObject

@property (nonatomic, retain) NSNumber * ping;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) SMOServiceAvailable *serviceAvailability;

@end
