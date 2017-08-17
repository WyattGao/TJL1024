//
//  GLButton.h
//  SuiTangNew
//
//  Created by 高临原 on 16/6/13.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BtnGraphicLayout){
    DEFAULT    = 0,
    PICTOP     = 1,
    PICBOM     = 2,
    PICRIGHT   = 3,
    PICLEFT    = 4,
    PICCENTER  = 5,
    TEXTCENTER = 6   /**< 文字居中 */
};

typedef NS_ENUM(NSInteger,GLButtonType){
    GLTypeSubmit = 0   /**< 提交类按钮 */
};

@interface GLButton : UIButton

@property (nonatomic,strong) UIImageView *iv;
@property (nonatomic,strong) UILabel *lbl;

@property (nonatomic,strong) UIImage *selImage; /**< 选中状态的Image */
@property (nonatomic,strong) UIImage *image;    /**< 非选中状态的Image */

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selTextColor;         /**< 文字选中颜色 */
@property (nonatomic,strong) UIColor *highlightedTextColor; /**< 文字高亮颜色 */

@property (nonatomic,strong) UIColor *nomBackGroundColor; /**< 非选中背景色 */
@property (nonatomic,strong) UIColor *selBackGroundColor; /**< 选中背景色 */
@property (nonatomic,strong) UIColor *highlightedBackGroundColor; /**< 高亮背景色 */

@property (nonatomic,copy) NSString *text;     
@property (nonatomic,copy) NSString *selText;

@property (nonatomic,strong) UIFont *font;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic,assign) CGFloat borderWidth;

@property (nonatomic,strong) UIColor *borderColor;            /**< 没有设定状态下的边框色 */
@property (nonatomic,strong) UIColor *nomBorderColor;         /**< 普通边框色 */
@property (nonatomic,strong) UIColor *selBorderColor;         /**< 选中边框色 */
@property (nonatomic,strong) UIColor *highlightedBorderColor; /**< 高亮边框色 */

@property (nonatomic,assign) BtnGraphicLayout graphicLayoutState;  /**< 文字图片排序方式 */
@property (nonatomic,assign) CGFloat graphicLayoutSpacing;         /**< 文字图片间距 */

/**
 *  设置按钮背景色
 *
 *  @param backgroundColor 背景色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state;

- (instancetype)initButtonWithType:(GLButtonType)buttonType;

@end
