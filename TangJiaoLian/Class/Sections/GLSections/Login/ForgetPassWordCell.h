//
//  ForgetPassWordCell.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/26.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ChangePassWordType){
    ForgetPassWord  = 0,  /**< 修改密码 */
    Register = 1          /**< 快速注册 */
};

static NSString *sAreaCodeMark = @"AreaCodeMark";   /**< 选择区号的cell */

@interface ForgetPassWordCell : UITableViewCell

@property (nonatomic,strong) GLTextField *textField; /**< 各cell输入框 */

@property (nonatomic,strong) GLButton *getCodeBtn;

@property (nonatomic,assign) ChangePassWordType type;


@end
