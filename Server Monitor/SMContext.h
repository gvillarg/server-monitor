//
//  SMContext.h
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMContext : NSObject

@property (strong, nonatomic) NSManagedObjectContext *moc;

+(SMContext *)sharedCenter;
-(void)setManagedOC: (NSManagedObjectContext *)moc;
-(NSManagedObjectContext *)managedObjectContext;
@end
