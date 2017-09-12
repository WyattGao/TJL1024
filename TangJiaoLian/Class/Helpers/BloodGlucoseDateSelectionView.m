//
//  BloodGlucoseDateSelectionView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "BloodGlucoseDateSelectionView.h"

typedef NS_ENUM(NSInteger,DateInterval) {
    DateIntervalThreeDays = 0,/**< 3天 */
    DateIntervalFiveDays,     /**< 5天 */
    DateIntervalThisTime      /**< 本次 */
};

BloodGlucoseDateSelectionView *bloodGlucoseDateSelectionView;

@interface BloodGlucoseDateSelectionView ()<SelecteDateDelegate>

@property (nonatomic,copy  ) NSDate *startDate;

@property (nonatomic,copy  ) NSDate *endDate;

@end

@implementation BloodGlucoseDateSelectionView

- (void)realodLeftRightButtonState
{
    NSDate *changeDate     = [self.dateBtn.text toDate:@"yyyy-MM-dd"];
    self.leftBtn.selected  = [changeDate minutesAfterDate:[self.startDate dateAtStartOfDay]] == 0;
    self.rightBtn.selected = [changeDate minutesBeforeDate:[self.endDate dateAtStartOfDay]] == 0;
}

#pragma mark -  SelecteDateDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    NSDate *startDate = date;
    NSDate *endDate   = [date dateByAddingDays:1];
    self.dateBtn.text = [date toString:@"yyyy-MM-dd"];
    [self realodLeftRightButtonState];
    self.timeSelected(startDate, endDate);
}

#pragma mark - buttonClick
- (void)dateBtnClick:(GLButton *)sender
{
    [self.selectDeteView show];
}

//3天5天本次按钮点击事件
- (void)timeRangeBtnClick:(GLButton *)sender
{
    if (!sender.selected) {
        for (NSInteger i = 0;i < 3;i++) {
            GLButton *timeRangeBtn = [self viewWithTag:50+i];
            if (timeRangeBtn != sender) {
                [UIView animateWithDuration:0.3f animations:^{
                    timeRangeBtn.selected = false;
                }];
            }
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            sender.selected = true;
        }];
        
        NSDate *endDate = self.endDate;
        switch (sender.tag - 50) {
            case DateIntervalThreeDays:
                endDate = [self.endDate dateByAddingDays:3];
                break;
            case DateIntervalFiveDays:
                endDate = [self.endDate dateByAddingDays:5];
                break;
            case DateIntervalThisTime:
                endDate = self.endDate;
                break;
            default:
                break;
        }
        if ([endDate minutesAfterDate:self.startDate] > 0) {
            endDate = self.endDate;
        }
        self.timeSelected(self.startDate, endDate);
    }
}

//左右箭头事件切换事件
- (void)leftRightBtnClick:(GLButton *)sender
{
    NSDate *changeDate = [NSDate date];
    if (sender == self.leftBtn) {
        changeDate = [[self.dateBtn.text toDate:@"yyyy-MM-dd"] dateByAddingDays:-1];
    } else {
        changeDate = [[self.dateBtn.text toDate:@"yyyy-MM-dd"] dateByAddingDays:1];
    }
    
    //修改的日期必须大于等于最小日期并且小于等于最大日期
    if ([changeDate minutesAfterDate:[self.startDate dateAtStartOfDay]]>= 0&&[changeDate minutesBeforeDate:[self.endDate dateAtStartOfDay]]>= 0) {
        self.dateBtn.text      = [changeDate toString:@"yyyy-MM-dd"];
        
        [self realodLeftRightButtonState];
        
        NSDate *startDate = changeDate;
        NSDate *endDate   = [changeDate dateByAddingDays:1];
        //如果和开始或者结束日期是同一天，但时分秒不同，则返回传入的开始和结束时的时间
        if ([endDate minutesAfterDate:self.endDate] > 0) {
            endDate = self.endDate;
        }
        if([startDate minutesBeforeDate:self.startDate] > 0) {
            startDate = self.startDate;
        }
        self.timeSelected(startDate, endDate);
    }
}

- (void)showInView:(UIView *)view
{
    self.isShow = true;
    
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(64, 0, SCREEN_HEIGHT - (64 + SCREEN_HEIGHT - 130) , 0));
    }];

    self.mainView.y = -130;
    
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
        ws.mainView.y = -130;
    } completion:^(BOOL finished) {
        [ws removeFromSuperview];
    }];
}

+ (instancetype)bloodGlucoseDateSelectionViewWithStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
{
    bloodGlucoseDateSelectionView = [BloodGlucoseDateSelectionView new];
    if (bloodGlucoseDateSelectionView) {
        bloodGlucoseDateSelectionView.endDate = endDate;
        bloodGlucoseDateSelectionView.startDate  = startDate;
        [bloodGlucoseDateSelectionView createUI];
    }
    return bloodGlucoseDateSelectionView;
}

- (void)createUI
{
    self.backgroundColor        = [UIColor clearColor];
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
        [timeRangeBtn setFont:GL_FONT(14)];
        [timeRangeBtn setBackgroundColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [timeRangeBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateSelected];
        [timeRangeBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [timeRangeBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
        [timeRangeBtn setCornerRadius:5];
        [timeRangeBtn setBorderWidth:1];
        [timeRangeBtn setBorderColor:TCOL_MAIN];
        [timeRangeBtn setTag:50+i];
        if (i == 2) {
            timeRangeBtn.selected = self;
        }
        [timeRangeBtn addTarget:self action:@selector(timeRangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
        _mainView                        = [GLView new];
        _mainView.backgroundColor        = [UIColor whiteColor];
        //设置阴影效果
        _mainView.layer.shadowColor      = RGBA(0, 0, 0, 0.25).CGColor;
        _mainView.layer.shadowOffset     = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _mainView.layer.shadowOpacity    = 5;
    }
    return _mainView;
}

- (GLButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [GLButton new];
        [_leftBtn setImage:GL_IMAGE(@"前一天") forState:UIControlStateNormal];
        [_leftBtn setImage:GL_IMAGE(@"前一天-灰") forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(leftRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setSelected:true];
    }
    return _leftBtn;
}

- (GLButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [GLButton new];
        [_rightBtn setImage:GL_IMAGE(@"后一天") forState:UIControlStateNormal];
        [_rightBtn setImage:GL_IMAGE(@"后一天-灰") forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(leftRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.startDate dateAtStartOfDay] isEqualToDate:[self.endDate dateAtStartOfDay]]) {
            [_rightBtn setSelected:true];
        }
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
        [_dateBtn setTitle:[self.startDate toString:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [_dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateBtn;
}

- (STSelectDateView *)selectDeteView
{
    if (!_selectDeteView) {
        _selectDeteView = [[STSelectDateView alloc]initWithType:Default];
        _selectDeteView.delegate = self;
        _selectDeteView.datePicker.minimumDate = self.startDate;
        _selectDeteView.datePicker.maximumDate = self.endDate;
    }
    return _selectDeteView;
}

@end
