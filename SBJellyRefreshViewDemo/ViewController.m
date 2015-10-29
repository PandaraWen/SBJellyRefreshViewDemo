//
//  ViewController.m
//  SBJellyRefreshViewDemo
//
//  Created by Pandara on 15/10/28.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import "ViewController.h"
#import "SBJellyRefreshView.h"
#import "SBDefine.h"
#import "SBTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SBJellyRefreshViewDelegate> {
    NSArray *_cellImageNameArray;
    NSArray *_cellTitleArray;
}

@property (strong, nonatomic) SBJellyRefreshView *refreshView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _cellImageNameArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    _cellTitleArray = @[@"Oversea", @"Emotion", @"Thinking", @"Flower", @"Wedding", @"Single", @"Detail", @"Product", @"Travel", @"Zen"];
    
    self.refreshView = [SBJellyRefreshView getRefreshView];
    self.refreshView.delegate = self;
    self.refreshView.center = CGPointMake(self.refreshView.frame.size.width / 2.0f, -self.refreshView.frame.size.height / 2.0f);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MIDNIGHT_COLOR;
    
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    [self.tableView addSubview:self.refreshView];
    [self.view addSubview:self.tableView];
}

#pragma mark - SBJellyRefreshViewDelegate
- (void)sbJellyRefreshVieWillStartRefresh:(SBJellyRefreshView *)refreshView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshView endRefresh];
    });
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SBCELL_ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SBTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.bgImageView.image = [UIImage imageNamed:[_cellImageNameArray objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [_cellTitleArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}

#pragma mark - Other
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end














