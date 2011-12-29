//
//  XBURLConnectionAuthenticationDelegate.m
//  SSLTweets
//
//  Created by Andrew Snare on 20/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBURLConnectionAuthenticationDelegate.h"

@implementation XBURLConnectionAuthenticationDelegate

@synthesize reallyTrustedCertificateAuthorities = reallyTrustedCertificateAuthorities_;

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    id <NSURLAuthenticationChallengeSender> sender = challenge.sender;
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if (protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    {
        SecTrustRef serverTrustContext = protectionSpace.serverTrust;
        SecTrustSetAnchorCertificatesOnly(serverTrustContext, false);
        SecTrustResultType trustResult;
        SecTrustEvaluate(serverTrustContext, &trustResult);
        BOOL proceed = NO;
        switch (trustResult)
        {
            case kSecTrustResultProceed:
            case kSecTrustResultUnspecified:
            {
                CFIndex certificateCount = SecTrustGetCertificateCount(serverTrustContext);
                NSSet *trustedCertificates = self.reallyTrustedCertificateAuthorities;
                for (CFIndex i = 0; i < certificateCount; ++i)
                {
                    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrustContext, i);
                    NSData *certificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
                    if ([trustedCertificates containsObject:spkiData])
                    {
                        proceed = YES;
                        break;
                    }
                }
            }
        }
        if (proceed)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrustContext];
            [sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        else
        {
            [sender cancelAuthenticationChallenge:challenge];
        }
    }
    else
    {
        [sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

@end
