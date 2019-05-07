//
//  GWCommonSegmentView.h
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/5/5.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWCommonSegmentView : UIView

@property (nonatomic, strong) NSArray *segmentTitleArr;

@property(nonatomic, copy) void (^btnDidBlock)(int tag);

- (void)updateSegmentViewStatus:(int)index;

- (void)updateBageViewHidenOrShow:(int)btnIndex;

/**显示小红点*/
- (void)showBageView:(int)btnIndex;
/**隐藏小红点*/
- (void)hideBageView:(int)btnIndex;
/**隐藏所有小红点*/
- (void)hideAllBageView;

@end
