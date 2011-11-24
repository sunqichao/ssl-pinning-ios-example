//
//  XBURLConnectionAuthenticationDelegate.m
//  SSLTweets
//
//  Created by Andrew Snare on 20/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBURLConnectionAuthenticationDelegate.h"

@implementation XBURLConnectionAuthenticationDelegate

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
        CFIndex certificateCount = SecTrustGetCertificateCount(serverTrustContext);
        for (CFIndex i = 0; i < certificateCount; ++i)
        {
            SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrustContext, i);
            CFStringRef certificateSummary = SecCertificateCopySubjectSummary(certificate);
            NSLog(@"Certificate %u: %@", (unsigned)i, certificateSummary);
            CFRelease(certificateSummary);
        }
        switch (trustResult)
        {
            case kSecTrustResultProceed:
            case kSecTrustResultUnspecified:
            {
                NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrustContext];
                [sender useCredential:credential forAuthenticationChallenge:challenge];
                break;
            }
            default:
                [sender cancelAuthenticationChallenge:challenge];
        }
    }
    else
    {
        [sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

@end
