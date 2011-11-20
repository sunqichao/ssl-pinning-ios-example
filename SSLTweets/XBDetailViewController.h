//
//  XBDetailViewController.h
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBDetailViewController : UITableViewController <UISplitViewControllerDelegate>

@property (copy, nonatomic) NSDictionary *detailItem;

@end
