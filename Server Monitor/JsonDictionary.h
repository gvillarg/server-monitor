//
//  JsonDictionary.h
//  Server Monitor
//
//  Created by Gustavo Villar on 1/8/15.
//  Copyright (c) 2015 PUCP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDictionary : NSObject
    @property (nonatomic, retain) NSMutableDictionary * dictionary;
-(void)setObject:(id)object forKey:(id<NSCopying>)key;
- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;
@end
