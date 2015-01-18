//
//  SMOSound.h
//  Server Monitor
//
//  Created by Cesar on 26/10/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMOSound : NSObject //NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSNumber * index;

-(void)setAsUnavailableSound;
-(void)setAsChangedSound;

+(NSArray *)all;
+(SMOSound *)unavailableSound;
+(SMOSound *)changedSound;
+(void)setUnavailableSound:(SMOSound *)sound;
+(void)setChangedSound:(SMOSound *)sound;

@end
