//
//  NSDictionary+Xebia.h
//  SSLTweets
//
//  Created by Andrew Snare on 16/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Xebia)

- (id)objectForKey:(id)aKey ifKindOfClass:(Class)aClass;
- (id)objectForKey:(id)aKey ifKindOfClass:(Class)aClass notFoundMarker:(id)marker;

@end
