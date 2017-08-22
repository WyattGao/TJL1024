//
//  XueTangShiShiXueTangView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangShiShiXueTangView.h"
#import "XueTangZhiEntity.h"

@interface XueTangShiShiXueTangView ()

@property (nonatomic,strong) XueTangZhiEntity *entity;


@end

@implementation XueTangShiShiXueTangView

- (instancetype)initWithModel:(GLEntity *)entity
{
    self = [super initWithModel:entity];
    if (self) {
        _entity = (XueTangZhiEntity *)entity;
    }
    return self;
}

- (void)connectSwitchClick:(UISwitch *)sender
{
    if (_connectSwitchClick) {
        _connectSwitchClick(sender.isOn);
    }
    if (sender.on) {
        sender.on = false;
    }
}

- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    [self addSubview:self.connectSwitch];
    [self addSubview:self.connectStateLbl];
    [self addSubview:self.tendencyBtn];
    [self addSubview:self.ringView];
    
    WS(ws);
    
    [self.connectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(15);
        make.top.equalTo(ws).offset(15);
    }];
    
    [self.connectStateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.connectSwitch.mas_right).offset(12);
        make.centerY.equalTo(ws.connectSwitch);
    }];
    
    [self.tendencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.connectSwitch);
        make.right.equalTo(ws.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
    
    [self.ringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(50);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 240));
    }];
}

- (UIButton *)tendencyBtn
{
    if (!_tendencyBtn) {
        _tendencyBtn = [UIButton new];
        [_tendencyBtn.titleLabel setFont:GL_FONT(12)];
        [_tendencyBtn setTitleColor:TCOL_WHITETEXT forState:UIControlStateNormal];
        [_tendencyBtn setCornerRadius:13];
        [_tendencyBtn setBackgroundColor:TCOL_MAIN];
        if (ISBINDING) {
            [self.tendencyBtn setTitle:@"详细记录" forState:UIControlStateNormal];
        } else {
            [self.tendencyBtn setTitle:@"趋势图" forState:UIControlStateNormal];
        }
    }
    return _tendencyBtn;
}

- (UILabel *)connectStateLbl
{
    if (!_connectStateLbl) {
        _connectStateLbl = [UILabel new];
        if (ISBINDING) {
            _connectStateLbl.text = @"监测：开";
        } else {
            _connectStateLbl.text = @"监测：关";
        }
        _connectStateLbl.textColor = TCOL_NORMALETEXT;
        _connectStateLbl.font      = GL_FONT(15);
    }
    return _connectStateLbl;
}

- (UISwitch *)connectSwitch
{
    if (!_connectSwitch) {
        _connectSwitch = [UISwitch new];
        _connectSwitch.onTintColor = TCOL_MAIN;
        [_connectSwitch addTarget:self action:@selector(connectSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        if (ISBINDING) {
            [_connectSwitch setOn:true];
        }
    }
    return _connectSwitch;
}

- (void)reloadViewbyBinDingState
{
    if (ISBINDING) {
        self.connectStateLbl.text = @"监测：开";
        [self.tendencyBtn setTitle:@"详细记录" forState:UIControlStateNormal];
        [_connectSwitch setOn:true];
    } else {
        _connectStateLbl.text = @"监测：关";
        [self.tendencyBtn setTitle:@"趋势图" forState:UIControlStateNormal];
        [_connectSwitch setOn:false];
    }
}

- (XueTangRingTimeView *)ringView
{
    if (!_ringView) {
        _ringView = [XueTangRingTimeView new];
    }
    return _ringView;
}

@end
