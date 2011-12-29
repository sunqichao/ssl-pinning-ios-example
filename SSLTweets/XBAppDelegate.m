//
//  XBAppDelegate.m
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBAppDelegate.h"

#import "XBMasterViewController.h"
#import "XBDetailViewController.h"
#import "XBDERDecoder.h"

@implementation XBAppDelegate

@synthesize window = window_;
@synthesize navigationController = navigationController_;
@synthesize splitViewController = splitViewController_;
@synthesize reallyTrustedCertificateAuthorities = reallyTrustedCertificateAuthorities_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        XBMasterViewController *masterViewController = [[XBMasterViewController alloc] initWithNibName:@"XBMasterViewController_iPhone" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.navigationController = masterNavigationController;
        rootViewController = masterNavigationController;
    }
    else
    {
        XBMasterViewController *masterViewController = [[XBMasterViewController alloc] initWithNibName:@"XBMasterViewController_iPad" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        XBDetailViewController *detailViewController = [[XBDetailViewController alloc] initWithNibName:@"XBDetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        masterViewController.detailViewController = detailViewController;

        UISplitViewController *newSplitViewController = [[UISplitViewController alloc] init];
        newSplitViewController.delegate = detailViewController;
        newSplitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        self.splitViewController = newSplitViewController;
        rootViewController = newSplitViewController;

        [masterViewController startSearch];
    }
    newWindow.rootViewController = rootViewController;
    self.window = newWindow;
    [newWindow makeKeyAndVisible];
    return YES;
}

- (NSSet *)reallyTrustedCertificateAuthorities
{
    NSSet *trustedSet = reallyTrustedCertificateAuthorities_;
    if (nil == trustedSet)
    {
        NSBundle *appBundle = [NSBundle bundleForClass:[self class]];
        NSString *pathOfTrustedCertificateAuthority = [appBundle pathForResource:@"required-ca" ofType:@"crt"];
        NSData *trustedCertificateAuthority = [[NSData alloc] initWithContentsOfFile:pathOfTrustedCertificateAuthority];
        NSData *identityOfTrustedCertificateAuthority = [trustedCertificateAuthority dataForX509CertificateSubjectPublicKeyInfo];
        if (nil != identityOfTrustedCertificateAuthority)
        {
            reallyTrustedCertificateAuthorities_ = trustedSet = [NSSet setWithObject:identityOfTrustedCertificateAuthority];
        }
        else
        {
            NSLog(@"Unable to load identity of trusted certificate authority; all CAs will be accepted.");
        }
    }
    return trustedSet;
}

@end
