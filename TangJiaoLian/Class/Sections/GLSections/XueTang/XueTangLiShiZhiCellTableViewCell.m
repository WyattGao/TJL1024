//
//  XueTangLiShiZhiCellTableViewCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLiShiZhiCellTableViewCell.h"

@implementation XueTangLiShiZhiCellTableViewCell

- (void)setEntity:(XueTangZhiEntity *)entity
{
    _timeLbl.text         = [[entity.collectedtime toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"MM-dd HH:mm"];
    if (!_timeLbl.text) {
        _timeLbl.text = @"暂无数据";
    }
    _bloodValueLbl.text   = entity.value;
    _currentValueLbl.text = entity.currentvalue;
}

- (void)createUI
{
    if (!([self.reuseIdentifier integerValue] % 2)) {
        self.contentView.backgroundColor = TCOL_HISTORYCELL;
    }
    
    [self.contentView addSubview:self.timeLbl];
    [self.contentView addSubview:self.bloodValueLbl];
    [self.contentView addSubview:self.currentValueLbl];
    
    WS(ws);
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView);
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    [self.bloodValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.contentView);
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    [self.currentValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right);
        make.centerY.equalTo(ws.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
}

- (UILabel *)timeLbl
{
    if (!_timeLbl) {
        _timeLbl               = [UILabel new];
        _timeLbl.font          = GL_FONT(14);
        _timeLbl.textColor     = TCOL_NORMALETEXT;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLbl;
}

- (UILabel *)bloodValueLbl
{
    if (!_bloodValueLbl) {
        _bloodValueLbl               = [UILabel new];
        _bloodValueLbl.font          = GL_FONT(14);
        _bloodValueLbl.textColor     = TCOL_NORMALETEXT;
        _bloodValueLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _bloodValueLbl;
}

- (UILabel *)currentValueLbl
{
    if (!_currentValueLbl) {
        _currentValueLbl               = [UILabel new];
        _currentValueLbl.font          = GL_FONT(14);
        _currentValueLbl.textColor     = TCOL_NORMALETEXT;
        _currentValueLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _currentValueLbl;
}

@end
