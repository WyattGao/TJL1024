//
//  WoEnterPhoneNumberView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/29.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef NS_ENUM(NSInteger,EnterPhoneNuamberType) {
    EnterPhoneNuamberForChangePassWord    = 0, /**< 修改密码第一步输入手机号 */
    EnterPhoneNumaberForChangePhoneNumber = 1, /**< 修改手机号第一步输入手机号 */
    EnterPhoneNuamberForNewPhoneNumber    = 2  /**< 修改手机号第三部输入新手机号 */
};

@interface WoEnterPhoneNumberView : GLView

@property (nonatomic,strong) UILabel *hintLbl;

@property (nonatomic,strong) GLTextField *phoneTF;

@property (nonatomic,strong) GLNextBtn *nextBtn;

@end
