//
//  ViewController.m
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/4/30.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import "ViewController.h"
#import "GWGestureTableView.h"
#import "GWCommonSegmentView.h"
#import "GWFloatContainerCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,GWFloatContainerCellDelegate>
@property (nonatomic, strong) GWGestureTableView *tableView;
@property (nonatomic, strong) GWFloatContainerCell *containerCell;
@property (nonatomic, strong) GWCommonSegmentView *segmentView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation ViewController

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 170)];
        UILabel *label = [[UILabel alloc] initWithFrame:_headView.bounds];
        label.text = @"tableHeaderView";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGBA(0xff2c2c2c);
        [_headView addSubview:label];
        _headView.backgroundColor = RANDOMCOLOR();
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
    self.canScroll = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
}

- (void)changeScrollStatus{
    self.canScroll = YES;
    self.containerCell.objectCanScroll = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            /**第一cell*/
        }else{
            /**第二cell*/
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        
        CGFloat bottomCellOffset = [self.tableView rectForSection:1].origin.y - startBarHeight;
        bottomCellOffset = floorf(bottomCellOffset);
        
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                self.containerCell.objectCanScroll = YES;
            }
        }else{
            /**子视图没到顶部*/
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}

- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView{
    self.tableView.scrollEnabled = NO;
}

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x/screenWidth;
    GW_WEAKSELF;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.segmentView updateSegmentViewStatus:(int)page];
    }];
    
    self.tableView.scrollEnabled = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *clientCell = [tableView dequeueReusableCellWithIdentifier:@"clientCellId"];
        if (clientCell == nil) {
            clientCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clientCellId"];
            clientCell.contentView.backgroundColor = RANDOMCOLOR();
        }
        clientCell.clipsToBounds = YES;
        clientCell.selectionStyle = UITableViewCellSelectionStyleNone;
        clientCell.tag = indexPath.row;
        clientCell.textLabel.text = [NSString stringWithFormat:@"第一组%d",(int)indexPath.row];
        return clientCell;
    }
    GWFloatContainerCell *containCell = [tableView dequeueReusableCellWithIdentifier:@"containCellId"];
    if (containCell == nil) {
        containCell = [[GWFloatContainerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"containCellId"];
        containCell.contentView.backgroundColor = RANDOMCOLOR();
    }
    containCell.segmentTitleArr = self.segmentView.segmentTitleArr;
    containCell.VC = self;
    self.containerCell = containCell;
    containCell.delegate = self;
    return containCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 138;
    }
    return screenHeight - sliderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return sliderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.segmentView;
    }
    return nil;
}

- (GWGestureTableView *)tableView{
    if (!_tableView) {
        _tableView = [[GWGestureTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (GWCommonSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[GWCommonSegmentView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, sliderHeight)];
        _segmentView.segmentTitleArr = @[@"悬浮标题1",@"悬浮标题2",@"悬浮标题3",@"悬浮标题4",@"悬浮标题5",@"悬浮标题6",@"悬浮标题7",@"悬浮标题888888888888888888888"];
        GW_WEAKSELF;
        _segmentView.btnDidBlock = ^(int tag) {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.containerCell.isSelectIndex = YES;
                [weakSelf.containerCell.scrollView setContentOffset:CGPointMake(tag*screenWidth, 0) animated:YES];
            }];
        };
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

@end
