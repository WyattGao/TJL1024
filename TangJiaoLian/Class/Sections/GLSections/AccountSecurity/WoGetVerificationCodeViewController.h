//
//  WoGetVerificationCodeViewController
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
// 获取验证码

#import "GLViewController.h"

typedef NS_ENUM(NSInteger,GetVerificationCodeeViewControllerType){
    GetVerificationCodePassWord = 0,  /**< 修改密码获取验证码 */
    GetVerificationCodeOldPhone = 1,  /**< 修改手机号旧号码获取验证码 */
    GetVerificationCodeNewPhone = 2   /**< 修改手机号新号码获取验证码 */
};

@interface WoGetVerificationCodeViewController : GLViewController

@property (nonatomic,copy) NSString *phoneNumberStr;

@property (nonatomic,assign) GetVerificationCodeeViewControllerType viewType;

@end
