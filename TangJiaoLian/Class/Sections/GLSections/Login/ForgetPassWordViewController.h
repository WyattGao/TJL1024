//
//  ForgetPassWord.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/26.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "GLViewController.h"
#import "ForgetPassWordCell.h"

@protocol ForgetPassWordViewControllerDelegate <NSObject>

- (void)registerUserPhone:(NSString *)phoneNum;

@end

@interface ForgetPassWordViewController : GLViewController

@property (nonatomic,weak) id<ForgetPassWordViewControllerDelegate> delegate;

@property (nonatomic,assign) ChangePassWordType type;

@end
