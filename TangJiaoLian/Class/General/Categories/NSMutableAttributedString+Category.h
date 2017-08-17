//
//  NSMutableAttributedString+Category.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/10/14.
//  Copyright © 2016年 随糖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Category)


/**
 设置可变字符串部分文字高亮

 @param allStr 整体文字
 @param specifiStr 高亮文字
 @param color 高亮颜色
 @param font 文字大小
 @return 返回带有高亮文字的可变字符串
 */
+ (NSMutableAttributedString *)setAllText:(NSString *)allStr andSpcifiStr:(NSString *)specifiStr withColor:(UIColor *)color specifiStrFont:(UIFont *)font;

/**
 * @brief 返回一个指定下标指定颜色的AttributedString,最后一个长度可以不写
 */
+ (NSAttributedString *)strWithStr:(NSString *)str AndColorArr:(NSArray<UIColor *> *)colorArr  ColorWithIdx:(NSNumber *)idx,...NS_REQUIRES_NIL_TERMINATION;

@end
