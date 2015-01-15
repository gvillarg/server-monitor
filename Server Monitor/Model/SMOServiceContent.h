//
//  SMOServiceContent.h
//  Server Monitor
//
//  Created by Cesar on 22/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMOServiceIP;

@interface SMOServiceContent : NSManagedObject

@property (nonatomic, retain) NSDate * monitorDate;
@property (nonatomic, retain) id serviceDownloaded;
@property (nonatomic, retain) NSNumber * similarityRate;
@property (nonatomic, retain) SMOServiceIP *serviceIP;

@end
