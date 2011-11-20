//
//  XBMasterViewController.h
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XBTwitterSearchDataDelegate.h"

@class XBDetailViewController;

@interface XBMasterViewController : UITableViewController<XBTwitterSearchResultDelegate>

@property (strong, nonatomic) XBDetailViewController *detailViewController;

- (void)startSearch;

@end
