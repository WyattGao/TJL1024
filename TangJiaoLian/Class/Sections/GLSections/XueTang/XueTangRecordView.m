//
//  XueTangRecordView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/17.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangRecordView.h"

@implementation XueTangRecordView

- (void)realodTargetData
{
    self.targetLbl.text = [NSString stringWithFormat:@"%@~%@",[GL_USERDEFAULTS getStringValue:SamTargetLow],[GL_USERDEFAULTS getStringValue:SamTargetHeight]];
}

- (void)realodRecordBtnStatus:(GLRecordBtnStatus)status WithType:(GLRecordType)type
{
    XueTangRecordBtn *btn = [self viewWithTag:10 + type];
    [btn setStatus:status];
}

- (void)createUI
{
    XueTangRecordBtn *referenceBtn = [XueTangRecordBtn new];
    XueTangRecordBtn *targetBtn    = [XueTangRecordBtn new];
    UILabel  *targetHintLbl        = [UILabel new];
    
    [self addSubview:referenceBtn];
    [self addSubview:targetBtn];
    [targetBtn addSubview:self.targetLbl];
    [targetBtn addSubview:targetHintLbl];
    [self addSubview:self.cutLine];
    [self addSubview:self.cutLbl];
    
    referenceBtn.tag   = 10 + GLRecordBloodType;
    [referenceBtn setTitle:@"参比血糖" forState:UIControlStateNormal];
    [referenceBtn setImage:GL_IMAGE(@"记录参比血糖") forState:UIControlStateNormal];
    [referenceBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];

    targetBtn.tag           = 10 + GLRecordTarget;
    targetBtn.selected      = true;
    targetHintLbl.text      = @"监测目标 (mmol/L)";
    targetHintLbl.font      = GL_FONT(14);
    targetHintLbl.textColor = TCOL_HOMETEXTCOLOR;
    [targetBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    
    WS(ws);
    
    [referenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws).offset(GL_IP6_W_RATIO(10));
        make.top.equalTo(ws).offset(30);
        make.size.mas_equalTo(CGSizeMake(GL_IP6_W_RATIO(172), GL_IP6_H_RATIO(80)));
    }];
    
    [targetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws).offset(GL_IP6_W_RATIO(-10));
        make.top.equalTo(referenceBtn);
        make.size.equalTo(referenceBtn);
    }];
    
    [self.targetLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(targetBtn);
        make.centerY.equalTo(referenceBtn.iv);
    }];
    
    [targetHintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referenceBtn.lbl);
        make.centerX.equalTo(ws.targetLbl);
    }];
    
    [self.cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(referenceBtn.mas_bottom).offset(21);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 2));
        make.centerX.equalTo(ws);
    }];
    
    [self.cutLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.width.mas_equalTo(56 + 8.5 * 2);
        make.centerY.equalTo(ws.cutLine);
    }];
    
    for (NSInteger i = 0;i < 4;i++) {
        XueTangRecordBtn *btn = [XueTangRecordBtn new];
        [self addSubview:btn];
        [btn setTitle:@[@"饮食",@"用药",@"胰岛素",@"运动"][i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@[@"记录饮食",@"记录用药",@"记录胰岛素",@"记录运动"][i]] forState:UIControlStateNormal];
        [btn setTag:10 + i + 1];
        [btn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnWidth = (SCREEN_WIDTH - 50)/4;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(btnWidth,btnWidth));
            make.left.equalTo(ws).offset(10 + (btnWidth + 10) *i);
            make.top.equalTo(ws.cutLine.mas_bottom).offset(21.5);
        }];
    }
    
    [self changeDisplayStatus];
}

//修改按钮的点击状态
- (void)changeDisplayStatus
{
    for (NSInteger i = 0;i < 5;i++) {
        XueTangRecordBtn *btn = [self viewWithTag:10 + i];
        if (ISBINDING) {
            btn.userInteractionEnabled = true;
            btn.selected               = true;
        } else {
            btn.userInteractionEnabled = false;
            btn.selected               = false;
        }
    }
}


- (void)recordClick:(XueTangRecordBtn *)sender
{
    if (_recordViewClick) {
        self.recordViewClick(sender.tag - 10);
    }
}

- (UILabel *)targetLbl
{
    if (!_targetLbl) {
        _targetLbl               = [UILabel new];
        _targetLbl.text          = [NSString stringWithFormat:@"%@~%@",[GL_USERDEFAULTS getStringValue:SamTargetLow],[GL_USERDEFAULTS getStringValue:SamTargetHeight]];
        _targetLbl.font          = GL_FONT(24);
        _targetLbl.textColor     = TCOL_HOMETEXTCOLOR;
        _targetLbl.textAlignment = NSTextAlignmentCenter;
        
    }
    return _targetLbl;
}

- (UILabel *)cutLbl
{
    if (!_cutLbl) {
        _cutLbl                 = [UILabel new];
        _cutLbl.text            = @"行为记录";
        _cutLbl.textColor       = TCOL_RECORDCUTCOLOR;
        _cutLbl.font            = GL_FONT(14);
        _cutLbl.backgroundColor = TCOL_BG;
        _cutLbl.textAlignment   = NSTextAlignmentCenter;
    }
    return _cutLbl;
}

- (UIView *)cutLine
{
    if (!_cutLine) {
        _cutLine                 = [UIView new];
        _cutLine.backgroundColor = TCOL_RECORDCUTCOLOR;
    }
    return _cutLine;
}

@end
