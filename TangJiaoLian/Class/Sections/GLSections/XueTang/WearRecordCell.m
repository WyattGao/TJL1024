//
//  WearRecordCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordCell.h"

@interface WearRecordCell ()

///CGM设备名称
@property (nonatomic,strong) UILabel *cgmNameLbl;
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
    _cgmNameLbl.text               = recordEntity.emittercode;
    _startLbl.text                 = recordEntity.starttime;
    _endLbl.text                   = recordEntity.endtime;
}

- (void)createUI
{
    if (!([self.reuseIdentifier integerValue] % 2)) {
        self.contentView.backgroundColor = TCOL_BG;
    } else {
        self.contentView.backgroundColor = TCOL_HISTORYCELL;
    }
    
    [self.contentView addSubview:self.cgmNameLbl];
    [self.contentView addSubview:self.startLbl];
    [self.contentView addSubview:self.endLbl];
    [self.contentView addSubview:self.rightIV];
    
    WS(ws);
    
    [self.cgmNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView);
    }];
    
    [self.startLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(79.2);
        make.centerX.equalTo(ws.contentView);
    }];
    
    [self.endLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right).offset(-GL_IP6_W_RATIO(33.5));
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(79.2);
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView).offset(-9.9);
        make.centerY.equalTo(ws.contentView);
    }];
}

- (UILabel *)cgmNameLbl
{
    if (!_cgmNameLbl) {
        _cgmNameLbl               = [UILabel new];
        _cgmNameLbl.font          = GL_FONT(14);
        _cgmNameLbl.textColor     = TCOL_SUBHEADTEXT;
        _cgmNameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _cgmNameLbl;
}

- (UILabel *)startLbl
{
    if (!_startLbl) {
        _startLbl               = [UILabel new];
        _startLbl.font          = GL_FONT(14);
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
        _endLbl.font          = GL_FONT(14);
        _endLbl.textColor     = TCOL_SUBHEADTEXT;
        _endLbl.textAlignment = NSTextAlignmentCenter;
        _endLbl.numberOfLines = 2;
    }
    return _endLbl;
}

- (UIImageView *)rightIV
{
    if (!_rightIV) {
        _rightIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"右箭头")];
    }
    return _rightIV;
}

@end
