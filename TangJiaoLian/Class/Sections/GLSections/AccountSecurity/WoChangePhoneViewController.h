//
//  WoChangePhoneViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"

@interface WoChangePhoneViewController : GLViewController

@property (nonatomic,strong) UILabel     *hintLbl;/**< 提示标签 */
@property (nonatomic,strong) GLTextField *phoneTF;/**< 手机号录入框 */
@property (nonatomic,strong) GLNextBtn   *nextBtn;/**< 下一步按钮 */

@end
