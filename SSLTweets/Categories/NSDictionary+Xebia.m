//
//  NSDictionary+Xebia.m
//  SSLTweets
//
//  Created by Andrew Snare on 16/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "NSDictionary+Xebia.h"

@implementation NSDictionary (Xebia)

- (id)objectForKey:(id)aKey ifKindOfClass:(Class)aClass
{
    return [self objectForKey:aKey ifKindOfClass:aClass notFoundMarker:nil];
}

- (id)objectForKey:(id)aKey ifKindOfClass:(Class)aClass notFoundMarker:(id)marker
{
    id<NSObject> objectForKey = [self objectForKey:aKey];
    return [objectForKey isKindOfClass:aClass] ? objectForKey : marker;
}

@end
