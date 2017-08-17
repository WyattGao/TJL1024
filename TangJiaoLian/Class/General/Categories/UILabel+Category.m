//
//  UILabel+Category.m
//  Diabetes
//
//  Created by 高临原 on 16/1/19.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

- (NSInteger)LineNum
{
    CGFloat labelHeight = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.font.lineHeight);
    return [count integerValue];
}

- (NSInteger)getLineNumWithWidth:(CGFloat)LblWidth
{
    CGFloat labelHeight = [self sizeThatFits:CGSizeMake(LblWidth, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / self.font.lineHeight);
    return [count integerValue];
}

- (float)getLabelHeight
{
    NSDictionary *attributes =@{NSFontAttributeName:self.font};
    
    //根据label目前的宽度
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return textSize.height;
}

- (float)getLabelWidth
{
    return [UILabel getLabelWidthWithText:self.text WithFont:self.font];
}

+ (float)getLabelWidthWithText:(NSString *)text WithFont:(UIFont *)font
{
    NSDictionary *attributes =@{NSFontAttributeName:font};
    
    //仅计算文字的宽度
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return textSize.width;
}

- (CGSize)getLabelSize
{
    NSDictionary *attributes =@{NSFontAttributeName:self.font};
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return textSize;
}


@end
