//
//  JsonDictionary.m
//  Server Monitor
//
//  Created by Gustavo Villar on 1/8/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import "JsonDictionary.h"


@implementation JsonDictionary

-(NSMutableDictionary *) dictionary {
    if (_dictionary == nil) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return _dictionary;
}

-(void)setObject:(id)object forKey:(id<NSCopying>)key {
    if (object != nil) {
        [self.dictionary setObject:object forKey:key];
    }
}
- (NSUInteger)count {
    return [self.dictionary count];
}
- (id)objectForKey:(id)aKey {
    return [self.dictionary objectForKey:aKey];
}
- (NSEnumerator *)keyEnumerator {
    return [self.dictionary keyEnumerator];
}

@end
