//
//  NSMutableAttributedString+Category.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/10/14.
//  Copyright © 2016年 随糖. All rights reserved.
//

#import "NSMutableAttributedString+Category.h"

@implementation NSMutableAttributedString (Category)

+ (NSMutableAttributedString *)setAllText:(NSString *)allStr andSpcifiStr:(NSString *)specifiStr withColor:(UIColor *)color specifiStrFont:(UIFont *)font {
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];

    if (color == nil) {
        color = RGB(252, 79, 8);
    }
    //默认字体大小设为17pt
    if (font == nil) {
        font = [UIFont systemFontOfSize:17.];
    }
    //    NSArray *array = [allStr componentsSeparatedByString:specifiStr];//array.cout-1是所有字符特殊字符出现的次数
    NSRange searchRange = NSMakeRange(0, [allStr length]);
    NSRange range;
    //拿到所有的相同字符的range
    while
        ((range = [allStr rangeOfString:specifiStr options:0 range:searchRange]).location != NSNotFound) {
            //改变多次搜索时searchRange的位置
            searchRange = NSMakeRange(NSMaxRange(range), [allStr length] - NSMaxRange(range));
            //设置富文本
            [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
    return mutableAttributedStr;
}

+ (NSAttributedString *)strWithStr:(NSString *)str AndColorArr:(NSArray<UIColor *> *)colorArr ColorWithIdx:(NSNumber *)idx, ...
{
    
    NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableArray *idxArr = [NSMutableArray arrayWithObject:idx];
    va_list argumentList;
    va_start(argumentList, idx);
    
    id eachObject;
    
    while ((eachObject = va_arg(argumentList, id))) {
        [idxArr addObject:eachObject];
    }
    va_end(argumentList);
    
    if ([idxArr.lastObject integerValue] == -1) {
        [idxArr removeLastObject];
        [idxArr addObject:@(str.length - [idxArr.lastObject integerValue])];
    } else if (idxArr.count % 2){
        [idxArr addObject:@(str.length - [idxArr.lastObject integerValue])];
    } else if (idxArr.count == 2){
        [idxArr addObject:idxArr.lastObject];
        [idxArr addObject:@(str.length - [idxArr.lastObject integerValue])];
    }
    
    NSInteger j = 1;
    NSInteger k = 0;
    
    for (NSInteger i = 0;i < colorArr.count;i++) {
        [tmpStr addAttribute:NSForegroundColorAttributeName value:colorArr[i] range:NSMakeRange([idxArr[k] integerValue],[idxArr[j] integerValue])];
        j += 2;
        k += 2;
    }
    
    
    return tmpStr;
}


@end
