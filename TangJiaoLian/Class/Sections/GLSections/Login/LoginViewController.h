//
//  LoginViewController.h
//  RTLibrary-ios
//
//  Created by 高临原 on 16-6-13.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "GLViewController.h"

typedef void(^loginFinishBlock)();

@interface LoginViewController : GLViewController

@property (nonatomic,strong) NSDictionary *userLoginInfo;
@property (nonatomic,copy) loginFinishBlock loginFinishBlock;

@end
