//
//  UILabel+Category.h
//  Diabetes
//
//  Created by 高临原 on 16/1/19.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

@property (nonatomic,assign,readonly) NSInteger LineNum;

- (NSInteger)getLineNumWithWidth:(CGFloat)LblWidth;

/**
 *  通过Label的文字来重新计算Label的高度
 *
 *  @return 返回重新计算后的Label的高度
 */
- (float)getLabelHeight;

- (float)getLabelWidth;

+ (float)getLabelWidthWithText:(NSString *)text WithFont:(UIFont *)font;

- (CGSize)getLabelSize;


@end
