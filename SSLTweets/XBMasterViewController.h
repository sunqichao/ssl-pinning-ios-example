//
//  XBMasterViewController.h
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBDetailViewController;

@interface XBMasterViewController : UITableViewController

@property (strong, nonatomic) XBDetailViewController *detailViewController;

@end
