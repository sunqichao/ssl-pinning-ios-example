//
//  XBMasterViewController.m
//  SSLTweets
//
//  Created by Andrew Snare on 15/11/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import "XBMasterViewController.h"

#import "NSDictionary+Xebia.h"
#import "XBDetailViewController.h"
#import "XBAppDelegate.h"

static NSString * const TWITTER_SEARCH_URL = @"https://search.twitter.com/search.json?q=%23ssl&lang=en";
static const NSTimeInterval TWITTER_SEARCH_TIMEOUT = 30.0f;

@interface XBMasterViewController ()

@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSURLConnection *currentSearch;
@property (strong, nonatomic) XBTwitterSearchDataDelegate *currentSearchProcessor;
@property (copy, nonatomic) NSDictionary *searchAnswer;
@property (copy, nonatomic, readonly) NSArray *searchResults;

- (NSDictionary *)searchResultAtIndex:(NSUInteger)anIndex;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSearchResultAtIndex:(NSUInteger)anIndex;
- (void)tableView:(UITableView *)tableView didSelectSearchResultAtIndex:(NSUInteger)anIndex;

@end

@implementation XBMasterViewController

@synthesize detailViewController = detailViewController_;
@synthesize refreshButton = refreshButton_;
@synthesize currentSearch = currentSearch_;
@synthesize currentSearchProcessor = currentSearchProcessor_;
@synthesize searchAnswer = searchAnswer_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.title = NSLocalizedString(@"#SSL Tweets", @"Master Title");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0f, 600.0f);
        }
    }
    return self;
}

- (void)dealloc
{
    [currentSearch_ cancel];
}

- (void)setCurrentSearch:(NSURLConnection *)newCurrentSearch
{
    if (currentSearch_ != newCurrentSearch)
    {
        [currentSearch_ cancel];

        currentSearch_ = newCurrentSearch;

        [UIApplication sharedApplication].networkActivityIndicatorVisible = (newCurrentSearch != nil);
        self.refreshButton.enabled = (newCurrentSearch == nil);
    }
}

- (void)setCurrentSearchProcessor:(XBTwitterSearchDataDelegate *)newCurrentSearchProcessor
{
    if (currentSearchProcessor_ != newCurrentSearchProcessor)
    {
        currentSearchProcessor_.delegate = nil;
        self.currentSearch = nil;

        currentSearchProcessor_ = newCurrentSearchProcessor;

        newCurrentSearchProcessor.delegate = self;
    }
}

- (void)setSearchAnswer:(NSDictionary *)newSearchAnswer
{
    if (newSearchAnswer != searchAnswer_)
    {
        searchAnswer_ = [newSearchAnswer copy];

        [self.tableView reloadData];

        if (self.splitViewController != nil)
        {
            UITableView *tableView = self.tableView;
            if ([tableView numberOfRowsInSection:0] > 0)
            {
                NSIndexPath *initiallySelectedRow = [NSIndexPath indexPathForRow:0 inSection:0];
                [tableView selectRowAtIndexPath:initiallySelectedRow
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionMiddle];
                [tableView.delegate tableView:tableView didSelectRowAtIndexPath:initiallySelectedRow];
            }
        }
    }
}

+ (NSSet *)keyPathsForValuesAffectingSearchResults
{
    return [NSSet setWithObject:@"searchAnswer"];
}

- (NSArray *)searchResults
{
    return [self.searchAnswer objectForKey:@"results" ifKindOfClass:[NSArray class]];
}

- (void)startSearch
{
    NSURL *requestUrl = [NSURL URLWithString:TWITTER_SEARCH_URL];
    NSURLRequest * newRequest = [NSURLRequest requestWithURL:requestUrl
                                                 cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                             timeoutInterval:TWITTER_SEARCH_TIMEOUT];
    XBTwitterSearchDataDelegate *searchResultProcessor = [[XBTwitterSearchDataDelegate alloc] init];
    XBAppDelegate *appDelegate = (XBAppDelegate *)[UIApplication sharedApplication].delegate;
    searchResultProcessor.reallyTrustedCertificateAuthorities = appDelegate.reallyTrustedCertificateAuthorities;
    self.currentSearchProcessor = searchResultProcessor;
    self.currentSearch = [NSURLConnection connectionWithRequest:newRequest delegate:searchResultProcessor];
}

- (NSDictionary *)searchResultAtIndex:(NSUInteger)anIndex
{
    return [self.searchResults objectAtIndex:anIndex];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(startSearch)];
    self.refreshButton = refreshButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)viewDidUnload
{
    self.refreshButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (nil == self.searchResults)
    {
        [self startSearch];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentSearch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone
            || interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfRows = [self.searchResults count];
    return MIN((NSInteger)numberOfRows, NSIntegerMax);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section)
    {
        case 0:
        {
            NSInteger row = indexPath.row;
            if (row >= 0)
            {
                cell = [self tableView:tableView cellForSearchResultAtIndex:(NSUInteger)row];
                break;
            }
            // Intentional fall-through.
        }
        default:
            cell = nil;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSearchResultAtIndex:(NSUInteger)anIndex
{
    static NSString * const CELL_IDENTIFIER = @"TweetSummaryCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    // Configure the cell.
    NSDictionary *searchResult = [self searchResultAtIndex:anIndex];
    cell.detailTextLabel.text = [searchResult objectForKey:@"text" ifKindOfClass:[NSString class]];
    cell.textLabel.text = [searchResult objectForKey:@"from_user_name" ifKindOfClass:[NSString class]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            NSInteger row = indexPath.row;
            if (row >= 0)
            {
                [self tableView:tableView didSelectSearchResultAtIndex:(NSUInteger)row];
                break;
            }
            // Intentional fall-through.
        }
        default:
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectSearchResultAtIndex:(NSUInteger)anIndex
{
    XBDetailViewController *detailViewController = self.detailViewController;
    BOOL pushToDetails = (nil == self.splitViewController);
    if (detailViewController == nil)
    {
        NSAssert(pushToDetails, @"Detail view controller can only be lazily initialized when pushing to details.");
        self.detailViewController = detailViewController =
            [[XBDetailViewController alloc] initWithNibName:@"XBDetailViewController_iPhone" bundle:nil];
    }
    detailViewController.detailItem = [self searchResultAtIndex:anIndex];
    if (pushToDetails)
    {
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark <XBTwitterSearchResultDelegate> methods

- (void)twitterDataDelegate:(XBTwitterSearchDataDelegate *)dataDelegate didFailWithError:(NSError *)anError
{
    NSString *title = [anError localizedDescription];
    NSString *message = [anError localizedFailureReason];
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Button text to dismiss alert");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alertView show];
    self.currentSearchProcessor = nil;
}

- (void)twitterDataDelegate:(XBTwitterSearchDataDelegate *)dataDelegate didReceiveAnswer:(NSDictionary *)searchAnswer
{
    self.searchAnswer = searchAnswer;
    self.currentSearchProcessor = nil;
}

@end
