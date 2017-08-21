//
//  LogDateHeaderView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "LogDateHeaderView.h"
#import "STSelectDateView.h"

@interface LogDateHeaderView ()<SelecteDateDelegate>

///日期左箭头
@property (nonatomic,strong) UIImageView *leftArrowIV;

///日期右箭头
@property (nonatomic,strong) UIImageView *rightArrowIV;


@property (nonatomic,strong) UILabel *titleLbl;

@property (nonatomic,strong) STSelectDateView *dateView;

///要修改日期的按钮标签
@property (nonatomic,strong) UILabel *dateBtnLbl;

@end

@implementation LogDateHeaderView

- (void)dateBtnClick:(GLButton *)sender
{
    if (sender == _leftDateBtn) {
        
    } else {
    
    }
    
    _dateBtnLbl = sender.lbl;
    
    [self.dateView show];
}

#pragma mrak - SelecteDateDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    NSDate *otherDate = [NSDate date];
    BOOL  isOverShoot = false;
    if (_dateBtnLbl ==  _leftDateBtn.lbl) {
        otherDate   = [[_rightDateBtn.lbl.text stringByAppendingString:@" 23:59:59"] toDate:@"yyyy-MM-dd HH:mm:ss +0800"];
        isOverShoot = [date timeIntervalSince1970] > [otherDate timeIntervalSince1970];
    } else if (_dateBtnLbl == _rightDateBtn.lbl){
        otherDate   = [[_leftDateBtn.lbl.text stringByAppendingString:@" 00:00:00"] toDate:@"yyyy-MM-dd HH:mm:ss +0800"];
        isOverShoot = [date timeIntervalSince1970] < [otherDate timeIntervalSince1970];
    }
    
    if (isOverShoot) {
            GL_ALERTFORVIEW(nil, @"起始日期不得大于结束日期");
    } else {
        _dateBtnLbl.text  = [date toString:@"yyyy-MM-dd"];
        
        self.dateChange();
    }
}

#pragma mark - CreateUI
- (void)createUI
{
    [self addSubview:self.leftArrowIV];
    [self addSubview:self.rightArrowIV];
    [self addSubview:self.leftDateBtn];
    [self addSubview:self.rightDateBtn];
    [self addSubview:self.titleLbl];
    
    WS(ws);
    
    [self.leftArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws).offset(15);
        make.top.equalTo(ws).offset(13);
    }];
    
    [self.rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-15);
        make.top.equalTo(ws).offset(13);
    }];
    
    [self.leftDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.leftArrowIV);
        make.left.equalTo(ws.leftArrowIV.mas_right).offset(9.3f);
    }];
    
    [self.rightDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.rightArrowIV);
        make.right.equalTo(ws.rightArrowIV.mas_left).offset(-9.3f);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
}

- (void)createData
{
    NSDate *date           = [NSDate date];
    NSString *leftDateStr  = [NSString stringWithFormat:@"%@-%@-01",[date toString:@"yyyy"],[date toString:@"MM"]];
    NSString *rightDateStr = [date toString:@"yyyy-MM-dd"];
    [self.leftDateBtn setTitle:leftDateStr forState:UIControlStateNormal];
    [self.rightDateBtn setTitle:rightDateStr forState:UIControlStateNormal];
}

- (UIImageView *)leftArrowIV
{
    if (!_leftArrowIV) {
        _leftArrowIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"切换日期左")];
    }
    return _leftArrowIV;
}

- (UIImageView *)rightArrowIV
{
    if (!_rightArrowIV) {
        _rightArrowIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"切换日期右")];
    }
    return _rightArrowIV;
}

- (GLButton *)leftDateBtn
{
    if (!_leftDateBtn) {
        _leftDateBtn           = [GLButton new];
        _leftDateBtn.font      = GL_FONT(14);
        [_leftDateBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_leftDateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftDateBtn;
}

- (GLButton *)rightDateBtn
{
    if (!_rightDateBtn) {
        _rightDateBtn           = [GLButton new];
        _rightDateBtn.font      = GL_FONT(14);
        [_rightDateBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_rightDateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightDateBtn;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl           = [UILabel new];
        _titleLbl.font      = GL_FONT(14);
        _titleLbl.textColor = TCOL_SUBHEADTEXT;
        _titleLbl.text      = @"日期范围";
    }
    return _titleLbl;
}

- (STSelectDateView *)dateView
{
    if (!_dateView) {
        _dateView          = [[STSelectDateView alloc]initWithType:Default];
        _dateView.delegate = self;
    }
    return _dateView;
}

@end
