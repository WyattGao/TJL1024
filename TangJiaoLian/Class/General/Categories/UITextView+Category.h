//
//  UITextView+Category.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/7.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Category)

/**
 *  通过textview的文字来重新计算textview的高度
 *
 *  @return 返回重新计算后的TextView的高度
 */
- (float)getChangeHeight;


/**
 textview设置行间距

 @param text 文字
 @param lineSpacing 行间距
 */
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

@end
