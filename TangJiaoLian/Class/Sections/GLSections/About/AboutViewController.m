//
//  AboutViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navHide = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self setNavTitle:@"关于"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.logoIV];
    [self addSubView:self.versionLbl];
    
    WS(ws);
    
    [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(100 + 64);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.logoIV.mas_bottom).offset(14);
        make.centerX.equalTo(ws.view);
    }];
}

- (UIImageView *)logoIV
{
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"Logo")];
    }
    return _logoIV;
}

- (UILabel *)versionLbl
{
    if (!_versionLbl) {
        _versionLbl           = [UILabel new];
        _versionLbl.font      = GL_FONT(14);
        _versionLbl.textColor = TCOL_SUBHEADTEXT;
        _versionLbl.text      = [NSString stringWithFormat:@"Ver. %@",GL_VERSION];
     }
    return _versionLbl;
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
