//
//  WoViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoViewController.h"
#import "WoTableView.h"
#import "STPersonInfoViewController.h"
#import "LoginViewController.h"
#import "WoAccountSecurityViewController.h"
#import "HelpAndFeedBackViewController.h"
#import "AboutViewController.h"

#import "WoChangePassWordWihPhoneFinishViewController.h"
#import "MessageCenterViewController.h"
#import "SettingsViewController.h"
#import <YZBaseSDK/YZBaseSDK.h>

@interface WoViewController ()

@property (nonatomic,strong) WoTableView *mainTV;

@property (nonatomic,strong) STPersonInfoViewController *infoVC;

@property (nonatomic,strong) WoAccountSecurityViewController *accountSecurityVC; /**< 账号安全 */

@property (nonatomic,strong) HelpAndFeedBackViewController *helpAndFeedBackVC;

@property (nonatomic,strong) AboutViewController *aboutVC;

@property (nonatomic,strong) SettingsViewController *settingsVC;

@end

@implementation WoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新个人信息
    [GL_NOTIC_CENTER addObserver:self selector:@selector(changeUserInfo) name:@"changeUserInfo" object:nil];
}

- (void)changeUserInfo
{
    //刷新用户信息
    [self.mainTV.infoHeaderView refresh];
    
    if (ISLOGIN) {
        [self.mainTV.infoFooterView setHidden:false];
    } else {
        [self.mainTV.infoFooterView setHidden:true]; 
    }
}

- (void)createUI
{
    self.navHide                                          = true;
        
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.equalTo(ws.view);
    }];
}

- (WoTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [WoTableView new];
        WS(ws);
        _mainTV.infoHeaderView.editInfoClick = ^(){
            GL_DISPATCH_MAIN_QUEUE(^{
                if ([ws isLogin]) {
                    [ws pushWithController:ws.infoVC];
                }
            });
        };
        
        _mainTV.tableViewDidSelect = ^(NSIndexPath *indexPath) {
            [ws.mainTV deselectRowAtIndexPath:indexPath animated:true];
            
            if (indexPath.row != 4) {
                if (!ws.isLogin) {
                    return;
                }
            }
            switch (indexPath.row) {
                case 0://消息中心
                {
                    [ws pushWithController:[MessageCenterViewController new]];
                }
                    break;
                case 1:
                    [ws pushWithController:ws.settingsVC];
                    break;
                case 2://账号安全
                    [ws pushWithController:ws.accountSecurityVC];
                    break;
                case 3: //帮助与反馈
                    [ws pushWithController:ws.helpAndFeedBackVC];
                    break;
                case 4: //关于
                    [ws pushWithController:ws.aboutVC];
                    break;
                default:
                    break;
            }
        };
        
        _mainTV.infoFooterView.exitBtnClick = ^(){
          GL_DISPATCH_MAIN_QUEUE(^{
              if (ISBINDING) {
                  GL_ALERT_E(@"退出账号前需要先断开与设备的连接");
              } else {
                  [GL_USERDEFAULTS removeObjectForKey:@"ACCOUNT"];
                  
                  [ws changeUserInfo];
                  [ws presentViewController:[LoginViewController new] animated:true completion:^{
                      //退出环信
                      EMError *error = [[EMClient sharedClient] logout:YES];
                      if (!error) {
                          NSLog(@"退出成功");
                      }
                      //退出有赞登录
                      [YZSDK logout];
                      
                      GL_ALERT_S(@"已退出登录");
                  }];
              }
          });
        };
    }
    return _mainTV;
}

- (STPersonInfoViewController *)infoVC
{
    if (!_infoVC) {
        _infoVC = [STPersonInfoViewController new];
    }
    return _infoVC;
}

- (WoAccountSecurityViewController *)accountSecurityVC
{
    _accountSecurityVC = [WoAccountSecurityViewController new];
    return _accountSecurityVC;
}

- (HelpAndFeedBackViewController *)helpAndFeedBackVC
{
    if (!_helpAndFeedBackVC) {
        _helpAndFeedBackVC = [HelpAndFeedBackViewController new];
    }
    return _helpAndFeedBackVC;
}

- (AboutViewController *)aboutVC
{
    if (!_aboutVC) {
        _aboutVC = [AboutViewController new];
    }
    return _aboutVC;
}

- (SettingsViewController *)settingsVC
{
    if (!_settingsVC) {
        _settingsVC = [SettingsViewController new];
    }
    return _settingsVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
