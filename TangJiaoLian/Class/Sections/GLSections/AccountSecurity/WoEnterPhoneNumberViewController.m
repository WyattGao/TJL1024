//
//  WoEnterPhoneNumberViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/29.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoEnterPhoneNumberViewController.h"

@interface WoEnterPhoneNumberViewController ()


@end

@implementation WoEnterPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    switch (self.type) {
        case EnterPhoneNuamberForChangePassWord:
            [self setNavTitle:@"密码找回"];
            break;
        case EnterPhoneNumaberForChangePhoneNumber:
            [self setNavTitle:@"更换手机号"];
            break;
        case EnterPhoneNuamberForNewPhoneNumber:
            [self setNavTitle:@"更换手机号"];
            break;
        default:
            break;
    }
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
