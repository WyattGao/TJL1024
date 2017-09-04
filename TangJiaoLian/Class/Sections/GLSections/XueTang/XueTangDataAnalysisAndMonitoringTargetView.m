//
//  XueTangDataAnalysisAndMonitoringTargetView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/17.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDataAnalysisAndMonitoringTargetView.h"

@implementation XueTangDataAnalysisAndMonitoringTargetView

- (void)realodTargetData
{
    GL_DISPATCH_MAIN_QUEUE(^{
        NSString *targetTitle = [NSString stringWithFormat:@"%@~%@",[GL_USERDEFAULTS getStringValue:SamTargetLow],[GL_USERDEFAULTS getStringValue:SamTargetHeight]];
        if (![[GL_USERDEFAULTS getStringValue:SamTargetLow] length]) {
            targetTitle = @"2.9~11.1";
        }
        [self.monitoringTargetBtn setTitle:targetTitle forState:UIControlStateNormal];
    });
}

- (void)tagertBtnClick:(UIButton *)sender
{
    if (_tagertBtnClick) {
        _tagertBtnClick();
    }
}

- (void)dataAnalysisBtnClick:(UIButton *)sneder
{
    
    if (_dataBtnClick) {
        _dataBtnClick();
    }
}

- (void)createUI
{
    [self realodTargetData];
    
    [self addSubview:self.dataAnalysisBtn];
    [self addSubview:self.monitoringTargetBtn];
    [self addSubview:self.verticalLine];
    [self addSubview:self.topHorizontalLine];
    [self addSubview:self.bomHorizontalLine];
    
    WS(ws);
    
    [self.dataAnalysisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws);
        make.left.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 86));
    }];
    
    [self.monitoringTargetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws);
        make.right.equalTo(ws.mas_right);
        make.size.equalTo(ws.dataAnalysisBtn);
    }];
    
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 86));
        make.center.equalTo(ws);
    }];
    
    [self.bomHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.bottom.equalTo(ws.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    [self.topHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
}

- (GLButton *)dataAnalysisBtn
{
    if (!_dataAnalysisBtn) {
        _dataAnalysisBtn = [GLButton new];
        [_dataAnalysisBtn setImage:GL_IMAGE(@"数据分析") forState:UIControlStateNormal];
        [_dataAnalysisBtn setTitle:@"数据分析" forState:UIControlStateNormal];
        [_dataAnalysisBtn setFont:GL_FONT(14)];
        [_dataAnalysisBtn setTitleColor:TCOL_NORMALETEXT forState:UIControlStateNormal];
        [_dataAnalysisBtn setGraphicLayoutState:PICTOP];
        [_dataAnalysisBtn setGraphicLayoutSpacing:10];
        [_dataAnalysisBtn addTarget:self action:@selector(dataAnalysisBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dataAnalysisBtn;
}

- (GLButton *)monitoringTargetBtn
{
    if (!_monitoringTargetBtn) {
        _monitoringTargetBtn = [GLButton new];
        UILabel *lbl         = [UILabel new];

        [_monitoringTargetBtn addSubview:lbl];
        
        [_monitoringTargetBtn setFont:GL_FONT(20)];
        [_monitoringTargetBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_monitoringTargetBtn addTarget:self action:@selector(tagertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        lbl.text      = @"监测目标(mmol/L)";
        lbl.font      = GL_FONT(14);
        lbl.textColor = TCOL_NORMALETEXT;
        
        [_monitoringTargetBtn.lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_monitoringTargetBtn).offset(20.5);
            make.centerX.equalTo(_monitoringTargetBtn);
        }];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_monitoringTargetBtn.lbl.mas_bottom).offset(2);
            make.centerX.equalTo(_monitoringTargetBtn);
        }];
        
    }
    return _monitoringTargetBtn;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = TCOL_LINE;
    }
    return _verticalLine;
}

- (UIView *)topHorizontalLine
{
    if (!_topHorizontalLine) {
        _topHorizontalLine = [UIView new];
        _topHorizontalLine.backgroundColor = TCOL_LINE;
    }
    return _topHorizontalLine;
}

- (UIView *)bomHorizontalLine
{
    if (!_bomHorizontalLine) {
        _bomHorizontalLine                 = [UIView new];
        _bomHorizontalLine.backgroundColor = TCOL_LINE;
    }
    return _bomHorizontalLine;
}

@end
