//
//  SlideRuleView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "TRSDialScrollView.h"

@interface SlideRuleView : GLView

///标尺
@property (nonatomic,strong) TRSDialScrollView *dialScrollView;

///提示标签
@property (nonatomic,strong) UILabel *hintLbl;

///血糖单位
@property (nonatomic,strong) UILabel *unitLbl;

///标尺刻度线
@property (nonatomic,strong) UIImageView *scaleIV;

///当前选中的血糖值
@property (nonatomic,strong) UILabel *valueLbl;

///加号按钮
@property (nonatomic,strong) GLButton *addBtn;

///减号按钮
@property (nonatomic,strong) GLButton *deductBtn;

+ (instancetype)share;
//显示滑尺
+ (void)showWithCurrentValue:(CGFloat)currentValue;
//关闭滑尺
+ (void)dismiss;

@end
