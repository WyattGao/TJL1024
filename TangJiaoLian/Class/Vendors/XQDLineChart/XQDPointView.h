//
//  XQDPointView.h
//  XQDLineGraph
//
//  Created by 徐其东 on 16/7/15.
//  Copyright © 2016年 xuqidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQDColor.h"
#import "XQDApi.h"
#import "GLPopupView.h"

@protocol PointViewDelegate <NSObject>

- (void)reloadMainSVWithPointX:(CGFloat)pointX;

@end

@interface XQDPointView : UIView


@property (nonatomic, strong)  XQDColor *xqdColor;/*线和点的颜色*/

@property (nonatomic,weak) id<PointViewDelegate> delegate;

//重写init
-(instancetype)initWithFrame:(CGRect)frame andXQDColor:(XQDColor *)xqdColor;

//刷新
- (void)refreshView:(CGRect)frame;

- (void)setChartLine_PointArr:(NSArray *)chartLine_PointArr;

@end
