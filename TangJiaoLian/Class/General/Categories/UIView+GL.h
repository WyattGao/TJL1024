//
//  UIView+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/17.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GL)

/**
 * @brief 位置
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;

@property (nonatomic,assign) CGFloat borderWidth;   /**< 边框宽度 */
@property (nonatomic,strong) UIColor *borderColor;  /**< 边框颜色 */
@property (nonatomic,assign) CGFloat cornerRadius;  /**< 边框圆角度 */
@property (nonatomic,assign) BOOL masksToBounds;




/**
 * @brief 获取所在的主视图控制器
 */
- (UIViewController*)getFormViewController;

/**
 * @brief 删除所有子View
 */
- (void)removeAllChildView;

+ (UIImage*)imageOfView:(UIView*)view;



@end
