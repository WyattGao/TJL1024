//
//  RingTimeHelpCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/6.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RingTimeHelpCell.h"

@implementation RingTimeHelpCell

- (void)createUI
{
    [self.contentView addSubview:self.hintLbl];
    [self.contentView addSubview:self.pointIV];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(10);
        make.left.equalTo(ws.pointIV.mas_right).offset(10);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(SCREEN_WIDTH - 41 - 20);
    }];
    
    [self.pointIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView).offset(21);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.top.equalTo(ws.hintLbl.mas_top).offset(3);
    }];

}

- (UIImageView *)pointIV
{
    if (!_pointIV) {
        _pointIV = [UIImageView new];
        [_pointIV setBackgroundColor:TCOL_RINGTIMENOR];
        [_pointIV setCornerRadius:10/2];
    }
    return _pointIV;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = RGB(51, 51, 51);
        _hintLbl.textAlignment = NSTextAlignmentLeft;
        _hintLbl.numberOfLines = 0;
    }
    return _hintLbl;
}

@end
