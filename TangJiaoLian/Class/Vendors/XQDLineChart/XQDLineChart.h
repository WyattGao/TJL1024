//
//  XQDLineChart.h
//  XQDLineGraph
//
//  Created by 徐其东 on 16/7/14.
//  Copyright © 2016年 xuqidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQDApi.h"
#import "XQDScrollView.h"
#import "XQDColor.h"

@interface XQDLineChart : UIView


@property (nonatomic, strong)  XQDColor *xqdColor;/*线和点的颜色*/


@property (nonatomic, strong) UIScrollView *mainScroll;/**/

@property (nonatomic, assign) CGRect chartLine_fream;

/*初始化图表*/
- (void)initLineChart;
//重写init
- (instancetype)initWithFrame:(CGRect)frame andXQDColor:(XQDColor*)xqdColor;
//刷新图表
- (void)refreshChartLine:(XQDColor*)xqdColor;

//双击事件
- (void)tapGesture:(UITapGestureRecognizer *)tap;
//缩小
- (void)minChartLineView;
//将scrollview定位到当前的时间点
- (void)goToNowPoint;

@end
