//
//  WoChangePassWordWithPhoneViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"

typedef NS_ENUM(NSInteger,ChangePassWordOrPhoneViewControllerType){
    ChangePassWord = 0,
    ChangePhone
};

@interface WoChangePassWordWithPhoneViewController : GLViewController

@property (nonatomic,copy) NSString *phoneNumberStr;

@property (nonatomic,assign) ChangePassWordOrPhoneViewControllerType viewType;

@end
