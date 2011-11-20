//
//  XBTextViewTableCell.h
//  SSLTweets
//
//  Created by Andrew Snare on 18/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBTextViewTableCell : UITableViewCell

@property (strong, nonatomic) UITextView *textView;

// Designated initializer.
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
