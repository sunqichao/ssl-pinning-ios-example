//
//  XBTwitterSearchDataDelegate.h
//  SSLTweets
//
//  Created by Andrew Snare on 16/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBTwitterSearchDataDelegate;

@protocol XBTwitterSearchResultDelegate

// One of these methods will be invoked, and only once.
- (void)twitterDataDelegate:(XBTwitterSearchDataDelegate *)dataDelegate didReceiveAnswer:(NSDictionary *)answer;
- (void)twitterDataDelegate:(XBTwitterSearchDataDelegate *)dataDelegate didFailWithError:(NSError *)anError;

@end

@interface XBTwitterSearchDataDelegate : NSObject<NSURLConnectionDataDelegate>

@property (weak, nonatomic) id<XBTwitterSearchResultDelegate> delegate;

@end

extern NSString * const XBTwitterSearchDataDelegateErrorDomain;
enum XBTwitterSearchDataDelegateErrorCode
{
    XBTwitterSearchDataDelegateInvalidStatusError,
    XBTwitterSearchDataDelegateIncorrectContentTypeError,
};
