//
//  FeedBackView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef  void(^NextBtnClick)();

@protocol FeedBackViewDelegate <NSObject,UITextFieldDelegate>

@optional
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

@interface FeedBackView : GLView

@property (nonatomic,strong) UILabel              *hintLbl;/**< 提示文字 */

@property (nonatomic,strong) GLTextView           *feedBackTV;/**< 意见反馈输入框 */

@property (nonatomic,strong) GLTextField          *mailOrPhoneTF;/**< 邮箱或者手机号输入框 */

@property (nonatomic,strong) GLNextBtn            *nextBtn;/**< 提交按钮 */

@property (nonatomic,weak  ) id<FeedBackViewDelegate> delegate; /**< 代理对象 */


@end
