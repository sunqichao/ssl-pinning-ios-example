//
//  XBDetailViewController.m
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBDetailViewController.h"

#import "NSDictionary+Xebia.h"
#import "XBTextViewTableCell.h"

enum
{
    SECTION_TEXT = 0,
    SECTION_TEXT_ROW_TEXT = 0,
    SECTION_TEXT_ROW_COUNT = SECTION_TEXT_ROW_TEXT + 1,
};

static UIFont *SECTION_TEXT_ROW_TEXT_FONT;
static NSUInteger SECTION_TEXT_ROW_TEXT_MAXLINES;
static CGFloat SECTION_TEXT_ROW_TEXT_HEIGHT;

@interface XBDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
- (CGFloat)tableView:(UITableView *)tableView heightForTextSectionRowAtIndex:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForTextSectionRowAtIndex:(NSInteger)row;

@end

@implementation XBDetailViewController

@synthesize detailItem = detailItem_;
@synthesize masterPopoverController = masterPopoverController_;

+ (void)initialize
{
    if (self == [XBDetailViewController class])
    {
        SECTION_TEXT_ROW_TEXT_FONT = [UIFont systemFontOfSize:1.5f * [UIFont systemFontSize]];
        SECTION_TEXT_ROW_TEXT_MAXLINES =
            ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 4 : 6;
        // An extra line height as padding.
        SECTION_TEXT_ROW_TEXT_HEIGHT = SECTION_TEXT_ROW_TEXT_FONT.lineHeight * (SECTION_TEXT_ROW_TEXT_MAXLINES + 1);
    }
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem_ != newDetailItem)
    {
        detailItem_ = newDetailItem;

        // Update the view.
        [self configureView];
    }

    [self.masterPopoverController dismissPopoverAnimated:YES];
}

- (void)configureView
{
    self.title = [self.detailItem objectForKey:@"from_user_name" ifKindOfClass:[NSString class]];
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone
            || interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    switch (section)
    {
        case SECTION_TEXT:
            numberOfRows = (self.detailItem != nil) ? SECTION_TEXT_ROW_COUNT : 0;
            break;
        default:
            numberOfRows = 0;
            break;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSInteger row = indexPath.row;
    switch (indexPath.section)
    {
        case SECTION_TEXT:
            height = [self tableView:tableView heightForTextSectionRowAtIndex:row];
            break;
        default:
            height = tableView.rowHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    switch (indexPath.section)
    {
        case SECTION_TEXT:
            cell = [self tableView:tableView cellForTextSectionRowAtIndex:row];
            break;
        default:
            cell = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForTextSectionRowAtIndex:(NSInteger)row
{
    CGFloat height;
    switch (row)
    {
        case SECTION_TEXT_ROW_TEXT:
            height = SECTION_TEXT_ROW_TEXT_HEIGHT;
            break;
        default:
            height = tableView.rowHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForTextSectionRowAtIndex:(NSInteger)row
{
    UITableViewCell *cell;
    switch (row)
    {
        case SECTION_TEXT_ROW_TEXT:
        {
            static NSString * const CELL_IDENTIFIER = @"TextCell";
            XBTextViewTableCell *textCell = (XBTextViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
            if (textCell == nil)
            {
                textCell = [[XBTextViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
                textCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UITextView *textView = textCell.textView;
                textView.font = SECTION_TEXT_ROW_TEXT_FONT;
                textView.editable = NO;
                textView.dataDetectorTypes = UIDataDetectorTypeAll;
                textView.scrollEnabled = NO;
            }
            NSString *tweetText = [self.detailItem objectForKey:@"text" ifKindOfClass:[NSString class]];
            textCell.textView.text = tweetText;
            cell = textCell;
            break;
        }
        default:
            cell = nil;
    }
    return cell;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Overview", @"Button to display search result overview");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
