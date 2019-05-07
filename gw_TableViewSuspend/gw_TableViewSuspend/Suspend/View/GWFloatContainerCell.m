//
//  GWFloatContainerCell.m
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/5/5.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import "GWFloatContainerCell.h"
#import "GWFirstTableViewController.h"

@interface GWFloatContainerCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GWFirstTableViewController *firstVC;
@property (nonatomic, strong) GWFirstTableViewController *secondVC;
@property (nonatomic, strong) GWFirstTableViewController *threeVC;

@end

@implementation GWFloatContainerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.scrollView];
//        [self configScrollView];
    }
    return self;
}

- (void)setVC:(UIViewController *)VC{
    _VC = VC;
    [self configScrollView];
}

- (void)configScrollView{
    _firstVC = [GWFirstTableViewController new];
    _firstVC.VC = _VC;
    _secondVC = [GWFirstTableViewController new];
    _secondVC.VC = _VC;
    _threeVC = [GWFirstTableViewController new];
    _threeVC.VC = _VC;
    
    [self.scrollView addSubview:_firstVC.view];
    [self.scrollView addSubview:_secondVC.view];
    [self.scrollView addSubview:_threeVC.view];
    
    _firstVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight-sliderHeight-startBarHeight);
    _secondVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight-sliderHeight-startBarHeight);
    _threeVC.view.frame = CGRectMake(screenWidth*2, 0, screenWidth, screenHeight-sliderHeight-startBarHeight);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.segmentTitleArr.count, self.scrollView.height);
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isSelectIndex = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 为了横向滑动的时候，外层的tableView不动
    if (!self.isSelectIndex) {
        if (scrollView == self.scrollView) {
            if ([self.delegate respondsToSelector:@selector(containerScrollViewDidScroll:)]) {
                [self.delegate containerScrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if ([self.delegate respondsToSelector:@selector(containerScrollViewDidEndDecelerating:)]) {
            [self.delegate containerScrollViewDidEndDecelerating:scrollView];
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-sliderHeight-startBarHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)setObjectCanScroll:(BOOL)objectCanScroll {
    _objectCanScroll = objectCanScroll;
    
    self.firstVC.vcCanScroll = objectCanScroll;
    self.secondVC.vcCanScroll = objectCanScroll;
    self.threeVC.vcCanScroll = objectCanScroll;
    
    if (!objectCanScroll) {
        [self.firstVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.secondVC.tableView setContentOffset:CGPointZero animated:NO];
        [self.threeVC.tableView setContentOffset:CGPointZero animated:NO];
    }
}

@end
