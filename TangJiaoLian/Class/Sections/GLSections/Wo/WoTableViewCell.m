//
//  WoTableViewCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/22.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoTableViewCell.h"

@implementation WoTableViewCell

- (void)setEntity:(id)entity
{
    _iconIV.image  = GL_IMAGE([entity valueForKey:@"imgStr"]);
    _titleLbl.text = [entity valueForKey:@"titleStr"];
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightArrowIV];
    
    WS(ws);
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.contentView).offset(32);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.left.equalTo(ws.iconIV.mas_right).offset(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(49.5, 0, 0, 0));
    }];
    
    [self.rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView).offset(-28);
        make.centerY.equalTo(ws.contentView);
    }];
}


- (UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV = [UIImageView new];
    }
    return _iconIV;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl           = [UILabel new];
        _titleLbl.font      = GL_FONT(16);
        _titleLbl.textColor = TCOL_NORMALETEXT;
    }
    return _titleLbl;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView                 = [UIView new];
        _lineView.backgroundColor = TCOL_LINE;
    }
    return _lineView;
}

- (UIImageView *)rightArrowIV
{
    if (!_rightArrowIV) {
        _rightArrowIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"右箭头")];
    }
    return _rightArrowIV;
}

@end
