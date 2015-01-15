//
//  SMContext.m
//  Server Monitor
//
//  Created by Cesar on 22/09/14.
//  Copyright (c) 2014 PUCP. All rights reserved.
//

#import "SMContext.h"

@implementation SMContext

+(id)sharedCenter
{
    static dispatch_once_t pred;
    static SMContext *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SMContext alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}
-(NSManagedObjectContext *)managedObjectContext{
    return _moc;
}

-(void)setManagedOC:(NSManagedObjectContext *)moc {
    _moc = moc;
}

@end
