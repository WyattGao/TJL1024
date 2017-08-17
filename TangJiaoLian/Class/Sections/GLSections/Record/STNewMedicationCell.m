//
//  STNewMedicationCell.m
//  SuiTangNew
//
//  Created by 房克志 on 16/8/16.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "STNewMedicationCell.h"

@implementation STNewMedicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    WS(ws);
    _titLab = [UILabel new];
    _titLab.font = GL_FONT(15);
    [ws.contentView addSubview:_titLab];
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView).offset(-90);
    }];
    _iconImgView  = [UIImageView new];
    _iconImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureClick:)];
    [_iconImgView addGestureRecognizer:gesture];
    [ws.contentView addSubview:_iconImgView];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView).offset(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    UILabel *lineLab = [UILabel new];
    [ws.contentView addSubview:lineLab];
    lineLab.backgroundColor = RGB(212, 212, 212);
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.equalTo(ws.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-24, 0.5));
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)gestureClick:(UITapGestureRecognizer *)gesture
{
    _iconBlock((UIImageView *)gesture.view);
}

@end
