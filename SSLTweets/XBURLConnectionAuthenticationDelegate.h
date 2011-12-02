//
//  XBURLConnectionAuthenticationDelegate.h
//  SSLTweets
//
//  Created by Andrew Snare on 20/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBURLConnectionAuthenticationDelegate : NSObject<NSURLConnectionDelegate>

// Set of certificates that are really trusted.
// The validation chain for any SSL peer must contain one of these.
@property (copy, nonatomic) NSSet *reallyTrustedCertificateAuthorities;

@end
