//
//  SettingsViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/9.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic,strong) UILabel *hintLbl; /**< 提示 */

@property (nonatomic,strong) UIView *audioView;
@property (nonatomic,strong) UIView *shakeView;

@property (nonatomic,strong) UILabel *audioLbl;
@property (nonatomic,strong) UILabel *shakeLbl;

@property (nonatomic,strong) UISwitch *audioSwitch;
@property (nonatomic,strong) UISwitch *shakeSwitch;

@end

@implementation SettingsViewController

- (void)audioSwitchValueChange:(UISwitch *)sender
{
    if (sender.isOn) {
        [GL_USERDEFAULTS setValue:@"2" forKey:SamIsAudio];
    } else {
        [GL_USERDEFAULTS setValue:@"1" forKey:SamIsAudio];
    }
}

- (void)shakeSwitchValueChange:(UISwitch *)sender
{
    if (sender.isOn) {
        [GL_USERDEFAULTS setValue:@"2" forKey:SamIsShake];
    } else {
        [GL_USERDEFAULTS setValue:@"1" forKey:SamIsShake];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavTitle:@"设置"];
    [self setLeftBtnImgNamed:nil];
}

- (void)createUI
{
    self.view.backgroundColor = TCOL_BGGRAY;
    
    [self.view addSubview:self.hintLbl];
    [self.view addSubview:self.audioView];
    [self.view addSubview:self.shakeView];
    [self.view addSubview:self.audioLbl];
    [self.view addSubview:self.shakeLbl];
    [self.view addSubview:self.audioSwitch];
    [self.view addSubview:self.shakeSwitch];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64 + 30);
        make.left.equalTo(ws.view).offset(20);
    }];
    
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.hintLbl.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.centerX.equalTo(ws.view);
    }];
    
    [self.shakeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.audioView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.centerX.equalTo(ws.audioView);
    }];
    
    [self.audioLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.audioView);
        make.left.equalTo(ws.audioView).offset(20);
    }];
    
    [self.shakeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.shakeView);
        make.left.equalTo(ws.audioLbl);
    }];
    
    [self.shakeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.shakeView);
        make.right.equalTo(ws.shakeView.mas_right).offset(-20);
    }];
    
    [self.audioSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.audioView);
        make.right.equalTo(ws.audioView.mas_right).offset(-20);
    }];
}

- (UIView *)audioView
{
    if (!_audioView) {
        _audioView                 = [UILabel new];
        _audioView.backgroundColor = [UIColor whiteColor];
    }
    return _audioView;
}

- (UIView *)shakeView
{
    if (!_shakeView) {
        _shakeView                 = [UILabel new];
        _shakeView.backgroundColor = [UIColor whiteColor];
    }
    return _shakeView;
}

- (UISwitch *)audioSwitch
{
    if (!_audioSwitch) {
        _audioSwitch = [UISwitch new];
        _audioSwitch.on = [GL_USERDEFAULTS getIntegerValue:SamIsAudio] == 2;
        [_audioSwitch addTarget:self action:@selector(audioSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _audioSwitch;
}

- (UISwitch *)shakeSwitch
{
    if (!_shakeSwitch) {
        _shakeSwitch = [UISwitch new];
        _shakeSwitch.on = [GL_USERDEFAULTS getIntegerValue:SamIsShake] == 2;
        [_shakeSwitch addTarget:self action:@selector(shakeSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _shakeSwitch;
}


- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl           = [UILabel new];
        _hintLbl.font      = GL_FONT_B(20);
        _hintLbl.textColor = TCOL_NORMALETEXT;
        _hintLbl.text      = @"异常提醒设置";
    }
    return _hintLbl;
}

- (UILabel *)audioLbl
{
    if (!_audioLbl) {
        _audioLbl           = [UILabel new];
        _audioLbl.font      = GL_FONT(16);
        _audioLbl.textColor = TCOL_NORMALETEXT;
        _audioLbl.text      = @"声音提醒";
    }
    return _audioLbl;
}

- (UILabel *)shakeLbl
{
    if (!_shakeLbl) {
        _shakeLbl = [UILabel new];
        _shakeLbl           = [UILabel new];
        _shakeLbl.font      = GL_FONT(16);
        _shakeLbl.textColor = TCOL_NORMALETEXT;
        _shakeLbl.text      = @"震动提醒";
    }
    return _shakeLbl;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
