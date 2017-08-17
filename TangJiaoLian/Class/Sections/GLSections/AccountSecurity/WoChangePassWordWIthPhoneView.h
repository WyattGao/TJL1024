//
//  WoChangePassWordWIthPhoneView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^CodeBtnClick)();
typedef void(^NextBtnClick)();

@interface WoChangePassWordWIthPhoneView : GLView

@property (nonatomic,strong) GLTextField *codeTF;   /**< 验证码输入框 */
@property (nonatomic,strong) GLButton    *codeBtn;  /**< 验证码获取按钮 */
@property (nonatomic,strong) GLButton    *nextBtn;  /**< 下一步 */
@property (nonatomic,strong) UILabel     *hintLbl;  /**< 提示标签 */

@property (nonatomic,copy) NSString *bindingPhoneStr; /**< 现在绑定的手机号 */

@property (nonatomic,copy) CodeBtnClick codeBtnClick;
@property (nonatomic,copy) NextBtnClick nextBtnClick;

- (void)changeCodeBtnState;

@end
