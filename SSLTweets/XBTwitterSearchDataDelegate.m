//
//  XBTwitterSearchDataDelegate.m
//  SSLTweets
//
//  Created by Andrew Snare on 16/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBTwitterSearchDataDelegate.h"

enum httpStatusCodes
{
  SC_OK = 200,
};

NSString * const XBTwitterSearchDataDelegateErrorDomain = @"XBTwitterSearchDataDelegateErrorDomain";

@interface XBTwitterSearchDataDelegate ()

@property (strong, nonatomic) NSMutableData *accumulatedResponse;

@end

@implementation XBTwitterSearchDataDelegate

@synthesize delegate = delegate_;
@synthesize accumulatedResponse = accumulatedResponse_;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate twitterDataDelegate:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSError *error;
    NSInteger statusCode = [httpResponse statusCode];
    if (statusCode != SC_OK)
    {
        error = [NSError errorWithDomain:XBTwitterSearchDataDelegateErrorDomain
                                    code:XBTwitterSearchDataDelegateInvalidStatusError
                                userInfo:nil];
    }
    else if (![@"application/json" isEqualToString:[httpResponse MIMEType]])
    {
        error = [NSError errorWithDomain:XBTwitterSearchDataDelegateErrorDomain
                                    code:XBTwitterSearchDataDelegateIncorrectContentTypeError
                                userInfo:nil];
    }
    else
    {
        error = nil;
        long long sizeHint = [httpResponse expectedContentLength];
        self.accumulatedResponse =
            (sizeHint >= 0 && sizeHint <= NSUIntegerMax) ? [NSMutableData dataWithCapacity:(NSUInteger)sizeHint] : [NSMutableData data];
    }
    if (error != nil)
    {
        [connection cancel];
        [self.delegate twitterDataDelegate:self didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.accumulatedResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *searchAnswer =
        [NSJSONSerialization JSONObjectWithData:self.accumulatedResponse options:0 error:&error];
    if (searchAnswer != nil)
    {
        [self.delegate twitterDataDelegate:self didReceiveAnswer:searchAnswer];
    }
    else
    {
        [self.delegate twitterDataDelegate:self didFailWithError:error];
    }
}

@end
