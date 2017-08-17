//
//  WoAccountSecurityViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoAccountSecurityViewController.h"
#import "WoAccountSecurityTableView.h"
#import "WoChangePassWordWithPhoneViewController.h"

@interface WoAccountSecurityViewController ()

@property (nonatomic,strong) WoAccountSecurityTableView *mainTV;

@property (nonatomic,strong) WoChangePassWordWithPhoneViewController *changeVC;

@end

@implementation WoAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navHide = false;
}

- (void)createUI
{
    [self setNavTitle:@"账号安全"];
    [self setLeftBtnImgNamed:nil];
    
    self.view.backgroundColor = TCOL_BGGRAY;
    
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(21 + 64, 0, 0, 0));
    }];
}

- (WoAccountSecurityTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [WoAccountSecurityTableView new];
        
        WS(ws);
        
        _mainTV.tableViewDidSelect = ^(NSIndexPath *indexPath) {
            
            switch (indexPath.row) {
                case 0:
                {
                    [ws pushWithController:ws.changeVC];
                }
                    break;
                case 1:
                    break;
                default:
                    break;
            }
        };
    }
    return _mainTV;
}

- (WoChangePassWordWithPhoneViewController *)changeVC
{
    if (!_changeVC) {
        _changeVC                = [WoChangePassWordWithPhoneViewController new];
        _changeVC.phoneNumberStr = [GL_USERDEFAULTS getStringValue:@"PHONE"];
    }
    return _changeVC;
}

@end
