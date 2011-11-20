//
//  XBTextViewTableCell.m
//  SSLTweets
//
//  Created by Andrew Snare on 18/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBTextViewTableCell.h"

static const CGFloat TEXTVIEW_INSETS = 3.0f;

@implementation XBTextViewTableCell

@synthesize textView = textView_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]))
    {
        UIView *contentView = self.contentView;
        CGRect frame = CGRectInset(contentView.bounds, TEXTVIEW_INSETS, TEXTVIEW_INSETS);
        textView_ = [[UITextView alloc] initWithFrame:frame];
        textView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [contentView addSubview:textView_];
    }
    return self;
}

@end
