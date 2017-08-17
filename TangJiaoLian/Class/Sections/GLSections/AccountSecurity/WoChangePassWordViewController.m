//
//  WoChangePassWordViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePassWordViewController.h"
#import "WoChangePassWordTableView.h"
#import "WoChangePassWordWihPhoneFinishViewController.h"

@interface WoChangePassWordViewController ()

@property (nonatomic,strong) WoChangePassWordTableView *mainTV;

@property (nonatomic,strong) GLNextBtn *nextBtn;

@property (nonatomic,strong) WoChangePassWordWihPhoneFinishViewController *finishVC;

@end

@implementation WoChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self.view setBackgroundColor:TCOL_BGGRAY];
    
    [self setNavTitle:@"修改密码"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.mainTV];
    [self addSubView:self.nextBtn];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(21 + 64);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mainTV.mas_bottom).offset(102);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 40));
        make.centerX.equalTo(ws.view);
    }];
}

- (void)nextBtnClick:(GLButton *)sender
{
    
}

- (WoChangePassWordTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [WoChangePassWordTableView new];
    }
    return _mainTV;
}

- (GLNextBtn *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[GLNextBtn alloc]initWithType:GLNextBtnNormalType];
        
        WS(ws);
        
        _nextBtn.glNextBtnClick = ^{
            NSString *passWordStr = [ws.mainTV getNewPassWord];
            if (!passWordStr) {
                return;
            }
            NSDictionary *postDic = @{
                                      FUNCNAME : @"editPwd",
                                      INFIELD  : @{
                                              @"ACCOUNT" : USER_ACCOUNT,
                                              @"PHONE"   : [GL_USERDEFAULTS getStringValue:@"PHONE"],
                                              @"NEWPASSWORD" : passWordStr,
                                              @"DEVICE" : @"1"
                                              }
                                      };
            [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                if (GETTAG) {
                    if (GETRETVAL) {
                        [ws pushWithController:ws.finishVC];
                    } else {
                        GL_ALERT_E(GETRETMSG);
                    }
                } else {
                    GL_ALERT_E(GETMESSAGE);
                }
            } failure:^(GLRequest *request, NSError *error) {
                
            }];
        };
    }
    return _nextBtn;
}

- (WoChangePassWordWihPhoneFinishViewController *)finishVC
{
    if (!_finishVC) {
        _finishVC = [WoChangePassWordWihPhoneFinishViewController new];
    }
    return _finishVC;
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
