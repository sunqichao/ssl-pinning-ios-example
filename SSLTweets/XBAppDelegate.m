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

@implementation XBAppDelegate

@synthesize window = window_;
@synthesize navigationController = navigationController_;
@synthesize splitViewController = splitViewController_;

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

        UISplitViewController *newSplitViewController = [[UISplitViewController alloc] init];
        newSplitViewController.delegate = detailViewController;
        newSplitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        self.splitViewController = newSplitViewController;
        rootViewController = newSplitViewController;
    }
    newWindow.rootViewController = rootViewController;
    self.window = newWindow;
    [newWindow makeKeyAndVisible];
    return YES;
}

@end
