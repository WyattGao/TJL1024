//
//  UITextView+Category.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/7.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "UITextView+Category.h"

@implementation UITextView (Category)

- (float)getChangeHeight
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    detailTextView.font = [UIFont systemFontOfSize:self.font.pointSize];
    detailTextView.text = self.text;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(self.width,CGFLOAT_MAX)];
    
    return deSize.height;
}

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    self.attributedText = attributedString;
}

@end
