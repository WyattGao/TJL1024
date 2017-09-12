//
//  WearRecordCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordCell.h"

@interface WearRecordCell ()

///开始时间
@property (nonatomic,strong) UILabel *startLbl;
///结束时间
@property (nonatomic,strong) UILabel *endLbl;
///右箭头
@property (nonatomic,strong) UIImageView *rightIV;



@end

@implementation WearRecordCell

- (void)setEntity:(id)entity
{
    WearRecordEntity *recordEntity = (WearRecordEntity *)entity;
    _startLbl.text                 = [[recordEntity.starttime toDateDefault] toString:@"yyyy-MM-dd\nHH:mm:ss"];
    _endLbl.text                   = [[recordEntity.endtime toDateDefault]   toString:@"yyyy-MM-dd\nHH:mm:ss"];
}

- (void)createUI
{
    if (!([self.reuseIdentifier integerValue] % 2)) {
        self.contentView.backgroundColor = TCOL_BG;
    } else {
        self.contentView.backgroundColor = TCOL_HISTORYCELL;
    }
    
    [self.contentView addSubview:self.startLbl];
    [self.contentView addSubview:self.endLbl];
    [self.contentView addSubview:self.dataAnalysisBtn];
    [self.contentView addSubview:self.detailedRecordBtn];
    [self.contentView addSubview:self.rightIV];
    
    WS(ws);
    
    
    [self.startLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH/4);
        make.left.equalTo(ws.contentView).offset(0);
    }];
    
    [self.endLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView).offset(SCREEN_WIDTH/4);
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(ws.startLbl);
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView).offset(-9.9);
        make.centerY.equalTo(ws.contentView);
    }];
    
    [self.dataAnalysisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(GL_IP6_W_RATIO(216));
    }];
    
    [self.detailedRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(GL_IP6_W_RATIO(303));
    }];
}

- (UILabel *)startLbl
{
    if (!_startLbl) {
        _startLbl               = [UILabel new];
        _startLbl.font          = GL_FONT(12);
        _startLbl.textColor     = TCOL_SUBHEADTEXT;
        _startLbl.textAlignment = NSTextAlignmentCenter;
        _startLbl.numberOfLines = 2;
    }
    return _startLbl;
}

- (UILabel *)endLbl
{
    if (!_endLbl) {
        _endLbl               = [UILabel new];
        _endLbl.font          = GL_FONT(12);
        _endLbl.textColor     = TCOL_SUBHEADTEXT;
        _endLbl.textAlignment = NSTextAlignmentCenter;
        _endLbl.numberOfLines = 2;
    }
    return _endLbl;
}

- (UIImageView *)rightIV
{
    if (!_rightIV) {
        _rightIV        = [[UIImageView alloc]initWithImage:GL_IMAGE(@"右箭头")];
        _rightIV.hidden = true;
    }
    return _rightIV;
}

- (GLButton *)dataAnalysisBtn
{
    if (!_dataAnalysisBtn) {
        _dataAnalysisBtn = [GLButton new];
        [_dataAnalysisBtn setImage:GL_IMAGE(@"数据分析") forState:UIControlStateNormal];
        _dataAnalysisBtn.graphicLayoutState = PICCENTER;
        _dataAnalysisBtn.tag = 50 + [self.reuseIdentifier integerValue];
    }
    return _dataAnalysisBtn;
}

- (GLButton *)detailedRecordBtn
{
    if (!_detailedRecordBtn) {
        _detailedRecordBtn = [GLButton new];
        [_detailedRecordBtn setImage:GL_IMAGE(@"详细记录") forState:UIControlStateNormal];
        _detailedRecordBtn.graphicLayoutState = PICCENTER;
        _detailedRecordBtn.tag = 500 + [self.reuseIdentifier integerValue];
    }
    return _detailedRecordBtn;
}

@end
