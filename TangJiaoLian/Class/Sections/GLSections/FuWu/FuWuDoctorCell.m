//
//  FuWuDoctorCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuDoctorCell.h"

@implementation FuWuDoctorCell

- (void)createUI
{
    [self.contentView addSubview:self.headIV];
    [self.contentView addSubview:self.nameLbl];
    [self.contentView addSubview:self.jobLbl];
    [self.contentView addSubview:self.hospital];
    
    WS(ws);
    
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView).offset(17);
        make.centerY.equalTo(ws.contentView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.headIV.mas_right).offset(12);
        make.top.equalTo(ws.contentView).offset(13.5);
    }];
    
    [self.jobLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.nameLbl).offset(12);
        make.top.equalTo(ws.nameLbl.mas_bottom).offset(5);
    }];
    
    [self.hospital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.jobLbl.mas_bottom).offset(5);
        make.left.equalTo(ws.jobLbl);
    }];
}

- (UIImageView *)headIV
{
    if (!_headIV) {
        _headIV               = [[UIImageView alloc]initWithImage:GL_IMAGE(@"医生默认头像")];
        _headIV.cornerRadius  = 70/2;
        _headIV.masksToBounds = true;
    }
    return _headIV;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl) {
        _nameLbl           = [UILabel new];
        _nameLbl.font      = GL_FONT(14);
        _nameLbl.textColor = TCOL_NORMALETEXT;
    }
    return _nameLbl;
}

- (UILabel *)jobLbl
{
    if (!_jobLbl) {
        _jobLbl           = [UILabel new];
        _jobLbl.font      = GL_FONT(14);
        _jobLbl.textColor = TCOL_SUBHEADTEXT;
    }
    return _jobLbl;
}

- (UILabel *)hospital
{
    if (!_hospital) {
        _hospital           = [UILabel new];
        _hospital.font      = GL_FONT(14);
        _hospital.textColor = TCOL_SUBHEADTEXT;
    }
    return _hospital;
}


@end
