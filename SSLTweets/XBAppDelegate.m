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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        XBMasterViewController *masterViewController = [[XBMasterViewController alloc] initWithNibName:@"XBMasterViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
    }
    else
    {
        XBMasterViewController *masterViewController = [[XBMasterViewController alloc] initWithNibName:@"XBMasterViewController_iPad" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        XBDetailViewController *detailViewController = [[XBDetailViewController alloc] initWithNibName:@"XBDetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

@end
