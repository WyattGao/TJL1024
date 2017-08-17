//
//  GLTextField.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/13.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LimitType)
{
    GLTextFieldTypeDefault                = 0,/**< 无限制 */
    GLTextFieldTypeDecimalPointAndDigital = 1,/**< 只能输入数字和小数点 */
    GLTextFieldTypeOnlyNumbers            = 2 /**< 只能输入数字 */
};

@protocol GLTextFieldDelegate <NSObject,UITextFieldDelegate>

@optional
- (void)textfieldFieldDidChange:(UITextField *)textField;

@end

@interface GLTextField : UITextField

@property (nonatomic,assign) CGFloat borderWidth;        /**< 边框宽度 */
@property (nonatomic,strong) UIColor *borderColor;       /**< 边框颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;  /**< 提示文字颜色 */
@property (nonatomic,assign) NSInteger textLength;       /**< 输入字数限制 */

@property (nonatomic,weak) id<GLTextFieldDelegate> glDelegate;

@property (nonatomic,assign) LimitType limitType;

@property (nonatomic,copy) NSString *placeholderStr;
@property (nonatomic,strong) UILabel *glPlaceLbl;

@end
