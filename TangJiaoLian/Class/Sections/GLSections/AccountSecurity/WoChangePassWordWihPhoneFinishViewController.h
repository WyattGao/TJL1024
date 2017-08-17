//
//  WoChangePassWordWihPhoneFinishViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/25.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"
#import "GLNextBtn.h"

typedef NS_ENUM(NSInteger,ChangePassWordOrPhoneViewControllerType){
    GLFinishChangePassWord = 0, /**< 修改密码 */
    GLFinishChangePhone    = 1, /**< 修改手机号 */
    GLFinishFeedBack       = 2  /**< 提交反馈 */
};

@interface WoChangePassWordWihPhoneFinishViewController : GLViewController

@property (nonatomic,assign) ChangePassWordOrPhoneViewControllerType type;
@property (nonatomic,strong) UIImageView *finishIV; /**< 完成提示图案 */
@property (nonatomic,strong) UILabel *hintLbl;      /**< 完成提示文字 */
@property (nonatomic,strong) GLNextBtn *finishBtn;  /**< 完成按钮 */

@end
