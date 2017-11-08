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

@property (nonatomic,strong) NSMutableDictionary *userBaseDic;

@property (nonatomic,strong) NSMutableDictionary *patientDic;

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
    self.navHide = true;
        
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)createData
{
    //获取用户数据，与线上同步
    NSUserDefaults *_U                = [NSUserDefaults standardUserDefaults];
    _userBaseDic = [[NSMutableDictionary alloc]initWithObjects:@[USER_ACCOUNT] forKeys:@[@"ACCOUNT"]];
    _patientDic  = [NSMutableDictionary new];
    
    NSDictionary * dict = @{
                            FUNCNAME:@"getUserInfo",
                            INFIELD:@{
                                    @"ACCOUNT":USER_ACCOUNT,    //手机号码
                                    @"DEVICE":@"1"        //0:android 1:ios
                                    },
                            OUTFIELD:@[
                                    @"RETVAL",
                                    @"RETMSG"
                                    ],
                            OUTTABLE:@{}
                            };
    [GL_Requst postWithParameters:dict SvpShow:false success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            if (GETRETVAL) {
                NSDictionary *dic = [[[[response objectForKey:@"Result"] objectForKey:@"OutTable"] objectAtIndex:0] objectAtIndex:0];
                
                
                [_userBaseDic setObject:[dic getStringValue:@"ACCOUNT"] forKey:@"ACCOUNT"];
                [_userBaseDic setObject:[dic getStringValue:@"USERNAME"] forKey:@"USERNAME"];
                [_userBaseDic setObject:[dic getStringValue:@"USERNAME"] forKey:@"NICKNAME"];
                [_userBaseDic setObject:[dic getStringValue:@"BIRTHDAY"] forKey:@"BIRTHDAY"];
                
                [_patientDic setValuesForKeysWithDictionary:dic];
                [_patientDic removeObjectForKey:@"USERNAME"];
                [_patientDic removeObjectForKey:@"NICKNAME"];
                [_patientDic removeObjectForKey:@"ACCOUNT"];
                [_patientDic removeObjectForKey:@"BIRTHDAY"];
                
                
                 //保存用户数据
                 [_U setObject:[dic getStringValue:@"PIC"]       forKey:@"PIC"];
                 //昵称 统一用UserName字段
                 [_U setObject:[dic getStringValue:@"USERNAME"]  forKey:@"NICKNAME"];
                 //身高
                 [_U setObject:[dic getStringValue:@"HEIGHT"]    forKey:@"HEIGHT"];
                 //体重
                 [_U setObject:[dic getStringValue:@"WEIGHT"]    forKey:@"WEIGHT"];
                 //腰围
                 [_U setObject:[dic getStringValue:@"WAISTLINE"] forKey:@"WAISTLINE"];
                 //已保存的BMI
                 [_U setObject:[dic getStringValue:@"BMI"]       forKey:@"BMI"];
                 //出生年月
                 [_U setObject:[dic getStringValue:@"BIRTHDAY"]  forKey:@"AGE"];
                 //用户名（昵称）
                 [_U setObject:[dic getStringValue:@"USERNAME"]  forKey:@"USERNAME"];
                 //用户号
                 [_U setObject:[dic getStringValue:@"ACCOUNT"]   forKey:@"ACCOUNT"];
                 //性别
                 [_U setObject:[dic getStringValue:@"SEX"]       forKey:@"SEX"];
                 //绑定的手机号
                 [_U setObject:[dic getStringValue:@"PHONE"]     forKey:@"PHONE"];
                 //糖尿病类型
                 [_U setObject:[dic getStringValue:@"DIABETESTYPE"] forKey:@"DIABETESTYPE"];
                 //心率
                 [_U setObject:[dic getStringValue:@"HEARTRATE"] forKey:@"HEARTRATE"];
                 //高血压
                 [_U setObject:[dic getStringValue:@"HIGHESTHYPERTENSION"] forKey:@"HIGHESTHYPERTENSION"];
                 //低血压
                 [_U setObject:[dic getStringValue:@"LOWESTHYPERTENSION"] forKey:@"LOWESTHYPERTENSION"];
                 //确诊病史(年)
                 [_U setObject:[dic getStringValue:@"ILLYEARS"] forKey:@"ILLYEARS"];
                 //治疗方式
                 [_U setObject:[dic getStringValue:@"TREATTYPE"] forKey:@"TREATTYPE"];
                 
                 [_U synchronize];
                 
                
                //存储记录
                [self.mainTV.infoHeaderView refresh];
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } else {
            GL_ALERT_E([response getStringValue:@"Message"]);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"获取用户信息失败");
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
                    ws.infoVC.patientDic  = ws.patientDic;
                    ws.infoVC.userBaseDic = ws.userBaseDic;
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
