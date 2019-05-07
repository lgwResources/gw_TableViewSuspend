//
//  GWFloatContainerCell.h
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/5/5.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GWFloatContainerCellDelegate <NSObject>

@optional
- (void)containerScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)containerScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@interface GWFloatContainerCell : UITableViewCell

@property (nonatomic,strong) UIViewController *VC;

- (void)configScrollView;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL objectCanScroll;
@property (nonatomic, assign) BOOL isSelectIndex;
@property (nonatomic, strong) NSArray *segmentTitleArr;

@property (nonatomic,weak) id<GWFloatContainerCellDelegate>delegate;

@end
