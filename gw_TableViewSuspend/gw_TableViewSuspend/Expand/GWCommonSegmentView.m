//
//  GWCommonSegmentView.m
//  gw_TableViewSuspend
//
//  Created by 刘功武 on 2019/5/5.
//  Copyright © 2019年 刘功武. All rights reserved.
//
#define btnSpace 10
#import "GWCommonSegmentView.h"

@interface GWCommonSegmentView ()
@property (nonatomic, strong) UIButton *currentSegmentBtn;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIView *linView;
@property (nonatomic, strong) UIView *moveView;
@property (nonatomic, strong) NSMutableArray *bageViewArr;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@end

@implementation GWCommonSegmentView

- (UIScrollView *)segmentScrollView {
    if (!_segmentScrollView) {
        _segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-1)];
        _segmentScrollView.backgroundColor                 = [UIColor clearColor];
        _segmentScrollView.showsVerticalScrollIndicator    = NO;
        _segmentScrollView.showsHorizontalScrollIndicator  = NO;
        _segmentScrollView.contentSize                     = CGSizeMake(self.width, self.height-1);
        [self addSubview:_segmentScrollView];
    }
    return _segmentScrollView;
}

- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (NSMutableArray *)bageViewArr {
    if (!_bageViewArr) {
        _bageViewArr = [NSMutableArray array];
    }
    return _bageViewArr;
}

- (UIView *)moveView {
    if (!_moveView) {
        _moveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-3, 20, 2)];
        _moveView.backgroundColor = UIColorFromRGBA(0xff4183FE);
        [self.segmentScrollView addSubview:_moveView];
    }
    return _moveView;
}

- (UIView *)linView {
    if (!_linView) {
        _linView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, screenWidth, 1)];
        _linView.backgroundColor = UIColorFromRGBA(0xfff2f2f2);
    }
    return _linView;
}

- (UIButton *)currentSegmentBtn {
    if (!_currentSegmentBtn) {
        _currentSegmentBtn = [[UIButton alloc] init];
        [_currentSegmentBtn setTitleColor:UIColorFromRGBA(0xff4183FE) forState:UIControlStateNormal];
        _currentSegmentBtn.titleLabel.font = CUSTOMEFONT(16);
    }
    return _currentSegmentBtn;
}


- (void)setSegmentTitleArr:(NSArray *)segmentTitleArr {
    _segmentTitleArr = segmentTitleArr;
    
    if (self.btnArr.count>0) {
        [self.btnArr removeAllObjects];
    }
    if (self.bageViewArr.count>0) {
        [self.bageViewArr removeAllObjects];
    }
    
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    
    self.moveView = nil;
    if (segmentTitleArr.count>0) {
        
        CGFloat totalWidth = 0;
        CGFloat totalTitleWidth = 0;
        for (NSString *title in segmentTitleArr) {
            CGFloat titleWidth = [title widthWithFont:CUSTOMEFONT(16) constrainedToHeight:self.segmentScrollView.height];
            totalTitleWidth += titleWidth;
            
            totalWidth += (btnSpace + titleWidth + btnSpace);
        }
        
        if (totalWidth > screenWidth) {
            self.segmentScrollView.contentSize = CGSizeMake(totalWidth, self.height-1);
        }else {
            self.segmentScrollView.contentSize = CGSizeMake(self.width, self.height-1);
        }
        
        CGFloat titleSpace = (screenWidth-totalTitleWidth)/(2*segmentTitleArr.count);
        
        for (int i = 0; i<segmentTitleArr.count; i++) {
            if ([segmentTitleArr[i] isKindOfClass:[NSString class]]) {
                CGFloat lastBtnX = 0;
                CGFloat lastBtnW = 0;
                if (self.btnArr.count>0) {
                    UIButton *lastBtn = [self.btnArr lastObject];
                    lastBtnX = CGRectGetMaxX(lastBtn.frame);
                    lastBtnW = CGRectGetWidth(lastBtn.frame);
                }
                
                CGFloat titleWidth = [segmentTitleArr[i] widthWithFont:CUSTOMEFONT(16) constrainedToHeight:self.segmentScrollView.height];
                CGFloat btnW = 0;
                if (totalWidth > screenWidth) {
                    btnW = btnSpace + titleWidth + btnSpace;
                }else {
                    btnW = titleSpace + titleWidth + titleSpace;
                }
                
                UIButton *btn = [self btnWithTitle:segmentTitleArr[i] titleFont:CUSTOMEFONT(16) titleColor:UIColorFromRGBA(0xff2c2c2c) btnTag:i];
                btn.frame = CGRectMake(lastBtnX, 0, btnW, self.height);
                [self.segmentScrollView addSubview:btn];
                
                UIView *bageView = [self bageViewWithBtn:btn btnIndex:i];
                [self.segmentScrollView addSubview:bageView];
                if (i == 0) {
                    self.moveView.centerX = btn.centerX;
                    self.currentSegmentBtn = btn;
                    [btn setTitleColor:UIColorFromRGBA(0xff4183FE) forState:UIControlStateNormal];
                    btn.titleLabel.font = SemiboldFont(16);
                }
                [self.btnArr addObject:btn];
                [self.bageViewArr addObject:bageView];
            }
        }
    }
    [self addSubview:self.linView];
}

- (UIButton *)btnWithTitle:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor btnTag:(int)btnTag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    btn.tag             = btnTag;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)bageViewWithBtn:(UIButton *)btn btnIndex:(int)btnIndex{
    CGSize labelSize = [btn.titleLabel.text sizeWithFont:CUSTOMEFONT(16) constrainedToHeight:22];
    CGFloat labelX = (btn.x + btn.width) - (btn.frame.size.width-labelSize.width)/2 + 5/2;
    CGFloat labelY = (btn.frame.size.height-labelSize.height)/2 - 5/2;
    UIView *bageView = [[UIView alloc] initWithFrame:CGRectMake(labelX, labelY, 5, 5)];
    bageView.backgroundColor = UIColorFromRGBA(0xffFF7A66);
    bageView.layer.cornerRadius = bageView.height*0.5;
    bageView.layer.masksToBounds = YES;
    bageView.tag = btnIndex+10000;
    bageView.hidden = YES;
    return bageView;
}

- (void)updateBageViewHidenOrShow:(int)btnIndex {
    if (self.bageViewArr.count>0) {
        [self.bageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *bageView = (UIView *)obj;
            if (bageView.tag == (btnIndex+10000)) {
                bageView.hidden = NO;
            }else {
                bageView.hidden = YES;
            }
        }];
    }
}

- (void)showBageView:(int)btnIndex {
    if (self.bageViewArr.count>0) {
        [self.bageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *bageView = (UIView *)obj;
            if (bageView.tag == (btnIndex+10000)) {
                bageView.hidden = NO;
            }
        }];
    }
}

- (void)hideBageView:(int)btnIndex {
    if (self.bageViewArr.count>0) {
        [self.bageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *bageView = (UIView *)obj;
            if (bageView.tag == (btnIndex+10000)) {
                bageView.hidden = YES;
            }
        }];
    }
}

- (void)hideAllBageView {
    if (self.bageViewArr.count>0) {
        [self.bageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *bageView = (UIView *)obj;
            bageView.hidden = YES;
        }];
    }
}

- (void)buttonClick:(UIButton *)sender {
    
    [self updateSegmentViewStatus:(int)sender.tag];
    if (self.btnDidBlock) {
        self.btnDidBlock((int)sender.tag);
    }
}

- (void)updateSegmentViewStatus:(int)index {
    if ( self.btnArr.count>0) {
        self.currentSegmentBtn = self.btnArr[index];
        GW_WEAKSELF;
        [self.btnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == weakSelf.currentSegmentBtn.tag) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.moveView.centerX = btn.centerX;
                }];
                [btn setTitleColor:UIColorFromRGBA(0xff4183FE) forState:UIControlStateNormal];
                btn.titleLabel.font = SemiboldFont(16);
            }else {
                [btn setTitleColor:UIColorFromRGBA(0xff2c2c2c) forState:UIControlStateNormal];
                btn.titleLabel.font = CUSTOMEFONT(16);
            }
        }];
        if (self.currentSegmentBtn.right > screenWidth) {
            self.segmentScrollView.contentOffset = CGPointMake(self.currentSegmentBtn.right - screenWidth, 0);
        }else {
            self.segmentScrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}
@end
