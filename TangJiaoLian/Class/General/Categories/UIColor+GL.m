//
//  UIColor+GL.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/10/24.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "UIColor+GL.h"

@implementation UIColor (GL)

-(BOOL)compareColor:(UIColor*)compareColor
{
    if (CGColorEqualToColor(self.CGColor, compareColor.CGColor))
    {
        NSLog(@"颜色相同");
        return YES;
    }
    else
    {
        NSLog(@"颜色不同");
        return NO;
    }
}


@end
