//
//  STDataAnalysisViewTriangle.m
//  Diabetes
//
//  Created by 高临原 on 16/4/7.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STDataAnalysisViewTriangle.h"

#define PI 3.14159265358979323846

@implementation STDataAnalysisViewTriangle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //    UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    //    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    //    CGContextSetLineWidth(context, 3.0);//线的宽度
    //    CGContextAddArc(context, 0, 40, 40, 0, 2*PI, 0); //添加一个圆
    //    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    //    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    //    /*画三角形*/
    //只要三个点就行跟画一条线方式一样，把三点连接起来
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor  (context, [TCOL_MAIN CGColor]);//填充颜色
    CGContextSetStrokeColorWithColor(context, [TCOL_MAIN CGColor]);//线框颜色
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(self.width/2, 0);//坐标1
    sPoints[1] =CGPointMake(0, self.height);//坐标2
    sPoints[2] =CGPointMake(self.width, self.height);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    CGContextClosePath(context);//封起来
    CGContextStrokePath(context); //完成绘制
    
}

@end
