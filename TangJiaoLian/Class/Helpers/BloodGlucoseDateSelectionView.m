//
//  BloodGlucoseDateSelectionView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "BloodGlucoseDateSelectionView.h"

BloodGlucoseDateSelectionView *bloodGlucoseDateSelectionView;

@implementation BloodGlucoseDateSelectionView

- (void)showInView:(UIView *)view
{
    self.isShow = true;
    
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];

    self.mainView.y = -64;
    
    WS(ws);
    
    [UIView animateWithDuration:0.3f animations:^{
        ws.mainView.y = 0;
    }];
}

- (void)dismiss
{
    self.isShow = false;
    WS(ws);
    [UIView animateWithDuration:0.3f animations:^{
        ws.mainView.y = -64;
    } completion:^(BOOL finished) {
        [ws removeFromSuperview];
    }];
}

+ (instancetype)bloodGlucoseDateSelectionViewWithDate:(NSDate *)date
{
    bloodGlucoseDateSelectionView = [BloodGlucoseDateSelectionView new];
    if (bloodGlucoseDateSelectionView) {
        bloodGlucoseDateSelectionView.date = date;
        [bloodGlucoseDateSelectionView createUI];
    }
    return bloodGlucoseDateSelectionView;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.leftBtn];
    [self.mainView addSubview:self.rightBtn];
    [self.mainView addSubview:self.dateBtn];
    
    WS(ws);
    
    
    self.mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
    
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.mainView);
        make.top.equalTo(ws.mainView).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.dateBtn.mas_left).offset(-10);
        make.centerY.equalTo(ws.dateBtn);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.dateBtn.mas_right).offset(10);
        make.centerY.equalTo(ws.dateBtn);
    }];
    
    [self.dateBtn.lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.dateBtn).offset(8);
        make.centerY.equalTo(ws.dateBtn);
    }];
    
    [self.dateBtn.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.dateBtn).offset(-9);
        make.centerY.equalTo(ws.dateBtn);
    }];
    
    for (NSInteger i = 0;i < 3;i++) {
        GLButton *timeRangeBtn = [GLButton new]; /**< 时间区间按钮 */
        [self.mainView addSubview:timeRangeBtn];
        
        [timeRangeBtn setTitle:@[@"3天内",@"5天内",@"本次佩戴"][i] forState:UIControlStateNormal];
        [timeRangeBtn setTitleColor:TCOL_WHITETEXT forState:UIControlStateSelected];
        [timeRangeBtn setFont:GL_FONT(14)];
        [timeRangeBtn setBackgroundColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [timeRangeBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [timeRangeBtn setCornerRadius:5];
        [timeRangeBtn setBorderWidth:1];
        [timeRangeBtn setBorderColor:TCOL_MAIN];
        
        [timeRangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mainView).offset(GL_IP6_W_RATIO(19 + (100 + 19) * i));
            make.size.mas_equalTo(CGSizeMake(GL_IP6_W_RATIO(100), 30));
            make.top.equalTo(ws.mainView).offset(80);
        }];
    }
}

- (GLView *)mainView
{
    if (!_mainView) {
        _mainView                 = [GLView new];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (GLButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [GLButton new];
        [_leftBtn setImage:GL_IMAGE(@"前一天") forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (GLButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [GLButton new];
        [_rightBtn setImage:GL_IMAGE(@"后一天") forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (GLButton *)dateBtn
{
    if (!_dateBtn) {
        _dateBtn = [GLButton new];
        
        [_dateBtn setImage:GL_IMAGE(@"日历黑") forState:UIControlStateNormal];
        [_dateBtn setFont:GL_FONT_BY_NAME(@"Courier", 14)]; //等宽字体
        [_dateBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_dateBtn setCornerRadius:5];
        [_dateBtn setBorderWidth:1];
        [_dateBtn setBorderColor:TCOL_MAIN];
        [_dateBtn setTitle:[self.date toString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    }
    return _dateBtn;
}

@end
